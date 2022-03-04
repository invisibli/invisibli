## Hybrid setup

### Intended setup
The hybrid setup has a fairly simple process: 
- You get your [AWS accesskeys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) if you haven't already.
-The script will ask for your keys, but you may want to look at [potentially configuring them first](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- Then running the autolaunch.sh script which makes and configures the EC2 instance, then launches the script.sh and configures the server for ad-blocking/sets up VPN server.  
- After that, you would follow the OPNsense_Guide manual setup guide to finish setup if you want to make the router.  
- If you would like an easy way to set up a singular wireless access point, there is a [bonus guide for that as well!](./Unifi_AP.md)  


What does that actually mean?    
- run `git clone https://github.com/invisibli/invisibli.git` in the location of your choosing on your local mac/linux machine (windows coming soon!)
- `cd invisibli && ./autolaunch.sh`


If the script encounters no issues, after 5ish minutes, you should be fully setup.
The EC2 instance will reboot and after a few minutes you should be able to reconnect.
Once it's booted, you will want to set up client configs for your devices following the [Set up wireguard client guide.](./Set_up_wireguard_client.md)


<!-- ### Withought using git
If you would rather not download it via the git cli tools, you could also do `` (may neeed to run as root depending on your setup. -->

### Troubleshooting

The advice and suggestions below are based on issues that have been encountered, but will vary depending on your disto. I *highly* recommend you do your own research in conjunction with anything here (especially when doing anything ssh), before making any changes to your machine.

<!-- To do: get the curl/wget command -->
- Depending on your connection, your instance might run into an error when trying to run the second `script.sh`. If this happens, you can log into your EC2 instance via the web console and run it manually with curl or wget. 

- Depending on your setup you may have a few different things error during scp/ssh:
  - "Are you sure you want to continue connecting (yes/no)?" In which case, type yes and accept
  - "Received disconnect from x.x.x.x: Too many authentication failures" This is often caused by the defualt behavior of ssh, which will try one key and if it fails, continue to try others that you have. If you have a large number of keys, this can cause issues. For some, you could run a revised version of the command at the end of the script: 'ssh -t -i invisibli.pem -o IdentitiesOnly=yes ubuntu@$eip '/home/ubuntu/script.sh'. Others may want to modify their ~/.ssh/config file with:  
   
```
Host * 
       	IdentitiesOnly=yes
```
  
- If a setting on your account stops or errors out on the AWS EC2 instance, you may be left with a extra instance, and a extra elastic IP.
  - To solve this, terminate the extra instance, release the unneeded IP (may need to wait 30 seconds after terminaiting the instance for AWS to catch up and let you, and restart/relaunch your shell. After which you should be able to relaunch the script.
