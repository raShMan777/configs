# .bash_profile

# Source .bashrc
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# OPAM configuration
. /home/sra/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
