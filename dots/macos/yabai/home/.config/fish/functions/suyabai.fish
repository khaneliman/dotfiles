function suyabai
  set SHA256 $(shasum -a 256 /opt/homebrew/bin/yabai | awk "{print \$1;}")
  if [ -f "/private/etc/sudoers.d/yabai" ];
    sudo sed -i '' -e 's/sha256:[[:alnum:]]*/sha256:'{$SHA256}'/' /private/etc/sudoers.d/yabai
  else
    echo "sudoers file does not exist yet"
  end
end
