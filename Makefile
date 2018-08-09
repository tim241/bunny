destdir ?= 
prefix  ?= /usr/local
configs ?= /usr/share

bin/%:
	mkdir -p bin
	echo "#!/bin/sh" > "$@"
	cat src/license_header 	   >> "$@"
	cat src/bunny.sh \
		| grep -o '^[^#]*' \
		>> "$@"
	chmod +x "$@"

all: bin/bunny

install: bin/bunny
	install -D bin/bunny -m=0755 \
		"$(destdir)/$(prefix)/bin/bunny"
	mkdir -p "$(configs)/bunny"
	cp -r src/backend \
		"$(configs)/bunny/"

clean:
	rm -rf bin
