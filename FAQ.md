## F.A.Q.

### **Why don't I just use my work VPN?**  

If you're asking this, your skill level is *not* the right level for this project.

### **What about my router?**  

Most widely used routers are a combonation of a router, switch, wireless access point, and often modem. While these are often easy to set up and forget about, they often dont have a lot of control or ability to customize.  
The second part of this guide goes through setting up a computer with a basic [OPNsense](https://opnsense.org/) configuration. OPNsense is easy to use and configure if you have a basic knowledge of networking. It is highly configurable, and for someone who is looking to upgrade their network, often a good choice to do so with.

### **Why don't I use *X* VPN that *X* youtuber says is the fastest/best?**  

Content creators have every incentive to say whatever the company who is sponsoring them wants to say. They may have some limited use as far as convienance, and using them to access servces in other countries. But YOU ultimatly have to spend the time researching them to see what their policies are for data retention, cooperation with local and foreign goverments, and any other number of factors. Or....you could use your own that you have almost complete control over. 


### **For some examples of commanly advertised VPN's and potential issues:** 

Private Internet Access/CyberGhost/ExpressVPN/Zenmate:  

All owned and aquired by Kape Technologies, formerly known as Crossrider which was known to *be used* widely for ad injectors and malware distrubution (this platform was shutdown in 2016). Kape also has bought multiple VPN review sites (such as VPNMentor and Wizcase) which puts them in a direct conflict of interest for any information supplied.
[Learn more!](https://restoreprivacy.com/kape-technologies-owns-expressvpn-cyberghost-pia-zenmate-vpn-review-sites/)


Protonmail:  

Per [their own transparancy report](https://protonmail.com/blog/transparency-report/) they are forced to comply to requests from the Swiss goverment (as they are based in Switzerland) and did so for 3,017 requests in 2020 and contested 750 requests. Additionally, in 2018 they assisted Swiss law enforcement *before* recieving a court order (they were expecting a court order and shortly did recieve one after already assisting law enforcement).

Ultimately you should do your own research and decide who you want to trust with your traffic and information. There are lesser and greater risks posed by using different companies. How long and what kind of logs may be retained, where the country is located, how they make money, who they are owned/have been owned by are good starting points when making your decision on who to trust with your data.

>Sidenote: The main reason that the location of a VPN is important, is because of potential laws regarding log keeping and forced compliance with law enforcement. It's also worth knowing if a VPN is in a [Five Eyes](https://en.wikipedia.org/wiki/Five_Eyes) country.


### **What about *X* free VPN?**
  
While there may be some that aren't malicious, you need to keep in mind the incentive structure for the VPN providers. Buisnesses cost money to run, and if you are not providing the money to run the service you are using, YOU are likely making them money. They are likely making money injecting advertisments, or selling your browsing data. This is widely known and published, and some will even be [open about it](https://www.betternet.co/how-we-make-money/).  

### **Well then why would you make a guide using AWS?**  
  
This guide was written to be as simple, easy, and convenient as possible. It's a simple way to help with ad-blocking on the go, and at home. This focuses on *privacy* more then *security*.  It is not written with the intention to protect you from dedicated nation state actors, or highly motivated law enforcement agencies.  
If you think you're doing things that would have nation states hitting up Jeff Bezos to creep on your traffic, this guide is not going to protect you. You're already **really** *fucked.*
It does give you more control over how your data is used! Don't want logs of your stuff? Don't keep logs! You have the power!

*Seriously though, Daddy Bezos/Amazon have ultimate control of AWS. The basic principal/structure presented in this guide can be made with any number of VPS providers*

### **Why is the download for X utility/image out of date?**

The project will contain the most up to date links to imagess and utilites as possible, but only after they have been tested. 

### **Wireguard vs OpenVPN** 

Wireguard is a newer, often higher performance, which reduces the penalty of using a VPN. It is also regarded by some as more secure. OpenVPN has been around longer and is proven, but is often a little slower and more of a drain on resources. There are pros and cons for using either and it often falls to personal choice. This guide uses Wireguard, as one of my primary goals was to impact speed as little as possible and Wireguard tends to be faster then OpenVPN. If you have an opinion about using OpenVPN instead, you know enough to add it yourself (neeeerdddd)!
