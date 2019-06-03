 Param(

   [Parameter(Mandatory=$true)]
   $Name,
   [Parameter(Mandatory=$true)]
   $FullPathToExe,
   [Parameter(Mandatory=$false)]
   $Arguments='$null'

)


$ScriptDir=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)

#$FolderWithScriptAndExe="C:\_SMSTSBlabla\Packages\CM10033"
$xmlString=Get-Content ($ScriptDir+"\Start-Interactive.xml") | out-string
$xmlString=$xmlString.Replace("xxDummyxx",$env:windir)
$xmlString=$xmlString.Replace("start-dummy.ps1","start-"+$Name+".ps1")

#write-host $xmlString
$PS1=Get-Content ($ScriptDir+"\Start-Dummy.ps1") -Raw
#$PS1=$PS1.Replace("xxDummyxx",$ScriptDir)
$PS1=$PS1.Replace("xxExexx",$FullPathToExe)
$PS1=$PS1.Replace("xxLogNamexx",$Name)
$PS1=$PS1.Replace("xxArgumentsxx",$Arguments.ToString())
if ($Arguments)
{
write-host ($Arguments.ToString())
}

$PS1 | Set-Content ($env:windir+"\start-"+$Name+".ps1")
#write-host $PS1

Register-ScheduledTask -TaskName $Name -Xml ($xmlString)