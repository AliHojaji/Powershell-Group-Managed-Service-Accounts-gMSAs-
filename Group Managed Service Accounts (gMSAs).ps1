#--- Author : Ali Hojaji ---#

#--*---------------------------------*--#
#---> Group Managed Service Account <---#
#--*---------------------------------*--#

#--> Create a managed service account
New-ADServiceAccount -Name MSA-testsrv -RestrictToSingleComputer
Add-ADComputerServiceAccount -Identity DC-Test -ServiceAccount MSA-test
Test-ADServiceAccount -Identity MSA-test



#--> Install MSA on local DC-TEST1
Install-ADServiceAccount MSA-test
Test-ADServiceAccount -Identity MSA-test


#--> Create a dummy service
New-Service -Name TESTSRV -BinaryPathName C:\Windows\System32\notepad.exe


#--> Group Managed Service Accounts (GMSA) <--#

#--> create key distribution center root key
Add-KdSRootKey -EffectiveTime (Get-Data).AddHours((-10))

#--> Create a group managed service account
New-ADServiceAccount -Name GMSA-testsrv -DNSHostName GMSA-testsrv.test.local -PrincipalsAllowedToRetrieveManagedPassword "Domain Computers"
Invoke-Command -ComputerName APP-test -ScriptBlock { Install-WindowsFeature RSAT-AD-PowerShell }

#--> Install the gMSA
Install-ADServiceAccount GMSA-testsrv
Test-ADServiceAccount -Identity GMSA-testsrv

#--> Create a dummy service
New-Service -Name testSRV -BinaryPathName C:\Windows\System32\notepad.exe