# Multiple Recipes created to aid in the construction of Hortonwork Data Platform
============

## [Ambari Recipe](ambari}
Add Ambari and the necessary repo's to install HDP.  Supports Local-Repositories.  Specifically tested against the local repo create with [HDP-Repo](hdp-repo)

## [HDP-Prep Recipe](hdp-prep)
Prepare an OS for an HDP installation.  This recipe will do things like distribute a password-less ssh-key, disable selinux, turn-off iptables, install local repos (if desired), install jdk, and install ntp.

## [HDP-Repo Recipe](hdp-repo)
Build a Local Repo that can be referenced from your cluster for installation on a closed network, or just to help reduce the amount of traffic you request from the web.

## [Host Entry Recipe](host-entry)
Add a few specified entry(ies) to the /etc/hosts file.  This is helpful for added the above repo to your host during the build so they're resolvable.