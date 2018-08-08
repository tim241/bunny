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
function help()
{
    pkg="$(basename "$0")"
    printf "%s\n%s\n%s\n%s\n" \
        "$pkg install [package]" \
        "$pkg remove  [package]" \
        "$pkg search  [package]" \
        "$pkg update"
}

case $1 in
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
