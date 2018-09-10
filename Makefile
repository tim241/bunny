destdir ?= 
prefix  ?= /usr/local
version ?= $(shell cat version)

bin/%:
	mkdir -p bin
	echo "#!/usr/bin/env bash" > "$@"
	cat src/license_header 	   >> "$@"
	cat src/bunny.sh \
		| grep -o '^[^#]*' \
		| sed "s|@@BACKEND_PATH@@|$(prefix)/share/bunny/backend|g" \
		| sed "s|@@BUNNY_VERSION@@|$(version)|g" \
		>> "$@"
	chmod +x "$@"

all: bin/bunny

install: bin/bunny
	install -D bin/bunny \
		"$(destdir)/$(prefix)/bin/bunny"
	mkdir -p "$(destdir)/$(prefix)/share/bunny"
	cp -r src/backend \
		"$(destdir)/$(prefix)/share/bunny/"

uninstall:
	rm -rf "$(destdir)/$(prefix)/bin/bunny" \
		"$(destdir)/$(prefix)/share/bunny"

clean:
	rm -rf bin
