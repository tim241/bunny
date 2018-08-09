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

CACHE=$HOME/.cache/bunny
BACKENDS=/usr/share/bunny/backend

function help()
{
    pkg="$(basename "$0")"
    printf "%s\n%s\n%s\n%s\n%s\n" \
        "$pkg install [package]" \
        "$pkg remove  [package]" \
        "$pkg search  [package]" \
        "$pkg update" \
        "$pkg -C --cache"
}

# make sure we have somewhere to put our cache
if [[ ! -d $CACHE ]]; then
    mkdir -p $CACHE
fi

# attempt to find our backend
if [[ -f $CACHE/rabbithole.sh ]]; then
    source $CACHE/rabbithole 
else
    for F in $BACKENDS/*; do
        F_NAME=$(basename "$F")
        command -v $F_NAME &> /dev/null
        if [[ "$?" -eq "0" ]]; then
            if [[ -z $BACKEND ]]; then
                cp $F $CACHE/rabbithole
                source $F
            fi
        fi
    done
fi

case $1 in
    -C|--cache)
        rm $CACHE/rabbithole
        echo "cleared cached backend";;
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
