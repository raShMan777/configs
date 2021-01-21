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

export NNN_BMS='D:~/docs;d:~/downloads/;k:/home/sra/bilder/kamera;n:/home/sra/Nextcloud;v:/home/sra/downloads/video;f:/home/sra/filme'
export NNN_SSHFS="sshfs -o follow_symlinks"        # make sshfs follow symlinks on the remote
export NNN_COLORS="2136"                           # use a different color for each context
#export NNN_OPENER=/home/sra/.config/nnn/plugins/nuke
export NNN_PLUG='d:dups;c:chksum;D:diffs;r:dragdrop;f:fzcd;h:fzhist;o:fzopen;p:getplugs;i:imgview;m:mediainf;M:mocplay;3:mp3conv;P:pskill;s:suedit;q:_|geeqie $nnn;S:_|sublime_text $nnn;l:-_less -iR $nnn*;v:vidthumb'
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"
export VISUAL='subl'
export LC_COLLATE="C"

if [ -f $(which powerline-go) ]; then
    function _update_ps1() {
        PS1="$(/usr/bin/powerline-go -modules "time,venv,user,ssh,cwd,perms,gitlite,jobs,exit,root,nix-shell,termtitle" -error $?)"
    }

    if [ "$TERM" != "linux" ]; then
        PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
    fi
fi

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
alias yayfzf="yay -Slq | fzf -m --preview 'yay -Si {1}'| xargs -ro yay -S"

export G_BROKEN_FILENAMES="1"
export EDITOR="mcedit"
export EDITOR="less"

. /etc/profile

export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
# Use fd (https://github.com/sharkdp/fd) instead of the default find command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

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

source /home/sra/.config/broot/launcher/bash/br

cd
