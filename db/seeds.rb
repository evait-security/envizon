# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if SavedScan.all.empty?
  SavedScan.create([{ name: 'ARP scan', parameter: '-sP -PR' },
                    { name: 'Enumerate devices only', parameter: '-sn -T4' },
                    { name: 'Quick OS SMB detection', parameter: '-n -sU -sS --script=smb-os-discovery.nse -p U:137,T:139,T:445 -T4' },
                    { name: 'Quick Java RMI / JMX scan', parameter: '-n -p 1098,1099,1090,8901,8902,8903,9999 -sV --script rmi-vuln-classloader,rmi-dumpregistry -T4' },
                    { name: 'Quick FTP-Anonymous detection', parameter: '-n -p 21 --script ftp-anon -T4' },
                    { name: 'Default scripts, top ports, OS detection', parameter: '-O -sC -T4' },
                    { name: 'Default scripts, top ports, OS detection - light', parameter: '-O -sC -T4 --exclude-ports 9100-9107 --version-light --max-retries 2 --script-timeout 15s' },
                    { name: 'Default scripts, top 300 ports, OS detection, service detection', parameter: '--top-ports 300 -O -sC -sV -T4' },
                    { name: 'Default scripts, top 300 ports, OS detection, service detection - light', parameter: '--top-ports 300 -O -sC -sV --exclude-ports 9100-9107 -T4 --max-retries 2 --script-timeout 15s' },
                    { name: 'Scan all ports', parameter: '-p- -T4' },
                    { name: 'Full scan', parameter: '-O -p- -sC -sV -T4' },
                    { name: 'Full scan - light', parameter: '-O -p- -sC -sV --exclude-ports 9100-9107 -T4 --max-retries 2 --script-timeout 15s' },
                    { name: 'Fast scan', parameter: '-F -T4 --max-retries 1 --script-timeout 10s' },
                    { name: 'Fast scan with OS-Discovery', parameter: '-F -T4 --max-retries 1 -O --version-light --script=smb-os-discovery --script-timeout 10s' },
                    { name: 'Scripts: Web', parameter: '-p 80,443,3000 -sV --script "http-* and not(dos or brute)"'},
                    { name: 'Scripts: SMB', parameter: '--script "smb* and not(dos or brute)" -p 139,445 -sU -sT' },
                    { name: 'Scripts: Broadcast', parameter: '--script=broadcast --max-retries 2 --script-timeout 30s -T4' },
                    { name: 'Vuln: all', parameter: '--script=vuln --max-retries 2 --script-timeout 30s' },
                    { name: 'Vuln: Exploit', parameter: '--script=exploit --max-retries 2 --script-timeout 30s' },
                    { name: 'Vuln: MS08-067 - TCP', parameter: '--script smb-vuln-ms08-067.nse -p445' },
                    { name: 'Vuln: MS08-067 - UDP', parameter: '-sU --script smb-vuln-ms08-067.nse -p U:137' },
                    { name: 'Vuln: MS17-010', parameter: '-p445 --script smb-vuln-ms17-010' },
                    { name: 'Vuln: smb-double-pulsar-backdoor', parameter: '-p 445 --script=smb-double-pulsar-backdoor' }])

end

if Label.all.empty?
  Label.create([{ name: 'Null Session', description: 'Null Sessions are fun', priority: 'warning' },
                { name: 'SMB Signing', description: 'Message signing for SMB is disabled', priority: 'danger' },
                { name: 'Anonymous FTP', description: 'Anonymous FTP login allowed', priority: 'warning' },
                { name: 'MS17-010', description: 'A critical remote code execution vulnerability exists in Microsoft SMBv1', priority: 'danger' },
                { name: 'MS08-067', description: 'A critical remote code execution vulnerability exists in Microsoft SMBv1', priority: 'danger' },
                { name: 'WinRM', description: 'WinRM login enabled', priority: 'warning' }])
end
