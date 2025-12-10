#----------------------------------------------------------------------------
# PowerShell 7.5 
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
#--------------------------------------------------------------------------------------------
#Param
#--------------------------------------------------------------------------------------------
PARAM ( 
    [string]$distro = "F42"
)
#--------------------------------------------------------------------------------------------
#Ini
#--------------------------------------------------------------------------------------------
# START SET
$debug = 1
$version = "0.2.0"
$app = "backup-WSL.ps1"
$info = "backup WSL"
$ld = "c:\tmp\log\"
$backupdir = "C:\office\mirror\WSL-Fedora"
 # END SET
$month = "00"+(get-date).month
$month = $month.substring($month.length - 2 , 2)
$year = (get-date).year
$da = "00"+(get-date).day 
$dayn = $da.substring($da.length - 2,2)
$log = $ld + "pslog_"+$year+$month+$dayn+".txt"
#--------------------------------------------------------------------------------------------
## Functions
#--------------------------------------------------------------------------------------------
function writelog($e){
	Add-Content $log $e""
}

function waitforenter {
    param(
        [string]$Message = "Press Enter to Continue..."
    )
    Write-Host $Message
    $null = Read-Host
}

function check($distroparam) {
  $distroparam
  $wslinfo = wsl --list --running
  if ($wslinfo -eq 'Er zijn geen actieve distributies.') { 
    "continue" 
      " Continue script " 
  }
  else {
      " IF $distroparam IS Running "
      " HALT script "
      " Send poweroff to running distro "
      "sudo systemctl poweroff"
     waitforenter
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
#--------------------------------------------------------------------------------------------
## Main
#--------------------------------------------------------------------------------------------
foreach ($arg in $args)
{
#  Write-Host "Arg: $arg";
  if ($arg -eq "-help" -OR $arg -eq "-h" -OR $arg -eq "--help" -OR $arg -eq "help" ) {
    write-host "CLI usage"
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
    write-host $helpinfo -fore white;
    exit;
  } 
  if ($arg -eq "-version" -OR $arg -eq "--version" -OR $arg -eq "version" -OR $arg -eq "-V") {
    write-host "$app"
    write-host "version $version"
    exit;
  }
  if ($arg -eq "-distro" -OR $arg -eq "-d") {
    "Distro specified"
    $distro
  }
}
$hdata = [string]$args[0]
write-host $hdata
write-host ">"$app$version
"---------------------------------------------------"
write-host $info
"---------------------------------------------------"
writelog(get-date)
writelog($app+$version)
#####################################################
processdata;
#####################################################
writelog("--------------------------------------")	
"EOF"
