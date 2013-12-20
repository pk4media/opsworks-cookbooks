maintainer "PK4 Media, Inc."
description "Configure Wordpress"
version "0.1"
recipe "wordpress::configure"
recipe "wordpress::deploy"

depends "deploy"