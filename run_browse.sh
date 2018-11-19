#!/bin/bash
#set -x

function createFile() {
	grep -e com -e open $select_file |cut -f1 -d / |sed 's/^|.*$//g' |sed 's/Nmap scan report for //g' |cut -f1 -d ' ' |grep -iv sf: |sed '/^\s*$/d' > /opt/port_browser/nmap_ports.txt
}

function callEyeWitness() {
	for i in $(<nmap_ports.txt); do
	        if [[ $i == *.com ]]; then
                	hostname=$i
        	else
                	URL=$protocol://$hostname':'$i
                	echo $URL >> ports.txt
        	fi
	done
}

# Find the most recently updated nmap file
find / -name *.nmap 2>/dev/null > tmp_file
recent_date=0
select_file=''
for i in $(<tmp_file); do
        get_date=`date -r $i +%s`
        if [ $((get_date)) -gt $((recent_date)) ]; then
        select_file=`ls $i`
        recent_date=$get_date
	fi
done
rm tmp_file

# Default to most recent. If not, allow user to manually set it
# Then create a list file of URLs from the nmap file
echo "Run script on this nmap scan file? $select_file [Y|n]:"
read selection
if [ $selection = "n" ] || [ $selection = "no" ]; then
	echo "Enter specify the name and absolute path to the nmap file:"
	read select_file
	createFile $select_file
else
	createFile $select_file
fi

echo 'http or https? [HTTP|https]:'
read protocol
callEyeWitness $protocol
echo "Name your ouput directory"
read output
python /opt/port_browser/EyeWitness/EyeWitness.py -f /opt/port_browser/ports1.txt -d $output --headless
