# Shell configuration


### Prompt

PS1="\n\w › "

__configure_git_prompt() {
  if [[ $(type -t __git_ps1) == "function" ]]; then
    export GIT_PS1_DESCRIBE_STYLE=branch
    export GIT_PS1_SHOWCOLORHINTS=1
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    PROMPT_COMMAND='__git_ps1 "\n\w" " › "'
  else
    PS1="\n\w › "
  fi
}


### History

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=10000
HISTFILESIZE=$HISTSIZE


### Miscellany

# Don't clear screen after quitting `man'
export MANPAGER="less -X"

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


### Private/local settings

if [[ -r ~/.profile ]]; then
  source ~/.profile
fi


### Aliases


alias e=$EDITOR
alias e.="$EDITOR ."
alias g=git


### Deferred/slow things

# Loading bash completion on OSX is quite slow (~200ms), so defer it until
# after the prompt is shown.
__deferred_configuration() {
  if [[ -f /usr/local/etc/bash_completion ]]; then
    # if the output of `set` contains non-ASCII chars we get a `sed` error from
    # git-completion.bash. Therefore we temporarily remove any fancy prompt
    # characters while that file is sourced.
    PS1=
    source /usr/local/etc/bash_completion
    # Can't set git prompt until bash completion is loaded.
    __configure_git_prompt
  fi
}

trap '__deferred_configuration; trap USR1' USR1
{ sleep 0.1; builtin kill -USR1 $$; } & disown
