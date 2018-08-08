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
function pacman()
{
    pacman="$(which pacman)"
    if [ "$UID" = "0" ]
    then
        "$pacman" $@
    else
        sudo "$pacman" $@
    fi
}

function search()
{
    pacman -Ss "$@"
}

function install()
{
    pacman -S "$@"
}

function remove()
{
    pacman -R "$@"
}

function update()
{
    pacman -Syu
}
