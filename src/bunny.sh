#
# bunny - https://gitlab.com/tim241/bunny
#
# Copyright (C) 2018 Tim Wanders <tim241@mailbox.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
NO_SUDO=0

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/bunny"
cache_file="$cache_dir/rabbithole"

pkg_backends="@@BACKEND_PATH@@"

help()
{
    pkg="$(basename "$0")"
    printf "%s\n%s\n%s\n%s\n" \
        "$pkg install [package]" \
        "$pkg remove  [package]" \
        "$pkg search  [package]" \
        "$pkg update"
}

get_backend()
{
    for file in "$pkg_backends"/*
    do
        file_name="$(basename "$file")"
        if command -v "$file_name" &> /dev/null
        then
            . "$file"
            echo "$file_name" > "$cache_file"
            backend_found=yes
        fi
    done
}

check_sudo()
{
    # Return when just searching for packages
    #
    if [ "$1" = "search" ]
    then
        return
    fi

    # Return when NO_SUDO equals 1
    if [ "$NO_SUDO" = "1" ]
    then
        return
    fi
    # Verify that current user isn't root
    #
    if [ "$UID" != "0" ]
    then
        if command -v doas &> /dev/null
        then
            doas "$0" "$@"
        else
            sudo "$0" "$@"
        fi
        exit $?
    fi
}

if [ ! -d "$cache_dir" ]
then
    mkdir -p "$cache_dir"
fi

backend_found=no

backend_file="$pkg_backends/$(cat "$cache_file" 2> /dev/null)"

if [ -f "$cache_file" ] && \
    [ -f "$backend_file" ]
then
    . "$backend_file"
    backend_found=yes
else
    get_backend
fi

if [ "$backend_found" = "no" ]
then
    printf "%s\n%s\n%s\n" \
        "There are no backends compatible with this machine" \
        "You can try to make one for your package manager" \
        "and submit a pr."
    exit 1
fi

case "$1" in
    search|install|\
    remove|update)
        check_sudo "$@"
        command="$1" 
        shift
        "$command" "$@";;
    # Alternatives :)
    dig) 
        check_sudo "$@";
        shift; search "$@";;
    hop) 
        check_sudo "$@";
        shift; update "$@";;
    help|*) help;;
esac

