
### **Configuring your clients**

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


