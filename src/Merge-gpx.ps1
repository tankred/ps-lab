$pwd = 'O:\workspace\lab\backend\ps-LAB\data'
[xml]$XmlDocument01 = Get-Content -Path ..\data\route-stadshal.gpx
[xml]$XmlDocument02 = Get-Content -Path ..\data\route-STAM.gpx

$XmlDocument01.gpx.metadata | Format-table -AutoSize
$XmlDocument02.gpx.metadata | Format-table -AutoSize


# Foreach ($Node in $XmlDocument02.gpx) {
#     $Node
# }
# 
# 
# Foreach ($Node in $XmlDocument02.gpx) {
#     $XmlDocument02.gpx.AppendChild($XmlDocument01.ImportNode($Node, $true))
# }
# 
# 
# $XmlDocument02 > ..\data\out.gpx
# 

$finalXml = "<root>"
# foreach ($file in $files) {
#     [xml]$xml = Get-Content $file    
#     $finalXml += $xml.InnerXml
# }

# $finalXml += $XmlDocument01.InnerXml
# $finalXml += $XmlDocument02.InnerXml
$finalXml += "</root>"
$finalXml
([xml]$finalXml).Save("$pwd\out.gpx")


or using xslt??

https://mwallner.net/2017/03/31/merging-xml-with-xslt-and-powershell-ok/
