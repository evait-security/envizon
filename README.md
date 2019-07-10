# envizon - the network visualization tool

## TOC

- [envizon - the network visualization tool](#envizon---the-network-visualization-tool)
  - [TOC](#TOC)
  - [Version 2.1](#Version-21)
  - [Use Case](#Use-Case)
  - [Core Features:](#Core-Features)
  - [How to start?!](#How-to-start)
    - [Using Docker](#Using-Docker)
      - [Prebuilt Docker Images](#Prebuilt-Docker-Images)
        - [Running from local git checkout](#Running-from-local-git-checkout)
          - [Development](#Development)
    - [Without Docker](#Without-Docker)
      - [Manually](#Manually)
      - [Development](#Development-1)
  - [Usage](#Usage)
    - [Set a password](#Set-a-password)
    - [Scan interface](#Scan-interface)
    - [Groups](#Groups)
    - [Global Search](#Global-Search)
    - [Images](#Images)
  - [FAQ](#FAQ)
  - [What frameworks and tools were used?](#What-frameworks-and-tools-were-used)
  - [Help?](#Help)

## Version 2.1

Fancy shields: Coming Soon™

<img src="https://evait-security.github.io/envizon/envizon-wide-export-blue.svg" width="400px" />

This tool is designed, developed and supported by evait security. In order to give something back to the security community, we publish our internally used and developed, state of the art network visualization and organization tool, 'envizon'. We hope your feedback will help to improve and hone it even further.

## Use Case

We use envizon for our pentests in order to get an overview of a network and quickly identify the most promising targets.

## Core Features:

+ **Scan** networks with predefined or custom nmap queries
+ **Order** clients with preconfigured or custom groups
+ **Search** through all attributes of clients and create complex linked queries
+ **Get** an overview of your targets during pentests with predefined security labels
+ **Save** and reuse your most used nmap scans
+ **Collaborate** with your team on the project in realtime
+ **Export** selected clients in a text file to connect other tools fast

## How to start?!

To avoid compatibility and dependency issues, and to make it easy to set up, we use Docker. You can build your own images or use prebuilt ones from Docker Hub.

### Using Docker

Docker and Docker Compose are required.

#### Prebuilt Docker Images

Use the `docker-compose.yml` from the `docker/` directory and run it with `docker-compose up`.

The Docker image will be pulled from `evait/envizon`.

If you want to update the image or pull it manually, you can do so with `docker pull evait/envizon`.

If you want to provide your own SSL-certificates and/or RAILS_SECRET, modify the `docker-compose.yml` according to your needs, otherwise both will be generated.

For the lazy ones

```zsh
wget https://raw.githubusercontent.com/evait-security/envizon/master/docker/docker-compose.yml
sudo docker-compose up
```

##### Running from local git checkout

```zsh
git clone https://github.com/evait-security/envizon
cd envizon/docker
sudo docker-compose -f docker-compose_local.yml up
```

###### Development

_If, for whatever reason, you want to run the development environment in production, you should probably consider changing the secrets in `config/secrets.yml`, and maybe even manually activate SSL._

```zsh
git clone https://github.com/evait-security/envizon
cd envizon/docker
sudo docker-compose -f docker-compose_development.yml up
```

Running tests:
```
docker exec -it envizon_container_name_1 /bin/ash -c 'rails test'
```

### Without Docker

#### Manually

Requires a PostgreSQL server.

Create a database `envizon` with a user `envizon`. Password and socket location can be modified in the `docker-compose.yml`. Your user needs SUPERUSER privileges; otherwise database import (and tests) won't work, because of foreign key constraints: use `ALTER USER user WITH SUPERUSER;`.

```zsh
git clone https://github.com/evait-security/envizon
cd envizon
bundle install --path vendor/bundle
```

You need to create a secret and SSL certificates:

```zsh
mkdir .ssl
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout .ssl/localhost.key -out .ssl/localhost.crt
# If you want to use certificates located elsewhere, provide their pathes with SSL_CERT_PATH and SSL_KEY_PATH
# Create a secret:
RAILS_ENV=production bundle exec rails secret
```

The secret needs to be provided as an environment variable (SECRET_KEY_BASE), or be put in `config/secrets.yml`.

Then, run it with:

```zsh
RAILS_ENV=production
export RAILS_ENV
SECRET_KEY_BASE=YOUR_SECRET
export SECRET_KEY_BASE
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails assets:precompile
RAILS_FORCE_SSL=true RAILS_SERVE_STATIC_FILES=true bundle exec rails s
```

Also you need to run selenium in a container on the same system

```
docker run --rm -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome
```

#### Development

Databases for development and testing are called `envizon_test` and `envizon_development`, with the same requirements as above. Different database names and credentials can be provided via environment variables or directly modified in `config/database.yml`

```zsh
git clone https://github.com/evait-security/envizon
cd envizon
bundle install --path vendor/bundle
RAILS_ENV=development
export RAILS_ENV
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails s
```

Also you need to run selenium in a container on the same system

```
docker run --rm -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome
```

To run the tests:

```
RAILS_ENV=test db:setup
bundle exec rails test
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