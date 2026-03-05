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
)
#------------------------------------------------------------------
#Ini
#------------------------------------------------------------------
# START SET
  $debug = 1
  $version = "0.1.2"
  $app = "backup-TA.ps1"
  $info = "backup TA"
  $ld = "C:\tmp\log" 
  if (!(Test-Path $ld)) { New-Item -ItemType Directory -Path $ld -Force }
  $srcdir = "g:\Mijn Drive\Team-August\"
  $backupdir = "g:\.shortcut-targets-by-id\1DrNK512NxdJpe9m78nXETQv2OrIgAou9\Backup-Team-August\"
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

function processdata(){
  Param()
  Begin{
    "check GGL drive"
  }
  Process{
    Try{
      "TRY list target dir ! "
      "Try backup"
      $backupdir
      # cp c:\tmp\nodata\upload-nodata.zip $backupdir [OK]
      # WIP cp $srcdir $backupdir
      # Copy-Item -Path $srcdir -Destination $backkupdir -Recurse
      # With overwrite
      # Skip desktop.ini files
      # Download gdoc files and convert to docx
      # Explore ggl drive cmdlets https://www.go2share.net/article/google-drive-cmdlets
      # Keep long names
    }
    Catch{
      "Something went wrong"
      Break
    }
  }
  End{
    If($?){ # only execute if the function was successful.
      "Full backup created"
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
"---------------------------------------------------"
writelog(get-date)
writelog($app+$version)
#####################################################
processdata;
#####################################################
writelog("--------------------------------------")	

