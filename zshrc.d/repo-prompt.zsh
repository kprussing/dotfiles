# Provide a bit more granularity on what makes a repository “dirty.”
# Specifically, I want to distinguish between untracked, changed, and
# staged files.

function _repo_prompt() {
    # Try all of the prompts in order.  At the current time, this will
    # only track one type of repository at a time.  The alternative is
    # to have each on in order on the command line so I could mix git,
    # hg, and svn; however, it's not working.  If I use
    # `$(_git_prompt)$(_hg_prompt)`, I get extra "'?'=0" characters when
    # I mix git and hg.  It doesn't occur when I use them separately.
    #
    # FIXME: Figure out how to mix repositories and get a longer prompt.
    _git_prompt && return
    _hg_prompt && return
    #svn_status_info && return
}

