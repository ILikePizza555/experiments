enum GitFileStatus {
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

function Convert-StringToGitFileStatus ($c){
    <#
    .SYNOPSIS
        Converts a string to a GitFileStatus
    #>
    switch ($c) {
        ' ' {[GitFileStatus]::unmodified}
        'M' {[GitFileStatus]::modified}
        'A' {[GitFileStatus]::added}
        'D' {[GitFileStatus]::deleted}
        'R' {[GitFileStatus]::renamed}
        'C' {[GitFileStatus]::copied}
        'U' {[GitFileStatus]::updated}
        '?' {[GitFileStatus]::untracked}
        '!' {[GitFileStatus]::ignored}
    }
}

class GitRepo {
    [ValidateNotNullOrEmpty()][string]$Path

    [string] CurrentBranch() {return git symbolic-ref HEAD}
    [string] ToString() {return "Git:" + $this.Path + ":" + $this.CurrentBranch()}

    [string[]] Branches() {return git rev-parse --symbolic-full-name --branches}
    [string[]] Remotes() {return git rev-parse --symbolic-full-name --remotes}
    [string[]] Tags() {return git rev-parse --symbolic-full-name --tags}
}

function New-GitBranch {
    Param(
        
    )
}