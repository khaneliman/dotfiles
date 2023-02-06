#!/usr/bin/env bash

mac_change_symbolickeys() {

	message "Removing default mission control hostkeys"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 118 "
  <dict>
    <key>enabled</key><false/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>18</integer>
        <integer>262144</integer>
      </array>
    </dict>
  </dict>
"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 119 "
  <dict>
    <key>enabled</key><false/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>19</integer>
        <integer>262144</integer>
      </array>
    </dict>
  </dict>
"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 120 "
  <dict>
    <key>enabled</key><false/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>20</integer>
        <integer>262144</integer>
      </array>
    </dict>
  </dict>
"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 121 "
  <dict>
    <key>enabled</key><false/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>21</integer>
        <integer>262144</integer>
      </array>
    </dict>
  </dict>
"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 122 "
  <dict>
    <key>enabled</key><false/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>23</integer>
        <integer>262144</integer>
      </array>
    </dict>
  </dict>
"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 123 "
  <dict>
    <key>enabled</key><false/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>22</integer>
        <integer>262144</integer>
      </array>
    </dict>
  </dict>
"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 124 "
  <dict>
    <key>enabled</key><false/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>26</integer>
        <integer>262144</integer>
      </array>
    </dict>
  </dict>
"
	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 79 "
  <dict>
    <key>enabled</key><false/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>123</integer>
        <integer>8650752</integer>
      </array>
    </dict>
  </dict>
"
	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 81 "
  <dict>
    <key>enabled</key><false/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>124</integer>
        <integer>8650752</integer>
      </array>
    </dict>
  </dict>
"
	warning_message "Disabled macOS mission control shortcuts. SKHD handles yabai spaces."

	message "Reloading plist changes..."
	/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
	success_message "Successfully reloaded settings"
}
