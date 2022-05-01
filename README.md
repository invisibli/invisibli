![logo](./unsolicited_git_pics/logo/4x/invisibli_black_alpha_bordered.png#gh-light-mode-only)
![logo](./unsolicited_git_pics/logo/4x/invisibli_white_alpha_bordered.png#gh-dark-mode-only)

- [**What is it?**](#what-is-it)
- [**Why use invisib.li?**](#why-use-invisibli)
- [**How hard is it to set up?**](#how-hard-is-it-to-set-up)
- [**How to use this guide**](#how-to-use-this-guide)


## **What is it?**  
invisib.li enables you to easily deploy your own virtual private network solution (VPN) solution at home and on the go. It works with all of your devices, and, optionally provides you an extremely advanced home router which will automatically bring all devices on your home network onto this VPN without any custom software on them. This will enhance your security, privacy, enable you to access any device from anywhere, and even block ads for you both making your experience on the web less annoying and faster.


This guide has three main parts:
  - Spinning up your own cloud server in AWS's EC2, setting up an ad-blocking DNS server (pihole), configuring your mobile phone to use this VPN even when on the go, and creating an VPN tunnel between your router and that instance.
  - Building your own powerful home router using an Intel NUC (or whatever hardware you decide to use.)
  - Setting up an easy single access point using your phone 

If you only want to set up a subset of this guide, such as not building your own router and simpmly installing software on your devices individually, feel free to do that as well.


## **Why use invisib.li?**  

invisib.li has some key uses when you use both the cloud instance and the home router:

- All of your internet data will be send via an encrypted tunnel connection to a server YOU and ONLY YOU control.
- Your home and mobile internet service providers likely snoop on every DNS request (basically the phonebook of the internet) that you make, then sells that data to data brokers. This stops that. 
- You can block trackers embedded into websites which follow your browsing habits and then sell your data. 
- You can block ads from ever being delivered to your devices, speeding up your browsing and improving browser performance.
- You can access files and deviecs on your home network even when on the go. Want to lower your WiFi connected blinds from your phone while at work? Go for it. Want to download a file hosted on your NAS while on a business trip? Yes we can. You can even cast a video to your streaming device on your television when not on WiFi!
- You can tunnel your traffic to servers all over the world. Live in a country where the government doesn't like free speech and / or blocks certain websites? Now you can access them. Want to watch streaming video on services that aren't available in your home country? Watch away my friend. Simply place your cloud server in an AWS region of your choice. 
- Unlike many other solutions, invisib.li seamlessly provides these services to ALL of the devices on your home network without having to install software on them. This saves you time, protects your guests in your home, and allows you to protect devices that may not have the ability to install VPN client software on them.
- You will build up with a home router / WiFi solution that is WAY better than what you picked up at Best Buy. 
- You can protect youself on the go on your mobile device, 
- You will save bandwidth both on your mobile device as well as at home.

## **How hard is it to set up?**  

If you are able to use a terminal on a Linux or MacOS computer, you can follow this guide. In the future I will add Windows as well. 

Remember, you ARE on GitHub right now, this isn't exactly the iOS app store :). 

[comment]: <> (Insert system Architecture diagram with labels...)

## **What's the Goal?**  

Once completed, this should allow all the devices in your home, (such as your laptops, video streaming devices, even your pet cube or wifi connected whatever) to tunnel your traffic securely to and through a server in the cloud that you control. All of this traffic is encrypted, thus your ISP, coffee shop, university, can only see that there IS traffic going to and from this one service, they can't understand it or read it. Can AWS see the IP addresses of where your requests are going from the EC2 instance in their network? Yes. But now you only have one actor to think of in your threat model now.

## **What's a PiHole?**  

PiHoles are essentially a DNS filter (more commanly known as a DNS Sinkhole). You provide it domains to block, and it will give non-usable addresses when it recieves requests for those domains. If a request is made and it isn't on it's list of domains to block, it will pass the traffic onto an upstream DNS server of your choice.  
When setting up the pihole, it will come with a pre-made list of ad-domains to block. There are numerous lists out there, and collections of lists, such as https://firebog.net. You have ultimate control over these lists and what information your PiHole keeps or doesn't.  

[More information on how to use the PiHole from the creators of it.](https://docs.pi-hole.net/)

## **What's the downside?**  

Because using a VPN means adding to network overhead, you may have a slower connection. In my time using this setup, I rarely have any noticable delays.  
Some websites may block YOU, because they block connections from AWS in an effort to keep out potential threats from people using AWS for nefarious purposes.

### **[More questions?](FAQ.md)**

## **How to use this guide**  
There are two paths to using this guide:

Hybrid automagic/manual setup[(Steps here)](hybrid_setup.md):
- Running the ['autolaunch.sh'](autolaunch.sh) script that makes and configures the EC2 instance, then launches the ['script.sh'](script.sh) and configures the server for ad-blocking/sets up VPN server
- [Setting up home router](OPNsense_guide.md)

Manually setting up each part[(Steps here)](Manual_setup_Guide.md):  
- [Making the EC2 instance and configuring the server](EC2_Manual_Setup.md)  
- [Setting up home router](OPNsense_guide.md)  

>Fully automagic setup coming soon!

Bonus!:  
- [Setting up a wifi access point](Unifi_AP.md) (useful in small apartments/studios)

## **Hard requirements/recommendations for home router/access point (If you chose to deploy them)**

### **Hardware used in the guide:**
* [Intel Xeon NUC 9 Quartz Canyon](https://www.amazon.com/Intel-Nuc-Kit-Nuc9Vxqnx-Cord/dp/B086LFB22V)
* [Ubiquiti Unifi U6 Lite WiFi access point](https://www.amazon.com/Ubiquiti-Access-Adapter-Included-U6-Lite-US/dp/B08QG92M83/)
* [Ubiquiti POE switch](https://www.amazon.com/Ubiquiti-16-Port-Gigabit-802-3at-USW-Lite-16-PoE/dp/B08KC1YQZ9/)  
* [Samsung USB A+C flash drive](https://www.amazon.com/dp/B07DW2Q1JL)

> You can replace the Nuc with almost any machine that has a two port network interface card.

## **Software requirments**

**AWS Cloud Account required:**

If you don't have one, [create a free Amazon Web Services (AWS)](https://aws.amazon.com/free) account.
If you plan on following the automatic guide, you will need your [AWS accesskeys.](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)

**Pre-Download (if following the router guide):**  

* [OPNSense-VGA-AMD64 network appliance OS ](https://mirror.sfo12.us.leaseweb.net/opnsense/releases/22.1/OPNsense-22.1-OpenSSL-vga-amd64.img.bz2) 
* [Balena Etcher USB stick burning software](https://www.balena.io/etcher/)  

### **Why do I need hardware at home?**

Technically you can skip it if you just want to configure VPN clients on just a few devices that you'll want to use with this. However, that's a lot more work than just having everything on your home network protected automagically. It's also a super fast and awesome router.  

### **Can I use different hardware for the router / access point / cloud provider / VPN / skip the router / skip the cloud server, etc?**  

Yes, all these are possible, but I can't support every possible configuration and still make this simple. This is a known good configuration that is fairly turn key and I've documented it end to end. You can absolutely modify this, and the information in this guide will save you a ton of time, but your millage may vary. 

## **Can I contribute?**

Yes please! I am always moving towards making this as lightweight, widely usable, and easy to use as possible. I am happy to look at any pull requests. :)
