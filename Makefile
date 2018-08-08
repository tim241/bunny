destdir ?= 
prefix  ?= /usr/local
backend ?= pacman

bin/%:
	mkdir -p bin
	echo "#!/usr/bin/env bash" > "$@"
	cat src/license_header 	   >> "$@"
	echo "set -e" 	  >> "$@"
	cat src/backend/$(backend).sh \
		src/bunny.sh \
		| grep -o '^[^#]*' \
		>> "$@"
	chmod +x "$@"

all: bin/bunny

install: bin/bunny
	install -D bin/bunny -m=0755 \
		"$(destdir)/$(prefix)/bin/bunny"

clean:
	rm -rf bin
