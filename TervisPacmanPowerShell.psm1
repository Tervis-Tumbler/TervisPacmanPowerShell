$TervisPackageGroups = [PSCustomObject][Ordered] @{
    Name = "ArchRouter"
    PackageName = @"
bmon
fish
nftables
openssh
pacman
parted
sudo
tmux
"@ -split "`r`n"
}

function Get-TervisPacmanPackageGroup {
    param (
        $Name
    )
    $TervisPackageGroups | where Name -EQ $Name
}


function New-PacmanPackageInstallCommand {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]$PackageName
    )
    begin { $PackageNames = @() }
    process {
        $PackageNames += $PackageName
    }
    end {
        $Arguements = $PackageNames -join " "
        "pacman -Syu $Arguements"
    }
}

function Install-PacmanTervisPackageGroup {
    param (
        [Parameter(Mandatory)]$TervisPackageGroupName,
        [Parameter(Mandatory,ParameterSetName="SSHSession")]$SSHSession
    )
    process {
        $TervisPackageGroup = Get-TervisPacmanPackageGroup -Name $TervisPackageGroupName
        $Command = $TervisPackageGroup.PackageName | New-PacmanPackageInstallCommand
        Invoke-SSHCommand -Command $Command -SSHSession $SSHSession
    }
}