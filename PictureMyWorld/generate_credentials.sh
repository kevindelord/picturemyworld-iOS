#!/bin/sh

if [ -f ./credentials.plist ]; then
	exit 0
fi

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
	<key>local</key>
	<dict>
		<key>base_url</key>
		<string></string>
		<key>web_url</key>
		<string></string>
		<key>username</key>
		<string></string>
		<key>password</key>
		<string></string>
	</dict>
	<key>development</key>
	<dict>
		<key>base_url</key>
		<string></string>
		<key>web_url</key>
		<string></string>
		<key>username</key>
		<string></string>
		<key>password</key>
		<string></string>
	</dict>
	<key>staging</key>
	<dict>
		<key>base_url</key>
		<string></string>
		<key>web_url</key>
		<string></string>
		<key>username</key>
		<string></string>
		<key>password</key>
		<string></string>
	</dict>
	<key>production</key>
	<dict>
		<key>base_url</key>
		<string></string>
		<key>web_url</key>
		<string></string>
		<key>username</key>
		<string></string>
		<key>password</key>
		<string></string>
	</dict>
</dict>
</plist>
" > credentials.plist
