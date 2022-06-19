####################################################################################################
#
# PowerShell Script of
#
# Create Hyper-V VM on Hyper-V environment
#
# Created on 2022.5.17
# Updated on 2022.6.19
#
# Note :
#   Need to replace the value of $NetworkSwitch with the appropriate value
#   Need to put the Windows Server installation image, named "WinSERVER_x64.iso", in the $ISO path
#
# Reference : -
#
####################################################################################################

#### Variables

## Input name from host
$VMName = Read-Host "Input VMName"
## $VMName = "TESTVM01" ## Name of VM

## Start up RAM
$VMRAM = 32768MB

## Generation of VM
$VMGEN = 2

## Directory of VM
$VMLOC = "F:\Hyper-V_" + $VMName

## Directory of VM hard disk
New-Item "$VMLOC\$VMName\Virtual Hard Disks" -type directory -Force
$VHDPATH = "$VMLOC\$VMName\Virtual Hard Disks\$VMName.vhdx"

## Size of hard disk
$VHD = 200GB

## Virtual switch
$NetworkSwitch = "IntNAT01"

## Install media
$ISO = "F:\ISO\WinSERVER_x64.iso"

##################################################
"`n"
"##### Check Variables #####"
'$VMName= ' + $VMName
'$VMRAM= ' + $VMRAM
'$VMGEN= ' + $VMGEN
'$VMLOC= ' + $VMLOC
'$VHDPATH= ' + $VHDPATH
'$VHD= ' + $VHD
'$NetworkSwitch= ' + $NetworkSwitch
'$ISO= ' + $ISO
##################################################
# pause

## Create Virtual Machines
New-VM -Name $VMName `
 -Path $VMLOC `
 -MemoryStartupBytes $VMRAM `
 -Generation $VMGEN `
 -NewVHDPath "$VHDPATH" `
 -NewVHDSizeBytes $VHD `
 -SwitchName $NetworkSwitch
# pause

## Set Virtual Memory
Set-VMMemory -VMName $VMName `
 -DynamicMemoryEnabled $True `
 -MinimumBytes 512MB -MaximumBytes 32768MB -Buffer 20

## Set Processor
Set-VMProcessor -VMName $VMName -Count 8

## Configure Virtual Machines in case of 2nd generation
Add-VMDvdDrive -VMName $VMName -Path $ISO

## Configure Virtual Machines in case of 1st generation
# Set-VMDVDDrive -VMName $VMName -Path $ISO

## Make DVD drive the highest priority boot device
Set-VMFirmware -VMName $VMName `
 -FirstBootDevice (Get-VMDvdDrive -VMName $VMName)
pause

## Check point setting
Set-VM -Name $VMName -CheckpointType Production
# Set-VM -Name $VMName -CheckpointType ProductionOnly
# Set-VM -Name $VMName -CheckpointType Standard

##################################################
# Creation of VM is completed
##################################################

$startvm = Read-Host "Start VM ? Y/N"

if( $startvm -eq "N"){
    Write-Host "Creation of VM is completed. Not start VM."
    exit
}else{

##################################################
# Start VM if needed
##################################################

    Write-Host "Start VM"
    Start-VM $VMName
}
# pause
