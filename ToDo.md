
# **TODO:** 

Design decisions:  
- why did you do it that way  
- why didn't you use X?  

Make scripts more distro agnostic  
- Autolaunch.sh is made to work for most debian based distros, will test on Wssl and/or via a PS script on win10 since commands for aws cli are (mostly) the same

Make scripts lighterweight and optimize them. 
- string more commands together 
  - && additional commands only runs if previous command has exit status of zero
  - ; additional commands run regardles of exit status of previous commands

Revise Guides for readability and clearness
- mostly checking grammer, spelling, and consistency of formating/punctuation  

Automate OPNsense configuration

Pickup milk and eggs at the store

Remove sudo from scripts, as multiple systems (arch, gentoo, multipleBSD, redhat etc) don't have it by default.  
- Figure out better way to either run who scripts as root (not preferred) or running needed commands as root (preferred)  

Seperate code and data in script.sh, possible ways:  
- have seperate setupVars.conf files for wireguard and pihole automagic installations that are premade and moved via scp when moving script.sh  
  - would have to run multiple commands to make directories, and move .conf files into needed files in autolaunch.sh *before* starting script.sh  
- move script.sh and a new second script that contains the portions of script.sh that make directories/make .conf file, seperating them  
- have both .conf files premade and then after directories are made in script.sh, curl them down into their respective spots (with something like curl -L url/whatever.conf -O (-O preserves file name and type))

