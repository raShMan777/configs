#.bashrc
#. /etc/profile

# append to history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# ignore commands preceded with a space
export HISTCONTROL=ignorespace

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Custom prompt
#PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Powerline
#if [ -f `which powerline-daemon` ]; then
#    if [ "$TERM" != "linux" ]; then
#       powerline-daemon -q
#       POWERLINE_BASH_CONTINUATION=1
#       POWERLINE_BASH_SELECT=1
##      POWERLINE_COMMAND=/usr/local/bin/powerline-hs
##      POWERLINE_CONFIG_COMMAND=/bin/true
##      . /usr/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh
#       . /usr/share/powerline/bindings/bash/powerline.sh
#    fi
#fi

if [ -f $(which powerline-go) ]; then
    function _update_ps1() {
        PS1="$(/usr/bin/powerline-go -modules "time,venv,user,ssh,cwd,perms,gitlite,jobs,exit,root,nix-shell,termtitle" -error $?)"
    }

    if [ "$TERM" != "linux" ]; then
        PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
    fi
fi

#export PATH=$PATH:/home/sra/bin

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    # alias dir='dir --color=auto'
    # alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

set -b						# causes output from background processes to be output right away, not on wait for next primary prompt
set -o notify					# notify when jobs running in background terminate

# User defined aliases
alias cls='clear'
alias clls='clear; ls'
alias exal='exa -bghHlS --group-directories-first'
alias grep='grep --color'
alias l='ls -laF --color'
alias la='ls -la --color'
alias ll='ls -l --color'
alias lsa='ls -A --color'
alias lsg='ls  --color| grep --color'
alias el='exa -la --group-directories-first'
alias ell='exa -l --group-directories-first'
alias mc='. /usr/lib/mc/mc-wrapper.sh'
alias na='nano'
alias web='links -download-dir ~/ www.google.com'
alias wget='wget --progress=bar'

export G_BROKEN_FILENAMES="1"
export EDITOR="mcedit"

. /etc/profile

function fplay {
    MUSICROOT=~/musik/
    if [ "$1" = '-v' ]; then
	shift 1
	unset -v filelist i
	while IFS= read -r file; do
	    echo `basename "$file"`
	    filelist[i++]=$file
	done < <(find $MUSICROOT -regextype posix-extended -type f -iname "*$**" -iregex '.*\.(3g[2|p]|a(ac|c3|dts|if[c|f]?|mr|nd|u)|caf|m4[a|r]|mp([1-4|a]|eg[0,9]?)|sd2|wav|ogg)' -print|sort)
	mpg123 -vC "${filelist[@]}"
    elif [ "$1" = '-g' ]; then
	shift 1
	unset -v filelist i
	while IFS= read -r file; do
	    filelist[i++]=$file
	done < <(find $MUSICROOT -regextype posix-extended -type f -iname "*$**" -iregex '.*\.(3g[2|p]|a(ac|c3|dts|if[c|f]?|mr|nd|u)|caf|m4[a|r]|mp([1-4|a]|eg[0,9]?)|sd2|wav|ogg)' -print|sort)
	    smplayer "${filelist[@]}"
    else
	unset -v filelist i
	while IFS= read -r file; do
	    filelist[i++]=$file
	done < <(find $MUSICROOT -regextype posix-extended -type f -iname "*$**" -iregex '.*\.(3g[2|p]|a(ac|c3|dts|if[c|f]?|mr|nd|u)|caf|m4[a|r]|mp([1-4|a]|eg[0,9]?)|sd2|wav|ogg)' -print|sort)
	mpg123 -vC "${filelist[@]}"
    fi
}

function mma() {
    mpv --no-video --ytdl-format=bestaudio ytdl://ytsearch10:"$@"
}
function mmv() {
    mpv ytdl://ytsearch10:"$@"
}

cd
