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
                    { name: 'Quick OS SMB detection', parameter: '-sU -sS --script=smb-os-discovery.nse -p U:137,T:139 -T4' },
                    { name: 'Quick OS-discovery, variant', parameter: '-O --top-ports 100 --script=smb-os-discovery -T4' },
                    { name: 'Default scripts, top ports, OS detection', parameter: '-O -sC -T4' },
                    { name: 'Default scripts, top 300 ports, OS detection, service detection', parameter: '--top-ports 300 -O -sC -sV -T4' },
                    { name: 'Scan all ports', parameter: '-p- -T4' },
                    { name: 'Full scan', parameter: '-O -p- -sC -sV -T4' },
                    { name: 'Vuln all', parameter: '-Pn --script=vuln' },
                    { name: 'Vuln: Exploit', parameter: '-Pn --script=exploit' }])
end

if Label.all.empty?
  Label.create([{ name: 'Null Session', description: 'Null Sessions are fun', priority: 'orange darken-1 white-text' },
                { name: 'SMB Signing', description: 'Message signing for SMB is disabled', priority: 'red darken-1 white-text' },
                { name: 'Anonymous FTP', description: 'Anonymous FTP login allowed', priority: 'orange darken-1 white-text' },
                { name: 'MS17-010', description: 'A critical remote code execution vulnerability exists in Microsoft SMBv1', priority: 'red darken-1 white-text' },
                { name: 'MS08-067', description: 'A critical remote code execution vulnerability exists in Microsoft SMBv1', priority: 'red darken-1 white-text' }])
end
