$env:path += ";C:\tool\bin"
$env:path += ";C:\chocoportable\bin"

#
# zlocation
#
Import-Module ZLocation

#
# fzf
#
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -TabExpansion
Enable-PsFzfAliases

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs

function Invoke-FuzzyZLocation2() {
    $result = $null
    try {
        #(Get-ZLocation).GetEnumerator() | Sort-Object { $_.Value } -Descending | ForEach-Object{ $_.Key } | Invoke-Fzf -NoSort | ForEach-Object { $result = $_ }
        (Get-ZLocation).GetEnumerator() | Sort-Object { $_.Value } -Descending | ForEach-Object{ $_.Key } | fzf +s | ForEach-Object { $result = $_ }
    } catch {
        
    }
    if ($null -ne $result) {
        # use cd in case it's aliased to something else:
        cd $result
    }
}

function Invoke-FuzzyClip() {
    $result = $null
    try {
        fzf +s | ForEach-Object { $result = $_ }
    } catch {
        
    }
    if ($null -ne $result) {
        # use cd in case it's aliased to something else:
        #Get-Content $result | clip
        explorer.exe /select,$result
    }
}

function Invoke-FuzzyEdit2() {
    $result = $null
    try {
        Get-ChildItem * | Sort-Object { $_.Name } | Select-Object Name | fzf +s | ForEach-Object { $result = $_ }
    } catch {
        
    }
    if ($null -ne $result) {
        # use cd in case it's aliased to something else:
        #Get-Content $result | clip
        explorer.exe $result
    }
}

function Invoke-FuzzySelect() {
    $result = $null
    try {
        Get-ChildItem * | Sort-Object { $_.Name } | Select-Object Name | fzf +s | ForEach-Object { $result = $_ }
    } catch {
        
    }
    if ($null -ne $result) {
        # use cd in case it's aliased to something else:
        #Get-Content $result | clip
        explorer.exe /select,$result
    }
}

function OpenCurrentLoc() {
    $matched = (get-location | Select-Object -Property Path) -match "::(.+)}$"
    if ($matched) {
        explorer.exe $Matches[1]
    }
    else {
        explorer.exe .
    }
}

# alias
Set-Alias -name e -value explorer.exe
Set-Alias -name ec -value OpenCurrentLoc
Set-Alias -name fz -value Invoke-FuzzyZLocation2
#Set-Alias -name fcp -value Invoke-FuzzyClip
Set-Alias -name fes -value Invoke-FuzzySelect
Set-Alias -name fe -value Invoke-FuzzyEdit2
function alias-es($param) {
    explorer.exe /select,$param
}
Set-Alias -name es -value alias-es

function alias-l() {
    Get-ChildItem * | Sort-Object { $_.Name }
}
Set-Alias -name l -value alias-l

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
