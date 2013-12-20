maintainer "PK4 Media, Inc."
description "Configure Wordpress"
version "0.1"
recipe "wordpress::configure", "Configure wordpress settings"
recipe "wordpress::deploy", "Deploy wordpress"

depends "deploy"