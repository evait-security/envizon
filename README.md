# envizon - by evait security
## network visualization & vulnerability management/reporting

Version 3.0

Fancy shields: Coming Soon™

<img src="https://evait-security.github.io/envizon/envizon-wide-export-blue.svg" width="400px" />

This tool is designed, developed and supported by evait security. In order to give something back to the security community, we publish our internally used and developed, state of the art network visualization and vulnerability reporting tool, 'envizon'. We hope your feedback will help to improve and hone it even further.

## Use Case

We use envizon for our pentests in order to get an overview of a network and quickly identify the most promising targets. The version 3.0 introduce new features such as screenshotting web services, organizing vulnerabilities or generating reports with custom latex templates.

## Core Features:

+ **Scan** networks with predefined or custom nmap queries
+ **Order** clients with preconfigured or custom groups
+ **Search** through all attributes of clients and create complex linked queries
+ **Get** an overview of your targets during pentests with predefined security labels
+ **Screenshot** Visualize all http-like applications of your targets using chrome-headless (selenium) - VNC soon&trade;
+ **Save** and reuse your most used nmap scans
+ **Collaborate** with your team on the project in realtime
+ **Export** selected clients in a text file to connect other tools fast
+ **Manage** issue template and create vulnerabilities linked to hosts in the database
+ **Create** customer reports with latex templates with one click 

## How to start?!

To avoid compatibility and dependency issues, and to make it easy to set up, we use Docker. You can build your own images or use prebuilt ones from Docker Hub.

### Using Docker

Docker and Docker Compose are required.

#### Prebuilt Docker Images

Use the `docker-compose.yml` from the `docker/` directory and run it with `docker-compose up`.

The Docker image will be pulled from `evait/envizon`.

If you want to update the app image or pull it manually, you can do so with `docker pull evait/envizon`.

If you want to provide your own SSL-certificates and/or RAILS_SECRET, modify the `docker-compose.yml` according to your needs, otherwise both will be generated.

For the lazy ones

```zsh
wget https://raw.githubusercontent.com/evait-security/envizon/master/docker/docker-compose.yml
sudo docker-compose up
```

#### Running from local git checkout

```zsh
git clone https://github.com/evait-security/envizon
cd envizon/envizon_local
sudo docker-compose -f docker-compose_local.yml up
```

#### Development

_If, for whatever reason, you want to run the development environment in production, you should probably consider changing the secrets in `config/secrets.yml`, and maybe even manually activate SSL._

```zsh
git clone https://github.com/evait-security/envizon
cd envizon/envizon_dev
sudo docker-compose up
```

Running tests:
```
docker exec -it envizon_container_name_1 /bin/ash -c 'rails test'
```

## Usage

### Set a password

After starting the docker images go to: https://localhost:3000/ (or http://localhost:3000 if not using SSL)

You have to specify a password for your envizon instance. You can change it in the settings interface after logging in.

<img src="https://evait-security.github.io/envizon/screenshots/set-password.png">

### Scan interface

The scan interface is divided in two sections. On the left side you can run a new scan with preconfigured parameters or your own nmap fu. You also have the possibility to upload
previously created nmap scans (with the `-oX` parameter).

<img src="https://evait-security.github.io/envizon/screenshots/scan-1.png">

On the right side you will see your running and finished scans.

<img src="https://evait-security.github.io/envizon/screenshots/scan-2.png">

### Groups

The group interface is the heart of envizon. You can select, group, order, quick search, global search, move, copy, delete and view your clients. The left side represents the group list. If you click on a group you will get a detailed view in the center of the page with the group content. Each client in a group has a link. By clicking on the IP address you will get a more detailed view on the right side with all attributes, labels, ports and nmap output.

*Most of the buttons and links have tooltips.*

<img src="https://evait-security.github.io/envizon/screenshots/groups.png">

### Global Search

In this section you can search for nearly anything in the database and combine each search parameter with 'AND', 'OR' & 'NOT'.

Perform simple queries for hostname, IP, open ports, etc. or create combined queries like: `hostname contains 'win' AND mac address starts with '0E:5C' OR has port 21 and 22 open`.

<img src="https://evait-security.github.io/envizon/screenshots/search.png">

### Images

This page renders the images of all ports with visible/interactive content captured by starting a new scan on the images/scan-interface. Actually only web-services are converted into a PNG files using selenium and chrome-headless. The scan interface has two functions:
- Re-Scan (check which port can be captured and add only new images)
- Re-Scan with overwrite (delete all images from the database and take a screenshot from all possible ports) 

Using the left groups sidebar you can filter all images by group. Please note, that any on-change updates (e.g. someone deletes a group) are disabled on this page to avoid any disturbance on the manual image reviewing process.

<img src="https://evait-security.github.io/envizon/screenshots/images.png">

## FAQ

API ?!
+ Currently not. We will work on it. Maybe.

Which browsers are supported?
+ Latest Chrome / Chromium / Inox & Firefox / Waterfox / Librewolf.

Why rails?!
+ Wanted to learn ruby. It's cool.

Why so salty on github issue discussion?
+ This is a community project. We are a full time pentesting company and will not go into / care about every open issue that doesn't match our template or guidelines. If you get a rough answer or picture e.g. from a fully underwhelmed cat, you probably deserved it.


## What frameworks and tools were used?

+ Ruby on Rails
+ ruby-nmap (https://github.com/sophsec/ruby-nmap)
+ Materialize CSS (http://materializecss.com/)
+ Font Awesome Icons (https://fontawesome.com/)
+ Material Icons (https://material.io/icons/)
+ Many, many helpful gems

## Help?

Of course you can open an issue and describe the problem you are facing with. Our team will try to response soon&trade;.