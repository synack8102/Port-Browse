import webbrowser
import re

firefox_path = "\/usr\/bin\/firefox"
nmap_ports = open('/opt/port_browser/nmap_ports.txt', 'r')

regex = re.compile(r'[A-Za-z]')
protocol = input("Enter 'http' or 'https':")

for line in nmap_ports:
    mo1 = regex.search(line)
    if bool(mo1) == True:
        Base_URL = line
    else:
        URL = protocol + '://' + Base_URL + ':' + line
        webbrowser.get('firefox').open(URL)

nmap_ports.close()
