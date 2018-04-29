#!/bin/sh
#    Copyright (C) 2018  Zaoqi

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.

#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
cd /
f=$(mktemp)
cat > $f <<'EOF'
#!/bin/sh

cd $(mktemp -d)
cp -r /mnt/us/extensions/MRInstaller ./
cp -r /mnt/us/extensions/kterm ./
cp -r /mnt/us/extensions/leafpad ./

mntroot rw
cp /etc/fstab /etc/fstab.bak
sed -i 's/^\(\/dev\/loop\/0.*base-us.*\)vfat\( *\)[^ ]* /\1ext3\2defaults /' /etc/fstab
mntroot ro
if [ "$(cat /etc/fstab)" = "$(cat /etc/fstab.bak)" ] ; then
	echo "don't support"
	exit
fi
umount /mnt/base-us
mkfs.ext3 /dev/loop/0
mount /mnt/base-us

mkdir /mnt/base-us/update.bin.tmp.partial
mkdir /mnt/base-us/documents
touch /mnt/base-us/documents/KUAL.kual
mkdir /mnt/base-us/extensions
cp -r ./* /mnt/base-us/extensions

EOF
exec sh $f
