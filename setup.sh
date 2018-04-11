#!/bin/bash
#
# setup.sh
# Copyright (C) 2018 Peter Jones <pjones@redhat.com>
#
# Distributed under terms of the GPLv3 license.
#

set -eu

cd /root

git clone --depth 1 https://github.com/rhboot/efivar
cd efivar
make clean all
make clean
cd ..

git clone --depth 1 https://github.com/rhboot/dbxtool
cd dbxtool
git config --local --add dbxtool.efidir test
make clean
cd ..

git clone --depth 1 https://github.com/rhboot/efibootmgr
cd efibootmgr
git config --local --add efibootmgr.efidir test
make clean
cd ..

git clone --depth 1 https://github.com/rhboot/fwupdate
cd fwupdate
git config --local --add fwupdate.efidir test
make clean
cd ..

git clone --depth 1 https://github.com/vathpela/gnu-efi
cd gnu-efi
git config --local --add gnu-efi.efidir test
make clean
cd ..

git clone --depth 1 https://github.com/rhboot/pesign
cd pesign
make clean
cd ..

git clone --depth 1 https://github.com/rhboot/shim
cd shim
git config --local --add shim.efidir test
make clean
cd ..


