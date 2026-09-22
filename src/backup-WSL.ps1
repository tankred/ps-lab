#--------------------------------------------------------------------------
# PowerShell 7.5.4 
# by Kurt Duyck (kurt.duyck@vives.be)
#
#NAME
#
#SYNOPSIS
# Name: backup-WSL.ps1 
# Purpose: backup WSL distro 
#
#DESCRIPTION
#
#MORE: see help
#
#NOTES
#
#------------------------------------------------------------------
#Param
#------------------------------------------------------------------
PARAM ( 
    [string]$distro = "FedoraLinux-42"
)
#------------------------------------------------------------------
#Ini
#------------------------------------------------------------------
# START SET
  $debug = 1
  $version = "0.5.0"
  $app = "backup-WSL.ps1"
  $info = "backup WSL"
  $ld = "C:\tmp\log" 
  if (!(Test-Path $ld)) { New-Item -ItemType Directory -Path $ld -Force }
  $backupdir = "C:\office\mirror\WSL-Fedora"
# END SET
$month = "00"+(get-date).month
$month = $month.substring($month.length - 2 , 2)
$year = (get-date).year
$da = "00"+(get-date).day 
$dayn = $da.substring($da.length - 2,2)
$log = $ld + "pslog_"+$year+$month+$dayn+".txt"
#------------------------------------------------------------------
## Functions
#------------------------------------------------------------------
function writelog { param([string]$Message) try { Add-Content -Path $log -Value $Message } catch { Write-Warning "Kon niet naar logbestand schrijven: $_" } }

function waitforenter {
  param(
    [string]$Message = "Press Enter to Continue..."
  )
  Write-Output $Message
  $null = Read-Host
}

function state($distroparam) {
  $distrostate = 0
  $wsllistrunning = wsl --list --running -q
  $wsllistrunning
  $wslarrayrunning = $wsllistrunning.Split("`r`n")
  foreach ($item in $wslarrayrunning) {
    if ($distroparam -eq $item) {
       Write-Host "Running match found: $item"
       $distrostate = 1
    } 
  }
  $distrostate
}

function check($distroparam) {
  $distrofound = 0
  # NEEDS rework: setup matrix: running, stopped vs known unknown
  #             | running | stopped | known | unknown
  # WSL F42     |    x    |         |       |    
  # WSL F43     |         |    x    |       |    
  # WSL ARCH    |         |    x    |       |    
  # WSL UBUNTU  |         |    x    |       |    
  # random wsl  |         |         |       |   x
  $wsllist = wsl --list -q
  $wslarray = $wsllist.Split("`r`n")
  foreach ($item in $wslarray) {
    if ($distroparam -eq $item) {
       Write-Host "Full match found: $item"
       $distrofound = 1
    } 
  }
  $distrofound
}

function prunebackups() {
  Begin{
    "Prune backups"
  }
  Process{
    Try{
      "Remove old backups (For now: keep last 7)"
      # "Goal: forget --keep-daily 7 --keep-weekly 5 --keep-monthly 12 --keep-yearly 75"
      Get-ChildItem -Recurse -File $backupdir\*$distro* | Sort CreationTime -desc | Select -skip 7 | Remove-Item -Force
    }
    Catch{
      "Something went wrong."
      Break
    }
  }
}

function listdistro() {
    wsl -l -v # show installed distro(s)"
}

function processdata(){
  Param()
  Begin{
    # $distro
  }
  Process{
    Try{
      $BACKUPDISTRO=$distro
      "# terminate and backup distro $BACKUPDISTRO "
      wsl --terminate $BACKUPDISTRO # stop distro 
      $target = $backupdir + "\wsl-" + $BACKUPDISTRO + "-" + $year + $month + $dayn + ".tar"
      # $target
      wsl --export $BACKUPDISTRO $target
    }
    Catch{
      "Something went wrong"
      Break
    }
  }
  End{
    If($?){ # only execute if the function was successful.
      "proccessdata OK"
      "list running distro"
      wsl --list --running
    }
  }
}
#------------------------------------------------------------------
## Main
#------------------------------------------------------------------
foreach ($arg in $args)
{
  if ($arg -eq "-help" -OR $arg -eq "-h" -OR $arg -eq "--help" -OR $arg -eq "help" ) {
    $helpinfo = @"
#SYNTAX
#    .\$app -distro <string>
#
#OPTIONAL PARAMETERS
#       -h, help, -help, --help
#       -V, version, -version, --version
#SAMPLE
#PS > .\$app -h
#PS > .\$app -V
#PS > .\$app -distro 'FedoraLinux-44'
#
#(END)
"@;
    write-host $helpinfo -fore yellow;
    exit;
  } 
  if ($arg -eq "-version" -OR $arg -eq "--version" -OR $arg -eq "version" -OR $arg -eq "-V") {
    write-output "version $version"
    exit;
  }
  if ($arg -eq "-distro" -OR $arg -eq "-d") {
    "Distro specified"
    $distro
  }
}
$hdata = [string]$args[0]
write-output $hdata
"---------------------------------------------------"
write-output $info $distro
"---------------------------------------------------"
writelog(get-date)
writelog($app+$version)
#####################################################
# $distrolist = listdistro
# $distrolist
$distrofound = check $distro
$distrofound
if ($distrofound -eq 1) { 
  $distrostate = state $distro
  $distrostate
  if ($distrostate -eq 1) {
    "Stop $distro to backup" 
    exit
  } else { # continue backup
    processdata;
  }
} else {
  "distro not found"
  "Please provide a distro from the list"
}
prunebackups;
#####################################################
writelog("--------------------------------------")	

