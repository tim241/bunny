destdir ?= 
prefix  ?= /usr/local

bin/%:
	mkdir -p bin
	echo "#!/bin/sh" > "$@"
	cat src/license_header 	   >> "$@"
	cat src/bunny.sh \
		| grep -o '^[^#]*' \
		| sed "s|@@BACKEND_PATH@@|$(prefix)/share/bunny/backend|g" \
		>> "$@"
	chmod +x "$@"

all: bin/bunny

install: bin/bunny
	install -D bin/bunny -m=0755 \
		"$(destdir)/$(prefix)/bin/bunny"
	mkdir -p "$(destdir)/$(prefix)/share/bunny"
	cp -r src/backend \
		"$(destdir)/$(prefix)/share/bunny/"

clean:
	rm -rf bin
