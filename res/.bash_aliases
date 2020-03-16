# MACHINE SPECIFIC ALIAS'S
# Search running processes
alias p="ps aux | grep "

# Search files in the current folder
alias f="find . | grep "

# Show current network connections to the server
# alias ipview="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'

# GENERAL ALIAS'S

# search in all files 
# ftext function
# create dir an go to
alias mkdirg="mkdirg"
# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -iv'
alias mkdir='mkdir -p'
alias vi='sudo vim'
alias tail='sudo tail'

alias apt-get='sudo apt-get'
alias apt='sudo apt'

# Change directory aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Alias's for multiple directory listing commands
alias la='ls -Alh' # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias ll='ls -Fls' # long listing format
alias lf="ls -l | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'" # directories only

# Search command line history
alias h="history | grep "

# END