name              "couchbase"
maintainer        "PK4 Media, Inc."
maintainer_email  "engineering@pk4media.com"
license           "Apache 2.0"
description       "Installs the couchbase client library"
version           "0.1"

recipe 'couchbase', 'Default recipe, installs the libcouchbase client'
recipe 'couchbase::client', 'Install the libcouchbase client'

depends 'yum'