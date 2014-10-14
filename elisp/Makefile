# GNU Make rules for fetching and byte-compiling various elisp files.
# http://edward.oconnor.cx/2005/09/installing-elisp-files
# http://edward.oconnor.cx/config/elisp/Makefile

#ELS = $(shell ls -1 *.el) # run ls command, list .el files
#ELCS = $(ELS:.el=.elc)    # make variable substiution, list .elc files
#ELFILES = $(shell egrep -o ^[a-zA-Z-]+.el Makefile)

usage:
	@echo "USAGE: make [ foo.el | foo.elc | download | compile | all ]"
	@echo
	@echo "       files available:"
	@egrep -o ^[a-zA-Z-]+.el Makefile | sed 's/^/           /'

%.elc: %.el
	emacs -batch -f batch-byte-compile $^

# https://www.gnu.org/software/emacs/manual/html_node/elisp/Compilation-Functions.html
compile:
	emacs -batch -f batch-byte-compile *.el

all: download compile

lua-mode.el:
	wget http://lua-users.org/files/wiki_insecure/editors/lua-mode.el

php-mode.el:
	wget https://raw.githubusercontent.com/ejmr/php-mode/master/php-mode.el

powershell-mode.el:
	wget http://www.emacswiki.org/emacs/download/PowerShell-Mode.el

visual-basic-mode.el:
	wget http://www.emacswiki.org/emacs/download/visual-basic-mode.el

dos.el:
	wget http://www.emacswiki.org/emacs/download/dos.el
