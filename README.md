# s3-secure-staticweb


   $ git clone https://github.com/Aswathir26/s3-secure-staticweb.git
   
   
note: start with provider.tf, variable.tf, terraform.tfvars, s3.tf, mime.json(optional) 

commands to follow:
 
    $ terraform init
    $ terraform plan 
    $ terraform apply
    
Bucket to host website and bucket for redirecting are ready now!

Next we have to Upload files manually.
We can upload files using terraform code. For that We have to specify the types of files(website files) in mime.json file. But it is complicated if we have to upload more files. Finding the type of each file is not easy(if there are lots of files). 

### SSL Certificate

Download ssl certificate by using certbot command. Then import it to aws certificte manager. 

## **Secure Site with HTTPS**

**1. Get SSL Certificate through Let's encrypt**
 
install certbot

    $ sudo apt install certbot
    
Get certificate

    $ certbot certonly --agree-tos --email <mail id> --manual --preferred-challenges=dns -d <domain name> --server https://acme-v02.api.letsencrypt.org/directory --manual 

Note: For Redirector add -d www.abc.s3.com with -d abc.s3.com

It tell to deploy a DNS TXT record in our dns zone.

So create a TXT type record set with given name in te.nestdigital.com DNZ zone and enter the given value in alias column.

then press enter to continue.

It will save certification, chain and key.

Now go to AWS portal and select certificate manager. Then import the saved certificate, chain and key.

note: copy the arn of certificate from aws certificate manager.

note: add cloudfront.tf, output.tf

cloudfrond service is used to get secure connection of website.

commands to follow:

    $ terraform plan
    $ terraform apply

Now we can see the domain names as output!!!

 Search them in any browser.

