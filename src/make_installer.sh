#!/bin/bash

# Author Daniel Bichof (nov 27, 2023)

zip tmp.zip init.vim
cat base.sh tmp.zip > ../install.sh
