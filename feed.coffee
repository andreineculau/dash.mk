#!/usr/bin/env coffee

if process.env.DOCSET_VERSION_PKG?
  version = require(process.cwd() + '/' + process.env.DOCSET_VERSION_PKG).version
else
  version = process.env.DOCSET_VERSION

console.log """
<entry>
  <version>#{version}</version>
  <url>#{process.env.DOCSET_ENTRY_URL}</url>
</entry>
"""
