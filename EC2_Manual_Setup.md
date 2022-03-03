
# Setting up your EC2 instance

>We will be using the AWS free tier for this example, but it would be wise to set up billing alerts in case you accidently go over! Surprise charges aren't fun!

## Requirment's/Prep
**Cloud Account required:**

If you don't have one, [create a free Amazon Web Services (AWS)](https://aws.amazon.com/free) account.

**Pre-Download:**  
I would download these in the background if you plan to make a local OPNsense box as part of the next guide. Ignore these if you are just wanting the EC2 instance for the VPN/Ad-blocking on the go for laptops/mobile devices. 
* [OPNSense-VGA-AMD64 network appliance OS ](https://mirror.sfo12.us.leaseweb.net/opnsense/releases/22.1/OPNsense-22.1-OpenSSL-vga-amd64.img.bz2) 
* [Balena Etcher USB stick burning software](https://www.balena.io/etcher/)  


## **Setup of instance**

**Select the AWS region nearest to you.**  

Select AWS region (upper right hand of the screen) closest to you geographically. For me, it'll be Northern California.

**Go to EC2 (Elastic Cloud Compute)**  

Once you have made an account and signed in, you will be taken to the console home. Select or search for the EC2 service, and then select Instances of the left hand menu.

**Create a new EC2 instance in AWS**  

Select launch instances.  

![photo1](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo1.png)

Select Ubuntu Server 20.04 LTS, and then hit next. 

![photo2](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo2.png)

In the instance type, select t2.micro (as that is free to use).  

![photo3](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo3.png)

Then continue to press next until you reach step six, which will be configuring Security Groups.  
You will have a built in firewall rule for SSH, leave that.  
CLick add rule, and then select:  
Type: Custom UDP  
Protocol: UDP  
Port range: 51820  
Source: Anywhere 0.0.0.0/0, ::/0
Description: Wireguard

![photo4](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo4.png)

> You can choose any port you would like, but keep in mind it needs to be consistent during the entire installation process. If you changed it, any time 51820 is specified in this guide, put in the port number you want instead. 

**Generate and download your keys**  

Go ahead and name your key. For now we will call it myawesomekey. 

AWS will then let you download it as myawesomekey.pem.  

![photo5](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo5.png)

Set it's permissions correctly using the following command on your local machine: 
  

```shell 
sudo chmod 400 ~/Downloads/myawesomekey.pem
```


>You may need to change the path to where your key was downloaded in the command.

You will want to make a backup of this key. If you lose it, and you want to set this up again, you'll have to do it form scratch.


**Elastic IP**  

You have to generate an static IP address that you can attach to your instance, so you're consistent and don't have to reconfigure your clients.  

To do this, go to the lefthand side and select elastic IP's under Network and Security when at your EC2 instance home screen.  

Click Allocate in the upper righthand side:

![photo7](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo7.png)

Then click Allocate at the bottom of the next screen to confirm.  

Once that's completed you will see the new address on your screen.  
 
Select it, and then under Actions in the upper right, click associate:

![photo8](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo8.png)

Associate the IP with the instance that you made:

![photo9](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo9.png)


**Launch the instance**

**Check to see it's running see that it's launched**

>It may take a minute or two to show running!  

![photo10](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo10.png)
  
**Remotely connect to your EC2 instance via SSH**  
Open a terminal on your laptop and run this in the directory that you saved your key file, swapping out the IP address of the server for the elastic IP you attached to it, unless you chose to use an Elastic IP alternative**  

>Any time this guide mentions using SSH to connect to the instance, you can also select the instance and hit the connect button along the upper option on the EC2 console instance home screen.


```shell
ssh -i ~/myawesomekey.pem ubuntu@123.456.789.10 
```


**If you connect successfully you will see (along with a page of systen information and information**  

```shell 
ubuntu@ip-123.456.789.10:~# 
```

For example mine shows:  
![photo11](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo11.png)

## Installing pihole

**Let's update the OS and all of it's packages.**

We wil need to run these commands:  

```shell
sudo apt -y update
```
And then:

```shell
sudo apt -y upgrade  
```

These may take a few minutes to fully run!

**Now lets set up your pihole / DNS server**  

Run:  

```shell
curl -sSL https://install.pi-hole.net | sudo bash 
```  

Once the installer has finished downloading, you will see this:

![photo12](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo12.png)

The wizard will walk you through installation and setup.  
Most will want to just leave the default values, and just hit enter for most values.
(Make sure to hit yes when it asks about a static ip!)

If you are unsure what to select, it's best to leave the default value and hit enter. 

You will see this once complete:

![photo13](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo13.png)

**WARNING: Write down the web password when it prompts you!!!** 
If you want [additional info about this installation visit](https://github.com/pi-hole/pi-hole/#one-step-automated-install)


**Reboot your instance once completed**  

Do this by running:  

```shell 
sudo reboot now
```  

>To further configure your pihole, got to pi.hole/admin in your web browser and log in with the password perviously given. There are numerous ways to configure and set up your pihole. The default setup will work great for most people, but it is worth looking up other guides if you have futher configuration questions.



## Setting up your VPN endpoint

**Once your instance has rebooted (check it's status on the console home if you need to), SSH back into the instance like before.**  
  
```shell
ssh -i -t ~/myawesomekey.pem ubuntu@123.456.789.10 
```

> Reminder that the IP in the above command should be changed to your elastic ip.

**Let's download and install**  

```shell
curl -L https://install.pivpn.io | sudo bash
```

Once completed, you will see a similiar wizard to the first:

![photo14](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo14.png)

You can hit enter through this entire wizard up until it asks if you would like to reboot, then using the arrow keys, select and hit enter.

> If you used a custom port number, when prompted enter the port number that youentered when we created a custom rule for Wireguard before


If you accidently hit cancel reboot, run:  

```shell
sudo reboot now
```

SSH back into to the instance once the instance is back online, which you can see if it is in your dashboard. This may take a minute or two, so if it doesn't connect immediatly, wait a couple of minutes.

> If you want additional info about this installation [visit here](https://docs.pivpn.io/wireguard/)



## **Configuring your clients**

You will need to configure each of your clients to access your EC2 endpoint. However, if you use our homebrew router design, anything on that network automatically be tunneled. This means that if you have an old IOT coffee machine or IOT Japanese toilet, which you can't install a Wireguard client on, you're still protected... nobody can see when you poop. Additionally, if you run the WireGuard client on your laptop or phones when out and about, you'll get the same benefits. 

I personally use three configs, one for my phone, laptop, and for the router that we set up later. 

To make a client config on a MacOS laptop, run this in your instance's terminal:

```shell
pivpn -a
```  

Give the config the name you want identifying what it'll be used for such as:

```shell
Gamer_Laptop_EXTREME
```  

![photo15](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo15.png)

**Now get the WireGuard client for your devices**  

MacOS / Linux / Windows: [WireGuard.com/install](https://www.wireguard.com/install)  

Android: [WireGuard on Google Play](https://play.google.com/store/apps/details?id=com.wireguard.android&hl=en_US&gl=US)  

iOS: [Wireuaurd on Apple's App store](https://play.google.com/store/apps/details?id=com.wireguard.android&hl=en_US&gl=US)  


## **Setting up on phone/tablets**  

Once downloaded on your phone/tablet, tap the + in the lower or upper right hand side of the screen to add a new tunnel. Go to your EC2 instance and then type `pivpn -qr` and then the name of the client you made. This generates a QR code that you can then scan with the app you downloaded.  

![photo16](https://git-pics-666.s3.us-west-1.amazonaws.com/git-pics/photo16.png)

> Locations of prompts to add tunnels/the + button will differ platform to platform

## **Setting up clients for Mac / Windows / Linux** 

You will need to chose the option "import a tunnel", and then upload the config file that is created when you make a client, so you'll need to download Gamer_labtop_EXTREME.conf (or whatever you named your config) file from your EC2 instance to your local now machine.

I used the scp command to move it via a terminal, make sure to replace the IP address with the elastic IP you assigned to your EC2 instance.  

```
scp -i ~/Downloads/myawesomekey.pem ubuntu@123.456.789.10:/home/ubuntu/configs/Gamer_Laptop_EXTREME.conf ~/Downloads/Gamer_Laptop_EXTREME.conf
```  

> The syntax for this is: scp -i ~/location_of_key.pem source_user@elastic_or_public_ip:/location/of/source/file.conf ~/destination/on/local/machine.conf

Once you have the .conf file on your local machine, go to the WireGuard client and import the .config file using the "import tunnel" or "+" option in the lower lefthand corner.  

> **Keep in mind you must make a individual configuration for EACH client, such as each phone, laptop, router, etc, individually.**

