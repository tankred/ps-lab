#----------------------------------------------------------------------------
# PowerShell 7.5 
# by Kurt Duyck (kurt.duyck@vives.be)
#
#NAME
#
#SYNOPSIS
# Name: backup-WSL.ps1 
# Purpose: backup WSL (F42)
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
# PARAM ( 
    # [string]$InitialDirectory = $(throw "-InitialDirectory is required."),
 #   [switch]$Add = $false
# )

#--------------------------------------------------------------------------------------------
#Ini
#--------------------------------------------------------------------------------------------
# START SET
$debug = 1
$version = "0.1.1"
$app = "backup-WSL.ps1"
$info = "backup WSL"
$ld = "o:\tmp\log\"
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

function processdata(){
  Param()
  Begin{
    Write-Host "Start example function..."
  }
  Process{
    Try{
      "Do Something here"
    }
    Catch{
      "Something went wrong."
      Break
    }
  }
  End{
    If($?){ # only execute if the function was successful.
      Write-Host "Completed example function."
    }
  }
}
#--------------------------------------------------------------------------------------------
## Main
#--------------------------------------------------------------------------------------------
clear
foreach ($arg in $args)
{
#  Write-Host "Arg: $arg";
  if ($arg -eq "-help" -OR $arg -eq "-h" -OR $arg -eq "--help" -OR $arg -eq "help" ) {
    write-host "CLI usage"
    $helpinfo = @"
#SYNTAX
#    .\$app -a <a> [-b <b>] 
#
#PARAMETERS
#    Required:
#    	-a a.b
#    Optional arguments are:
#    	-verbose  : [0|1] if 0 is specified no userinteraction is required to complete the process.
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
    write-host $helpinfo -fore white;
    exit;
  } 
  if ($arg -eq "-version" -OR $arg -eq "--version" -OR $arg -eq "version" -OR $arg -eq "-V") {
    write-host "$app"
    write-host "version $version"
    exit;
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
############################################################################	
processdata;
############################################################################	
writelog("--------------------------------------")	
"EOF"
