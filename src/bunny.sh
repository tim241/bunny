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


cache_dir="${XDG_CACHE_HOME:-$HOME/.cache/bunny}"
pkg_backends="@@BACKEND_PATH@@"

help()
{
    pkg="$(basename "$0")"
    printf "%s\n%s\n%s\n%s\n%s\n" \
        "$pkg install [package]" \
        "$pkg remove  [package]" \
        "$pkg search  [package]" \
        "$pkg update" \
        "$pkg clean"
}

if [ ! -d "$cache_dir" ]; then
    mkdir -p "$cache_dir"
fi

if [ -f "$cache_dir/rabbithole" ]; then
    . "$cache_dir/rabbithole" 
else
    for file in "$pkg_backends"/*; do
        file_name=$(basename "$file")
        if $(command -v "$file_name" &> /dev/null) && \
            [ -z "$BACKEND" ]; then
                cp "${file}" "$cache_dir/rabbithole"
                . "$file"
        fi
    done
fi

if [ -z "$BACKEND" ]; then
    printf "%s\n\t%s\n\t%s\n" \
        "There are no backends compatible with this machine" \
        "You can try to make one for your package manager" \
        "and submit a pr."
    exit 1
fi

case "$1" in
    clean)
        if [ -f "$cache_dir/rabbithole" ]; then
            rm "$cache_dir/rabbithole"
            echo "Shoo rabbits, don't make me get a broom!"
        fi;;
    search|install|\
    remove|update) 
        command="$1" 
        shift
        "$command" "$@";;
    # Alternatives :)
    dig) shift; search "$@";;
    hop) shift; update "$@";;
    help|*) help;;
esac