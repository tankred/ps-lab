#---------------------------------------------------------------------------
# PowerShell 7.5.4 
# by Kurt Duyck (kurt.duyck@vives.be)
#
#NAME
#
#SYNOPSIS
# Name: backup-TA.ps1 
# Purpose: backup team August ggl drive
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
  $version = "0.1.0"
  $app = "backup-TA.ps1"
  $info = "backup TA"
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
    Write-Output $Message
    $null = Read-Host
}

function check($distroparam) {
  # NEEDS rework: setup matrix: running, stopped vs known unknown
  $wsllist = wsl --list
  $arrwsllist = $wsllist.Split("`r`n")
  Write-Output "Total distros in array-->" $arrwsllist.Count
  # $regexdistro = $distroparam+' (Standaard)'
  $regexdistro = $distroparam
  "-----------M-"
  $regexdistro
  "-----------M-"
  foreach ($item in $arrwsllist) {
    # $item
    if ($item -match $regexdistro) {
       Write-Host "MATCH found: $item"
    }  
    if ($item -like $regexdistro) {
       Write-Host "LIKE found: $item"
    }  
    if ($item -eq $regexdistro) {
       Write-Host "Full match found: $item"
    } 
  }
  # exit
  $wsllistrunning = wsl --list --running
  $arrwsllistrunning = $wsllistrunning.Split("`r`n")
  # check if multiple distros are spinning
  Write-Output "Total running distros in array-->" $arrwsllistrunning.Count
  #   if ($wslinfo -eq 'Er zijn geen actieve distributies.') { 
  #     " Continue script " 
  #     "YAH"
  #     $distroparam
  #       "--START WSL INFO --"
  #       foreach ($item in $arrwslinfo) {
  #         $item
  #       }
  #       "-- END WSL INFO --"
  # 
  #       "--START WSL INFO ALL --"
  #       foreach ($item in $arrwslinfo) {
  #         $item
  #       }
  #       "-- END WSL INFO ALL --"
  # 
  #     $arrwslinfoall
  #     $exists = $arrwslinfoall -contains $distroparam
  #     $exists
  #     $matched = $arrwslinfoall | Select-String -Pattern $distroparam
  #     Write-Host "WSL containing distro: $($matched.Line)"
  #     Write-Host "distro exists in the array: $exists"
  #     if (!$exists) {
  #       "Distro not found ??"
  #       # exit
  #     }
  #   }
  #   else {
  #     #? $arrwslinfo[2]
  #       " IF $distroparam IS Running "
  #       "--START WSL INFO --"
  #       foreach ($item in $arrwslinfo) {
  #         $item
  #         if ($item -contains $distroparam) {
  #           " HALT script "
  #           " Send poweroff to running distro "
  #           "sudo systemctl poweroff"
  #         } 
  #       }
  #       "-- END WSL INFO --"
  #       waitforenter
  #   }
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

function processdata(){
  Param()
  Begin{
    "check GGL drive"
  }
  Process{
    Try{
      "Try backup"
    }
    Catch{
      "Something went wrong"
      Break
    }
  }
  End{
    If($?){ # only execute if the function was successful.
      "proccessdata OK"
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
#    .\$app
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
}
$hdata = [string]$args[0]
write-output $hdata
#? write-output ">"$app$version
"---------------------------------------------------"
write-output $info $distro
"---------------------------------------------------"
writelog(get-date)
writelog($app+$version)
#####################################################
processdata;
# prunebackups;
#####################################################
writelog("--------------------------------------")	
#? "EOF"

