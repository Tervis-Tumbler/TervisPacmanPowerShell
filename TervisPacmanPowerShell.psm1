$TervisPackageGroups = [PSCustomObject][Ordered] @{
    Name = "ArchRouter"
    PackageName = @"
bmon
fish
nftables
parted
sudo
tmux
"@ -split "`r`n"
},
[PSCustomObject][Ordered] @{
    Name = "Kubernetes"
    PackageName = @"
base-devel
bmon
fish
nftables
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
        "pacman --noconfirm -Syu $Arguements"
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