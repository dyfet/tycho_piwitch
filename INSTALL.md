Getting Started
===============

I use ansible to install PiWitch onto a dedicated remote server.  This is used
to configure and install SipWitchQt, a dedicated MariaDB server, and lighttpd
to support our python based flask web applets.  While I call this package
PiWitch, in fact it can be used to create and update any stand-alone dedicated
SipWitchQt server runnning either Debian or Ubuntu, on X86, and AMD64, as well
as Arm.  A minimal system/headless ssh accessible server install of Debian
Stretch or Ubuntu 18.04, or, in the case of the Raspberry Pi, a "Raspbian
lite" base install, is all that is required to start from.

On raspbian we have well known account 'pi', which typically can sudo to root.
If using Debian or Ubuntu you will need to create or have a ssh user that can
sudo to root, or you can use the root account itself if it is ssh enabled. In
all cases you would simply copy inventory/examples.ini to inventory/hosts.ini.
The example.ini has settings that would match a pi out of the box.  You can
then modify hosts.ini ansible settings for the target server(s) you wish to
install and maintain with PiSwitch as needed.  

Ansible may require sshpass to use the default raspberry pi configuration
or any system that has a ssh account which requires a password.  This package
is generally considered insecure.  I suggest instead installing an authorized
key into the ssh user on the target server you with to use for installation.

Database support works in part because mariadb sets unix socket authentication
without password by default, and this assumption is required at least for
root@localhost for database roles to run.  In piwitch SipWitchQt is also
configured around this behavior.  In the future we may add support for db
access thru an explicit account and password to better secure the endpoint.
Otherwise I suggest limiting ssh account access to the managed device.  The
assumption is if someone can already get on the box, and become root, there
really is little added value in further locking down mariadb locally anyway.

Once your inventory/hosts.ini file is set, simply run ./install.yml to run the
installation playbook.  You can pull updated piwitch releases from git and use
./install.yml to update your installation as well.  Alternately you can copy
piwitch to your server and run the installer directly running the install
playbook with sudo for local.

