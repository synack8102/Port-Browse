#!/bin/bash

mkdir /opt/port_browser
mv run_browse.sh /opt/port_browser
ln -s /opt/port_browser/run_browse.sh /usr/bin/run_browse
#current_user=`whoami`
#chown -R $current_user /opt/port_browser/
chmod +x /opt/port_browser/run_browse.sh
echo "Installing dependencies..."
git clone https://github.com/FortyNorthSecurity/EyeWitness
./EyeWitness/setup/setup.sh
mv EyeWitness /opt/port_browser
echo "Installation complete in the /opt/port_browser directory. To run the script type 'run_browse'."
