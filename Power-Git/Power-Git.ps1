enum GitFileStatusAttribute {
    unmodified
    modified
    added
    deleted
    renamed
    copied
    updated
    untracked
    ignored
}

function Convert-StringToGitFileStatusAttribute ($c){
    <#
    .SYNOPSIS
        Converts a string to a GitFileStatusAttribute
    #>
    switch ($c) {
        ' ' {[GitFileStatusAttribute]::unmodified}
        'M' {[GitFileStatusAttribute]::modified}
        'A' {[GitFileStatusAttribute]::added}
        'D' {[GitFileStatusAttribute]::deleted}
        'R' {[GitFileStatusAttribute]::renamed}
        'C' {[GitFileStatusAttribute]::copied}
        'U' {[GitFileStatusAttribute]::updated}
        '?' {[GitFileStatusAttribute]::untracked}
        '!' {[GitFileStatusAttribute]::ignored}
    }
}

class GitRepo {
    [ValidateNotNullOrEmpty()][string]$Path

    GitRepo([string]$Path) {$this.Path = $Path}

    [string] CurrentBranch() {return git symbolic-ref HEAD}
    [string] ToString() {return "Git:" + $this.Path + ":" + $this.CurrentBranch()}

    [string[]] Branches() {return git rev-parse --symbolic-full-name --branches}
    [string[]] Remotes() {return git rev-parse --symbolic-full-name --remotes}
    [string[]] Tags() {return git rev-parse --symbolic-full-name --tags}
}

class GitFileStatus {
    [ValidateNotNullOrEmpty()][GitRepo]$Repo
    [ValidateNotNullOrEmpty()][string]$FileName
    [ValidateNotNullOrEmpty()][GitFileStatusAttribute]$IndexStatus
    [ValidateNotNullOrEmpty()][GitFileStatusAttribute]$WorkTreeStatus

    GitFileStatus([GitRepo]$Repo, [string]$FileName, [GitFileStatusAttribute]$IndexStatus, [GitFileStatusAttribute]$WorkTreeStatus) {
        $this.Repo = $Repo
        $this.FileName = $FileName
        $this.IndexStatus = $IndexStatus
        $this.WorkTreeStatus = $WorkTreeStatus
    }
}

function New-GitBranch {
    <#
    .SYNOPSIS
        Creates a new branch with the name $BranchName in the Git repository specified by $Repo
    #>
    Param(
        # The git repository to operate on
        [GitRepo]
        $Repo = [GitRepo]::new("."),

        # The name of the new branch
        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $BranchName,

        # If enabled, make the new branch the current one
        [Switch]
        $MakeCurrent
    )

    Push-Location $Repo.Path

    if ($MakeCurrent) {
        git checkout -b $BranchName
    } else {
        git branch $BranchName
    }

    Pop-Location
    return $Repo
}

function Set-GitBranch {
    <#
    .SYNOPSIS
        Checkout a branch in the git repository
    #>
    Param(
        # The git repository to operate on
        [GitRepo]
        $Repo = [GitRepo]::new("."),

        # The name of the new branch
        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $BranchName
    )

    Push-Location $Repo.Path
    git checkout $BranchName
    Pop-Location
    return $Repo
}

function Get-GitFileStatus {
    Param(
        [GitRepo]
        $Repo = [GitRepo]::new(".")
    )

    Push-Location $Repo.Path
    $status_output = git status --porcelain
    Pop-Location

    ForEach-Object -InputObject $status_output {
        $is = Convert-StringToGitFileStatusAttribute($_.Chars(0))
        $ts = Convert-StringToGitFileStatusAttribute($_.Chars(1))
        [GitFileStatus]::new($Repo, $_.Substring(3), $is, $ts)
    }
}