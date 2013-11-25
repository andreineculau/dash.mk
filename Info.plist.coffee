#!/usr/bin/env coffee

console.log """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleIdentifier</key>
	<string>#{process.env.DOCSET_ID}</string>
	<key>CFBundleName</key>
	<string>#{process.env.DOCSET_NAME}</string>
	<key>DocSetPlatformFamily</key>
	<string>#{process.env.DOCSET_ID}</string>
	<key>isDashDocset</key>
	<true/>
</dict>
</plist>
"""
