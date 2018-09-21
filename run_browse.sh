#!/bin/bash
#set -x

find / -name *.nmap 2>/dev/null > tmp_file
recent_date=0
recent_file=''
for i in $(<tmp_file); do
        get_date=`date -r $i +%s`
        if [ $((get_date)) -gt $((recent_date)) ]; then
        recent_file=`ls $i`
        recent_date=$get_date
fi
done
rm tmp_file

echo "Run script on this nmap scan file? $recent_file (y|yes):"
read selection
if [ $selection = "n" ] || [ $selection = "no" ]; then
	echo "Enter specify the name and absolute path to the nmap file:"
	read other_file
	grep -e com -e open $other_file |cut -f1 -d / |sed 's/^|.*$//g' |sed 's/Nmap scan report for //g' |cut -f1 -d ' ' |sed '/^\s*$/d' > /opt/port_browser/nmap_ports.txt
else
	grep -e com -e open $recent_file |cut -f1 -d / |sed 's/^|.*$//g' |sed 's/Nmap scan report for //g' |cut -f1 -d ' ' |sed '/^\s*$/d' > /opt/port_browser/nmap_ports.txt
fi 
sleep 3
tabs=`grep -v com /opt/port_browser/nmap_ports.txt |wc -l`
echo "Are you sure you want to open " $tabs " tabs in your browser(y|yes)?"
echo "    If no, break up your nmap scan file to make it smaller."
read proceed
if [ $proceed = "n" ] || [ $proceed = "no" ]; then
	echo "Exiting script..."
	exit
else
	python3 /opt/port_browser/port_browser.py
fi
