

# **Setting up the OPNsense network appliance**   

After setting up the remote machine in EC2 (made in a previous guide, or automaticly via the autolauch script), the next step would to build your own router that runs all/some traffic through the remote machine. This is not only an awesome router in it's own right, but, it makes it super easy to get the additional privacy and advertisement blocking on all device in your home without the need of configuring individual clients like in the previous steps. In fact, you can skip the laptop step if you ONLY ever use it at home. We will be using OPNsense, open-source router/firewall software forked from pfSense.  

If you don't have that image, and/or also need program to write the image to a bootable usb drive:
* [OPNSense-VGA-AMD64 network appliance OS ](https://mirror.sfo12.us.leaseweb.net/opnsense/releases/22.1/OPNsense-22.1-OpenSSL-vga-amd64.img.bz2) 
* [Balena Etcher USB stick burning software](https://www.balena.io/etcher/)  

> Note that if you used the autolaunch script, you should have been asked if you wanted to download the image, and may already have it in the /scripts folder or elsewhere.

Now you will utilize the hardware you ordered previously and the image you already downloaded. The image is compressed with .bz2 format. On Linux and MacOS you can decompress it by running: 

```shell
bzip2 -d ~/Downloads/OPNsense-22.1-OpenSSL-nano-amd64.img.bz2
```  

Your terminal should go back to a normal prompt once complete.

Note that you may need to install bzip2 via your package manager on a Mac with:  

```shell
brew install bzip2
```  

Or on Ubuntu / Debian linux with:  

```shell
apt install -y bzip2
```

Once you have the .img uncompressed, you need to write it to the usb stick previously mentioned. You will launch Balena Etcher on your laptop/desktop with the image, and plug in your shiny new USB stick, in order to burn the image to the stick. 

> You technically should be able to flash your drive without unzipping it, but I haven't seen it work consistently, which is why there are instructions for unzipping it.

> **Please keep in mind that you will overwrite everything on the usbs tick in this step, so check it first to ensure there is nothing on it that you are not ok losing**

Once downloaded and opened, you will want to:  

Click "Flash from file" and select the uncompressed .img file  

Click "Select target" and select the usb stick that you will use, and click select at the bottom of the screen.  

Click "Flash!" to start the process of writing the image to the usb stick. 

Wait for it to complete and remove the usb stick once done.  

![opn1](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn1.png)

> Depending on flash drive and computer used, this can take anywhere from 5-20 minutes. Grab a cup of coffee! Take a break!

Once completed, you will want to remove the USB stick from your laptop, and then plug it into your shiny new Intel NUC and turn the machine on.  


> You can use almost any other machine with a dual network card other than this NUC, this is just a known working configuration. If you alter the recipe to your own taste, your results may vary! 


**If you were perviously using another OS or have configured the NUC before, reset the CMOS to make sure you're starting from a fresh configuration.**

## **Installation**

Before starting, make sure you don't have any ethernet cables plugged into your target machine.

Insert the bootable drive you made into the device you're making your router, and turn it on.

Once it is turned on, you will need to boot from the USB stick that you plugged in. On this model of NUC you can use F8.

After a loading screen, you will be asked about interfaces, press enter (quickly its timed!) and put in n then enter when it asks if you want to configure WAGS and VLANS, then installer asks for WAN assignment.  

![opn2](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn2.png)

Type `a` for autodetection and hit enter. You will be asked plug in the cable for the WAN.  
At this time, connect one ethernet cable that should go from your ISP / modem to one ethernet port on your NUC. 

Do not plug in the other cables. 

After a moment it will say "*** LINK UP", and you will hit enter to confirm.  

![opn3](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn3.png)

Next, the installer will ask for LAN assignment. Type `a` for autodetection and hit enter.  
Connect a second cable between the second NUC network port, and plug it into your switch/computer.   

After a moment OPNSense will say "*** LINK UP", and you will hit enter to confirm.  

![opn4](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn4.png)

If it asks to configure any optional interfaces, press enter to skip.  


Once your machine is fully booted up,it should look like this:  

![opn5](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn5.png)

It will ask if you want to run the installer. Enter the installer username:  

```
username: installer	
```  

...and password:  

```
password: opnsense
```  

You will likely want to go through the next few prompts and select the default values until it asks to select the drive you want to write to. I am using a standalone machine, so I can just hit enter through everything, but you may need to select what drive you want if you are dual booting.  

![opn6](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn6.png)

> Defaults will completely wipe the disc. If that's an issue for you, Google what people do for "partitioning hard drives."

Once the installation is complete, you can change the root password/complete install.  

Select complete install and hit enter.  

After your machine turns off, remove the installation media.

Once complete, the screen should look like the following (your interface names and IP's may be different):  

```
* * * Welcome to OPNsense [OPNsense 27.7.7 (amd64/OpenSSL) on OPNsense * * *

WAN (em1)     -> v4/DHCP4: 192.168.x.x/24
LAN (em0)     -> v4: 192.168.1.1/24

FreeBSD/10.1 (OPNsense.localdomain) (ttyv0)

login:
```

## **Configuring OPNsense**

Once you reach this screen, you will want to navigate to the web interface via a laptop that is connected to your switch or that is hooked in directly into your OPNsense machine.  
If you don't have an ethernet port on your labtop, use a USB to etherent adapter. 

To get there, go to your web browser and type in IP address shown next to LAN (such as in the example 192.168.1.1.) that is shown for your machine minus the subnet mask (like the /24 in the example.)  

You will get to a login screen, and be prompted to login with this field: 

![opn8](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn8.png)

***The default credentials for both the web gui and the direct interface once the device is setup are:***

```shell
username: root
```
```shell
password: opnsense
````
    
> During this guide you will be making multiple changes to a variety of things. 
If you find something not showing where it should be, you may need to reboot the system under Power > Reboot, or by holding down the off button until it turns off, and then pressing it again to turn it back on. 
  
  
## Setting up Wireguard  

The first thing we will want to do is download the Wireguard plugin via System on the lefthand menu, then select Firmware, then Status, and finally Check for updates at the bottom of the screen  

![opn9](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn9.png)

> You may need to click the reboot button if it gives on at the bottom of the screen, then log back in and come back to this screen.

Once complete, select Plugins.

Then select os-wireguard and click the + symbol on the right to download the plugin.  

![opn10](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn10.png)

>If you're unable to find it, you may need to update again via "updates" tab next to the "plugins" tab and look again once done. Once downloaded, reboot the machine again via Power then Restart in the lefthand menu.

Once back up, then you will want to navigate to VPNs and then Wireguard via the lefthand menu.  

Before continuing, open a tab that is connected to your EC2 instance on your machine or on a seperate machine that has internet access if yours does not have. 

In a pinch, you can also do this off of your phone with an SSH client, or use a second laptop, your neighbors wifi, etc. You can also get this information and come back to configuring your OPNsense machine!

You will need the following information to make your local peer and endpoint connections:  
*The information from your OPNsense config for Wireguard previously made in your ec2 console. This is usually placed under /home/ubuntu/configs/(clientname).conf* 

Under VNP, then Wireguard in the lefthand side of the OPNsense menu, select the "Local" tab and then the + button to the right to create a new local peer.  

![opn11](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn11.png)

Fill out the following fields. If a field is not listed, leave it blank or at the default value if it is already filled in or has an option.  

* Ensure that "advanced mode" that is in the upper left hand corner is enabled to be able to see the DNS options.  

* Enabled: Checked  

* Name: Whatever name you would like to use, like wglocal  

* Public key: Leave this blank, it will auto fill once the local peer is saved, and a private key is inputed.  

* Private key: This is located in the .conf file mentioned perviously on your EC2 instance. It will look like this:  

```
[Interface]
PrivateKey = THIS-RIGHT-HERE
Address = 1.1.1.1/224
DNS = 2.2.2.2
```

Copy the PrivateKey to the Private Key field.  

* DNS Server: This is the address for the pihole and is what enables the adblocking. This is listed in the same place as the 2.2.2.2 in the example above. This needs to be filled in to ensure that any clients connected through this firewall/router use the pihole as their dns, allowing them to take advantage of the adblocking that you have set up in AWS.  
* Listen Port: This is the port previosly set, in my guide we used the default 51820  

* Tunnel Address: This is the address under "Address" in the example above, where 1.1.1.1/24 is. Make sure you include the entire address including the mask (the /24 at the end)  

* Peers: This is left blank, until after we create our endpoint. 

![opn12](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn12.png)

Once completed, click Save then Apply Changes.  

Select the "Endpoints" tab and click the + button to create a new endpoint.  

![opn13](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn13.png)

Fill out the following fields. If a field is not listed, leave it blank or at the default value if it is already filled in or has an option.  

* Enabled: Checked  

* Name: Label it however you would like, such as wgendpoint  

* Public Key: This is also located in the .conf file mentioned previously. The lower half of the file will look like this:  

```
[Peer]
PublicKey = USE-THIS-FOR-THE-PUBLIC-KEY
PresharedKey = USE-THIS-FOR-THE-SHARED-SECRET
Endpoint = 3.6.6.6:51820
AllowedIPs = 0.0.0.0/0, ::0/0
```

Use the value in the Public key field in the .conf file in the Public Key field for the endpoint.  

* Shared Secret: Use the value in the PresharedKey field (like in the example above) in the .conf file in the Shared Secret field for the endpoint.  

* Allowed IPs: Enter 0.0.0.0/0 to allow your local network to connect to the tunnel. 

* Endpoint Adress: Enter the value from Endpoint field in the .conf file (like in the example above, but remove the ":" and everything to the right of it) into the Endpoint address field for the Endpoint configuration on OPNsense.  
This is the elastic IP that we previously assigned to our EC2 instance in AWS. This is the static IPV4 address that the instance can be reached at. If you want to double check the address, its displayed to the right of the name of the instance on the EC2 console, or in the lower left of the screen under Public IPs if you connect to the instance via the browser.
   
* Endpoint port: This is the port that was previously set when setting up wireguard. It's whats listed to the right of the ":" after the IP address in the Endpoint field. In the previous guide, we set this up with the Wireguard default of 51820.  
If you want to double check, type `wg` in your EC2 instance and check what the "listening port" is under the interface at the top.  

* Keepalive: 25  

![opn14](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn14.png)

* Click Save at the bottom, and then Apply.  

![opn15](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn15.png)

Go back to the local peer previously made, and click the pencil icon to edit it.

Change the "peer" value to the new endpoint just made.  

![opn16](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn16.png)

Click on the General tab, and make sure Enable Wireguard is checked.  
  
Click on Power and then Reboot on the left hand menu, and reboot the machine.  

Once back online, log back into the web interface.  


## **Making an interface.**  

Select Interfaces then Assignments on the lefthand field in OPNsense.  

Next to where it says "New Interface" under WAN and LAN, select the new network port. (likely says wg0)  

Give it a name (such as WGinterface or WG0) and click the + button to add it and hit save then Apply changes.  

![opn17](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn17.png)

To the left, you should see your new interface you named next to LAN and WAN above Assignments.  

Click it and fill out the following fields. If a field is not given, leave it blank or at the default value.  

* Enable: Checked  

* Block Private networks: Unchecked  

* Block bogon networks: Unchecked  

* Description: This should be filled with the name you previously gave it  

* IPv4 Configuration type: None  

* IPv6 Configuration type: None  

* Dynamic gateway policy: Checked  

Then click Save and Apply Changes  



## **Creating a gateway**  

From the lefthand menu, select System, then Gateways, then single. 

Click the orange + button at the top to create a new gateway.  

> You may have one prebuilt in there that is called: interfacename_GW, in which case hit the pencil icon to modify

![opn18](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn18.png)

Fill in the following fields. If a field is not given, leave it blank or at the default value.  

* Name: Name this gateway what you would like (such as WGgateway)  

* Interface: Select the interface that we previously made before this (that I suggested you call WGinterface) * Address Family: IPv4   

* IP Address: dynamic (This needs to be fully undercase)  

* Upstream Gateway: Checked  

* Far Gateway: Unchecked  

* Disable Gateway monitoring: Checked  
Note: You can use the gateway monitoring to automatically failover to a different gateway if OPN is unable to ping the gateway. You may want to use this, but for the sake of simplicity, we are skipping it in this guide.  
  
Click Save and Apply Changes.  

You likely have at least two gateways that were pre-made, WAN_DHCP & WAN_DHCP6.  

Click the green arrow to the left of their names (and any others that may be there) and click apply changes at the top to disable these gateways.  
    
Click Save and Apply Changes.  

> If clicking the green arrows does nothing, you can also click the edit button and manually check the Disabled checkbox

![opn19](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn19.png)

Click on Power and then Reboot on the left hand menu, and reboot the machine.  

Once back online, log back into the web interface.  


**Disabling IPv6**  

Click Firewall on the lefthand menu  

Click Settings and then Advanced  

Uncheck "Allow IPv6" at the top and click Save.  
  
  
## **Firewall Rules**

**Outbound Firewall Rules**  

Click Firewall on the lefthand menu  

Click Nat then Outbound under that.  

Under Mode, select Hybrid outbound NAT rule generation and then click Save and Apply changes.  

![opn20](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn20.png)

Under Manual rules you should have no rules, (or just one that says "WireGuard (group))  

Click the orange + to create a new rule (or the pencil icon to edit the Wireguard (group) rule if it was automaticly generated)  

Fill in the following fields. If a field is not given, leave it blank or at the default value.  

-Do not NAT: Unchecked  

-Interface: Wireguard (Group)  

-TCP/IP Version: IPV4  

-Protocol: Any  

-Source address: LAN net  

-Destination invert: Unchecked  

-Destination address: Any  

-Translation/target: Previously made interface (I named it WGinterface) address  
Click Save and then Apply Changes  

![opn21](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn21.png)

**Inbound Firewall Rules**  
   
**LAN**  

Go to Firewall and then Rules on the lefthand menu.   

Go to LAN and click the orange + to make a new rule.  

Fill in the following fields. If a field is not given, leave it blank or at the default value.  

* Action: Pass  

* Disabled: Unchecked  

* Quick: Checked  

* Interface: Lan  

* Direction: In  

* TCP/IP Version: IPv4  

* Protocol: Any  

* Source: Lan Net  

* Destination: Any  

Click Save and Apply changes.  
  
**Configuring WireGuard Interface**  

Go to Firewall and then Rules on the lefthand menu.    

Go to interface you made for Wireguard (I named it WGinterface) and click the orange + to make a new rule.  

Fill in the following fields. If a field is not given, leave it blank or at the default value.  

* Action: Pass  

* Disabled: Unchecked  

* Quick: Checked  

* Interface: (this interface, ex:WGinterface)  

* Direction: In  

* TCP/IP Version: IPv4  

* Protocol: UDP  

* Source: Any  

* Source port range: In both fields select (other) and put in the port for WG that you have been using. (51820 is the default and what has been used in this guide)  

* Destination: Any  

Click Save and Apply changes. 

![opn22](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/opn22.png)
  
**System Settings**  
  
* On the lefthand menu, select System, then settings, then General.  

* Prefer IPv4 over IPv6 should be checked  

* DNS servers should be blank and gateways should all say none.  

* DNS server options should be checked.

* Click Save and you're done! Do a final reboot and you should be online and passing all traffic that goes through this device to your EC2 instance, where it is being filtered!
