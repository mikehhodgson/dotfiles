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

# TODO - fix writeroom dependency compilation
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

deep-thought-theme.el:
	wget https://raw.githubusercontent.com/emacsfodder/emacs-deep-thought-theme/master/deep-thought-theme.el

dos.el:
	wget http://www.emacswiki.org/emacs/download/dos.el

evenhold-theme.el:
	wget https://raw.githubusercontent.com/evenhold/evenhold-theme/master/evenhold-theme.el

graphviz-mode.el:
	wget http://graphviz.org/Misc/graphviz-dot-mode.el

markdown-mode.el:
	wget http://jblevins.org/git/markdown-mode.git/plain/markdown-mode.el?h=stable

minimal-theme.el:
	wget https://raw.githubusercontent.com/anler/minimal-theme/master/minimal-theme.el

puppet-mode.el:
	wget https://raw.githubusercontent.com/lunaryorn/puppet-mode/master/puppet-mode.el

draft-mode.el:
	wget https://raw.githubusercontent.com/gaudecker/draft-mode/master/draft-mode.el

visual-fill-column.el:
	wget https://raw.githubusercontent.com/joostkremers/visual-fill-column/master/visual-fill-column.el

writeroom-mode.el: visual-fill-column.el
	wget https://raw.githubusercontent.com/joostkremers/writeroom-mode/master/writeroom-mode.el

cyberpunk-theme.el:
	wget https://raw.githubusercontent.com/n3mo/cyberpunk-theme.el/master/cyberpunk-theme.el

web-mode.el:
	wget https://raw.githubusercontent.com/fxbois/web-mode/master/web-mode.el
