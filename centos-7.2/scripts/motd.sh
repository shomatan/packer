#!/bin/bash

BUILDDATE=`date +%Y%m%d`
NAME="CentOS-7.2.1511"
DOCS="Vagrant Box"

# Create MOTD
echo "Creating /etc/motd"
cat << MOTD > /etc/motd
  __      __     _____ _____            _   _ _______
  \ \    / /\   / ____|  __ \     /\   | \ | |__   __|
   \ \  / /  \ | |  __| |__) |   /  \  |  \| |  | |
    \ \/ / /\ \| | |_ |  _  /   / /\ \ | .   |  | |
     \  / ____ \ |__| | | \ \  / ____ \| |\  |  | |
      \/_/    \_\_____|_|  \_\/_/    \_\_| \_|  |_|
  $NAME ($BUILDDATE)
  $DOCS

MOTD
