#--------------------------------------------------------------------------
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
   # [string]$datelastchecked
)
#------------------------------------------------------------------
#Ini
#------------------------------------------------------------------
# START SET
  $debug = 1
  $version = "0.2.2"
  $app = "backup-TA.ps1"
  $info = "backup TA"
  $ld = "C:\tmp\log" 
  if (!(Test-Path $ld)) { New-Item -ItemType Directory -Path $ld -Force }
  $srcdir = "g:\Mijn Drive\Team-August"
  $backupdir = "g:\.shortcut-targets-by-id\1DrNK512NxdJpe9m78nXETQv2OrIgAou9\Backup-Team-August"
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

function processgdoc(){
  # add recurse
  Get-ChildItem -Path $srcdir -Recurse -Filter "*.gdoc" -File
      # Download gdoc files and convert to docx
      # Explore ggl drive cmdlets https://www.go2share.net/article/google-drive-cmdlets
}

function processdata(){
  Param(
    [Parameter(Mandatory)][string]$datelastchecked
    # [string]$datelastchecked
  )
  Begin{
    # todo: Stop on invalid dateformat Error: "Cannot convert value "047/08/2026" to type "System.DateTime"
    "check GGL drive"
    "List files newer than specific date"
    $newfile = (Get-ChildItem -Path $srcdir -Recurse | Where-Object { $_.LastWriteTime -ge $datelastchecked } | select-object FullName, LastWriteTime, Name)
    $newfile.length
    if ($newfile.length -gt 0) { 
    $newfile.GetType().Name
    #$newfile -replace 'G:\Mijn Drive\Team-August', 'ggl' # contains only Fullname
    $newfile.LastWriteTime
    $newfile.FullName
    $newfile.Name
    } else {
      "No newer files found"
    }
    exit
  }
  Process{
    Try{
      "... backup"
      # $backupdir
      # $srcdir
      Copy-Item -Path $srcdir -Destination $backupdir -Recurse -Force -Exclude "*.gdoc", "*.ini" -errorAction stop
      
    }
    Catch{
      "Something went wrong"
      Write-Warning $Error[0]
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
#    .\$app -datelastchecked 'MM/dd/YYYY'
#
#OPTIONAL PARAMETERS
#       -h, help, -help, --help
#       -V, version, -version, --version
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
processgdoc;
      # Keep long names
#####################################################
writelog("--------------------------------------")	

