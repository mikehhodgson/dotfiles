# GNU Make rules for fetching and byte-compiling various elisp files.
# http://edward.oconnor.cx/2005/09/installing-elisp-files
# http://edward.oconnor.cx/config/elisp/Makefile

ELFILES = $(shell egrep -o ^[a-zA-Z-]+.el Makefile)
ELCFILES = $(ELFILES:.el=.elc)    # make variable substiution, list .elc files

usage:
	@echo "USAGE: make [ foo.el | foo.elc | download | compile | all ]"
	@echo
	@echo "       make foo.el   - wget foo.el"
	@echo "       make foo.elc  - byte compile foo.el"
	@echo "       make download - wget any missing *.el"
	@echo "       make compile  - compile all present *.el"
	@echo "       make all      - re-download and compile all"
	@echo
	@echo "       files available:"
	@egrep -o ^[a-zA-Z-]+.el Makefile | sort | sed 's/^/            /'

%.elc: %.el
	emacs -batch -f batch-byte-compile $^

clean:
	rm -f *.elc

# https://www.gnu.org/software/emacs/manual/html_node/elisp/Compilation-Functions.html
compile:
	emacs -batch -f batch-byte-compile *.el

download: $(ELFILES)

all: delete download compile

delete: clean
	rm -f *.el

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

evenhold-theme.el:
	wget https://raw.githubusercontent.com/evenhold/evenhold-theme/master/evenhold-theme.el
