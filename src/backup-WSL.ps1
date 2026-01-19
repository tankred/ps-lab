#----------------------------------------------------------------------------
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
$version = "0.2.8"
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
# function writelog($e){
# 	Add-Content $log $e""
# }
function writelog { param([string]$Message) try { Add-Content -Path $log -Value $Message } catch { Write-Warning "Kon niet naar logbestand schrijven: $_" } }

function waitforenter {
    param(
        [string]$Message = "Press Enter to Continue..."
    )
    #? Write-Host $Message
    Write-Output $Message
    $null = Read-Host
}

function check($distroparam) {
  $distroparam
  $wslinfo = wsl --list --running
  # $singlelinewslrunning = $wslinfo -replace "`r?`n(?!`r?`n)", ''
  $arrwslinfo = $wslinfo.Split("`r`n")
  # check if multiple distros are spinning
Write-Output "Total Elements in array-->" $arrwslinfo.Count
# Write-Host "First element in array-->" $arrwslinfo[0]
# Write-Host "Second element in array-->" $arrwslinfo[2]
  if ($wslinfo -eq 'Er zijn geen actieve distributies.') { 
    "continue" 
      " Continue script " 
  }
  else {
    # $arrwslinfo[2]
      " IF $distroparam IS Running "
      "--START WSL INFO --"
      foreach ($item in $arrwslinfo) {
        $item
        if ($item -contains $distroparam) {
          " HALT script "
          " Send poweroff to running distro "
          "sudo systemctl poweroff"
        } 
      }
      "-- END  WSL INFO --"
      waitforenter
  }
}

function prunebackups() {
  Begin{
    "List backups"
    #? ls *FedoraLinux-42* -name
    # $backupdir
    $distro
    ls $backupdir\*$distro* -name
  }
  Process{
    Try{
      "Try remove old backups"
      "Goal: forget --keep-daily 7 --keep-weekly 5 --keep-monthly 12 --keep-yearly 75"
      "For now: Keep 7"
      Get-ChildItem -Recurse -File $backupdir\*$distro* | Sort CreationTime -desc | Select -skip 7 | Remove-Item -Force
    }
    Catch{
      "Something went wrong."
      Break
    }
  }
}

function processdata(){
  Param()
  Begin{
    $distro
    wsl -l -v # show installed distro(s)"
  }
  Process{
    Try{
      $BACKUPDISTRO=$distro
      # $distro
      check $distro
      # waitforenter
      "# backup $BACKUPDISTRO "
      wsl --terminate $BACKUPDISTRO # stop distro 
      # backup distro AND will stop a distro from running
       $target = $backupdir + "\wsl-" + $BACKUPDISTRO + "-" + $year + $month + $dayn + ".tar"
       $target
      wsl --export $BACKUPDISTRO $target
    }
    Catch{
      "Something went wrong."
      Break
    }
  }
  End{
    If($?){ # only execute if the function was successful.
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
#?  Write-Host "Arg: $arg";
  if ($arg -eq "-help" -OR $arg -eq "-h" -OR $arg -eq "--help" -OR $arg -eq "help" ) {
    #? write-output "CLI usage"
    $helpinfo = @"
#SYNTAX
#    .\$app -distro <string>
#
#OPTIONAL PARAMETERS
#       -h
#       help
#    	-help
#    	--help
#       -V
#       version
#       -version
#       --version
#
#SAMPLE
#PS > .\$app -h
#PS > .\$app -V
#PS > .\backup-WSL.ps1 -distro 'FedoraLinux-43'
#
#(END)
"@;
    write-host $helpinfo -fore yellow;
    exit;
  } 
  if ($arg -eq "-version" -OR $arg -eq "--version" -OR $arg -eq "version" -OR $arg -eq "-V") {
    # write-output "$app"
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
# write-output ">"$app$version
"---------------------------------------------------"
# write-output $info
write-output $info $distro
"---------------------------------------------------"
writelog(get-date)
writelog($app+$version)
#####################################################
processdata;
prunebackups;
#####################################################
writelog("--------------------------------------")	
"EOF"
