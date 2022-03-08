
# **TODO:** 

Design decisions:  
- why did you do it that way  
- why didn't you use X?  

Make scripts more distro agnostic  
- Autolaunch.sh is made to work for most debian based distros, will test on Wssl and/or via a PS script on win10 since commands for aws cli are (mostly) the same

Make autolaunch.sh check to see if package is installed, and if not, then install.
- Currently just tells it to install. While this usually isn't an issue, it can cause potential issues and it REALLY irk's some people.
- You know know what? Maybe I should leave it in just for that reason.

Make scripts lighterweight and optimize them. 
- string more commands together 
  - && additional commands only runs if previous command has exit status of zero
  - ; additional commands run regardles of exit status of previous commands

Revise Guides for readability and clearness
- mostly checking grammer, spelling, and consistency of formating/punctuation  

Automate OPNsense configuration

Make instructions simpler, people have not and will not read them fully and inevitably break something (aws access keys being the prime example).

Add more if-then statements. For example: 
- Currently autolaunch.sh checks for instances previously made with the script, and deletes them. With a wait of 30 seconds. Statement there would eliminate the 30 second wait if not needed.
- When asking if you want to download the OPNsense iso, the usb drive iso writer message shouldn't show if no is selected.

Pickup milk and eggs at the store

Devise way to grab latest OPNsense iso automatically. Removes need to manually update.

Remove sudo from scripts, as multiple systems (arch, gentoo, multipleBSD, redhat etc) don't have it by default.  
- Figure out better way to either run who scripts as root (not preferred) or running needed commands as root (preferred)  

AWS improvments (in autolaunch.sh):
- AMI currently is specific for US-west-1, devise way to take default region supplied and grab latest Ubuntu LTS. This eliminates the need to update the script.
- Provide an example of what people need to put in aws configure (as a stand-in before making the profile is automated)
- Either silence output for deleting of keys/instances/whatever, as when theres nothing to delete, it gives an error message that doesn't matter but can give user false impression of script failing.

Change wordings on prompts for clarity on whats being asked for, or that commands supplied are for later use.
