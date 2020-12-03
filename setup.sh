#!/bin/bash
#
# setup.sh
# Copyright (C) 2018 Peter Jones <pjones@redhat.com>
#
# Distributed under terms of the GPLv3 license.
#

set -eu

cd /root

git clone https://github.com/rhboot/efivar
cd efivar
make clean all
make clean
cd ..

git clone https://github.com/rhboot/efibootmgr
cd efibootmgr
git config --local --add efibootmgr.efidir test
make clean
cd ..

git clone https://github.com/vathpela/gnu-efi
cd gnu-efi
git config --local --add gnu-efi.efidir test
make clean
cd ..

git clone https://github.com/rhboot/pesign
cd pesign
make clean
cd ..

git clone https://github.com/rhboot/shim
cd shim
git config --local --add shim.efidir test
mkdir build-aa64 build-arm build-ia32 build-x64 
make clean
cd ..


