ZSH=$HOME/.oh-my-zsh
# Path to your oh-my-zsh configuration.

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="shark"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="false"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# How often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=31

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(command-not-found web-search)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/sbin/:/home/shark/.cabal/bin"

export EDITOR='vim'

source ~/.alias

eval `dircolors -b ~/.dir_colors`

#  bindkey -v

# Keep jobs running in the background
setopt NO_HUP
setopt NO_CHECK_JOBS

rehash() {
    . ~/.zshrc
}

nwlook() {
    avahi-browse -t -a | grep --color=never IPv4
}

remotenwlook() {
    ssh peter@sultan.theo3.physik.uni-stuttgart.de 'avahi-browse -t -a | grep --color=never IPv4 | grep -v mvagusta;avahi-browse -t -a  | grep --color=never IPv4'
}

pdfFontToOutlines() {
    gs -sDEVICE=pswrite -dNOCACHE -sOutputFile=- -q -dbatch -dNOPAUSE -dQUIET "$1" -c quit | ps2pdf - "$2"
}

notify() {
    /home/shark/.nwlook/notify.sh &
}

# removes all those anoying files from LaTeX working directories
cleanLatexFolder() {
    setopt null_glob
    for file in *.aux *.toc *.blg *.bbl *.synctex.gz *.dvi *.fdb_latexmk *.out *.ps *Notes.bib *.log *._aux *._log *.fls; do
       if [[ -e "$file" ]]; then
            echo -n "Delete '$file' [y]: "
            read answ
            if [[ x"$answ" == x"y" ]] || [[ x"$answ" == x"" ]]; then
                rm "$file"
            fi
        fi
    done
}

# prevent Ctrl-S from freezing the terminal to use the shortcut in vim
# bind -r '\C-s'
stty start '^-' stop '^-'

# the only real way to use gnuplot is via killall
gp() {
    killall gnuplot 2> /dev/null
    gnuplot -persist < "$1"
}

# call with 'trigger <cmd> <file1> <file2>'
#
# This will run the command 'cmd' every time one
# of the files is changed
#
# In the command string, #1, #2, can be used as a
# synonym for file1, file2, ..
#
# Example: trigger 'python #1' run.py config.py
#
trigger() {
    cmd="$1"
    shift
    cmd="${cmd//\#1/$1}"
    cmd="${cmd//\#2/$2}"
    cmd="${cmd//\#3/$3}"
    cmd="${cmd//\#4/$4}"
    cmd="${cmd//\#5/$5}"

    echo -e "$red>>>$reset Initial run of '$cmd'"
    eval "$cmd"
    echo

    while cfile="`inotifywait -q --format '%w' -e close_write \"$@\"`"; do
        echo -e "$red>>>$reset File '$cfile' has been changed"
        eval "$cmd"
        echo
    done
}

# Run program silently in the background
background() {
    silent "$*" &!
}

# Start tex environment
texenv() {
    i3-msg "split v"
    sleep .1
    terminator -e "source ~/.zshrc && _client_texenv '$1'" &!
    svim "$1"
}

_client_texenv() {
    silent i3-msg "resize shrink up"
    silent i3-msg "resize shrink up"
    silent i3-msg "resize shrink up"
    sleep .1
    silent i3-msg 'focus parent'
    sleep .1
    silent i3-msg 'split h'
    sleep .1
    clatexmk "$1"
}

# Alt-S inserts "sudo " at the start of line:
insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

