{ channels, ... }:

final: prev: {
  khaneliman = (prev.khaneliman or { }) // {
    yt-music = prev.makeDesktopItem {
      name = "YT Music";
      desktopName = "YT Music";
      genericName = "Music, from YouTube.";
      exec = ''
        ${final.firefox}/bin/firefox "https://music.youtube.com/?khaneliman.app=true"'';
      icon = ./icon.svg;
      type = "Application";
      categories = [ "AudioVideo" "Audio" "Player" ];
      terminal = false;
    };
  };
}
