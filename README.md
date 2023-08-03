# bash_scripting
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors)
<!-- ALL-CONTRIBUTORS-BADGE:END -->
[![Bash Shell](https://badges.frapsoft.com/bash/v1/bash.png?v=103)](https://github.com/ellerbrock/open-source-badges/)

### Description:
bash scripts I use daily to automate some stuff and make linux easier, there's no specific purpose behind this repo only to share any script that i think will be usefull for somebody else, or anyone who wants to learn bash script and needs some ideas to practice (that's how i learnt :D)

Most of the script in this repo has some comments inside to explain the purpose of the script and how it can be used, but i'm gonna leave here a description for some of them and how they can be used if needed.

- [ASNenum.sh](https://github.com/bing0o/bash_scripting/blob/master/ASNenum.sh):
  this script use [api.hackertarget.com](https://api.hackertarget.com/aslookup/) to do ASN Enumeration against an IP address or ASN number, if the input is an IP address you will get an ASN number and a CIDR, if the input is an ASN you will get a list of CIDRs (one or more) that belongs to the same owner.

- [DomainToIP.sh](https://github.com/bing0o/bash_scripting/blob/master/DomainToIP.sh):
  wrapper around nslookup linux cli tool to translate hostnames to IPs.

- [Get_all_domains.sh](https://github.com/bing0o/bash_scripting/blob/master/Get_all_domains.sh):
  uses https://reverse-whois-api.whoisxmlapi.com/ to enumerate TLDs (Top Level Domains) that belongs to the same owner based on Registrare Email/Name whois records.

- [ReverseIP](https://github.com/bing0o/bash_scripting/blob/master/ReverseIP.sh):
  script to do a reverse ip lookup, you give this script an IP address and it will try to find all the domains hosted on that IP.

- [Reverse_Shell_payload_generator.sh](https://github.com/bing0o/bash_scripting/blob/master/Reverse_Shell_payload_generator.sh):
  this is a script that generate reverse shall payloads for you, more info could be found here: https://bing0o.github.io/posts/reverse-shell-generator/

- [StatusCode.sh](https://github.com/bing0o/bash_scripting/blob/master/StatusCode.sh):
  checks for status code, size, redirected url and the Title for a list of domains or ips.

- [domains.sh](https://github.com/bing0o/bash_scripting/blob/master/domains.sh):
  this tool is no longer going to be update, check the newer version here: https://github.com/bing0o/SubEnum

- [encall.sh](https://github.com/bing0o/bash_scripting/blob/master/encall.sh):
  wrapper around my other python tool ([crypto](https://github.com/bing0o/Python-Scripts/blob/master/crypto.py) which is a tool to encrypt and decrypt files), to encrypt all the files in the current directory.

- [file-share.sh](https://github.com/bing0o/bash_scripting/blob/master/file-share.sh):
  uses https://www.file.io/ to share files, this tool will provide a one time use link for the shared file which will no longer be available after the first download, usefull when you want to transfer small files between two systems.

- [naabu-to-nmap.sh](https://github.com/bing0o/bash_scripting/blob/master/naabu-to-nmap.sh):
  this script takes the results of [naabu](https://github.com/projectdiscovery/naabu) and run nmap against them with `default` and `vuln` scripts and other options to go deep with each port `naabu` found.

- [port.sh](https://github.com/bing0o/bash_scripting/blob/master/port.sh):
  simple port scanner for fast results, I use it to check if a specific port is open on a remote servers.

- [send-to-burp.sh](https://github.com/bing0o/bash_scripting/blob/master/send-to-burp.sh):
  bash script to send a list of URLs from command line to burpsuite to add them to your site map, without having to open them in the browser.

- [vpn_on_vps.sh](https://github.com/bing0o/bash_scripting/blob/master/vpn_on_vps.sh):
  if you run a VPN on a remote server for whatever reason, you will lose your ssh connection and you won't be able to connect to the remote server until the VPN connection is down, this script will prevent that from happening, when you run this script on remote server before running your VPN client you won't lose your ssh connection and you still can connect to the server while the VPN is still up and running.

  
## Support
you can support me here: https://www.buymeacoffee.com/bing0o

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://www.youtube.com/channel/UCfp-lNJy4QkIGnaEE6NtDSg"><img src="https://avatars3.githubusercontent.com/u/31768530?v=4" width="100px;" alt="Terminal for Life"/><br /><sub><b>Terminal for Life</b></sub></a><br /><a href="https://github.com/bing0o/bash_scripting/commits?author=terminalforlife" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
