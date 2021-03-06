#----------------------------------------------------------------------------
# PowerShell 5.1 
# by Kurt Duyck (kurt.duyck@vives.be)
# lastmod date: 
# Current Script $version
#
#NAME
#
#SYNOPSIS
# Name: 
# Purpose: 
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
$version = "0.1.0"
$app = "engine_"
$info = "info"
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
      $Password = ([char[]]([char]33..[char]95) + ([char[]]([char]97..[char]126)) + 0..9 | sort {Get-Random})[0..8] -join ''
      $Password
# Example: Fj-Rs!4p2z

# PS> dir C:\Windows\*.* | Get-Random | Get-FileHash -Algorithm SHA1
# Example: 819AABA1653415766D4A6B0F5F89833F4E40AA27

# https://www.netmux.com/blog/random-password-cheat-sheet
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
#    ./engine.ps1 -a <a> [-b <b>] 
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
#PS > .\engine.ps1 -h
#PS > .\engine.ps1 -V
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
## HISTORY history
#"[x] boilerplate 0.1.0"
#
## END HISTORY
"EOF"
