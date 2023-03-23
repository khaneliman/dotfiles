{ channels, ... }:

final: prev: {
  khaneliman = (prev.khaneliman or { }) // {
    pocketcasts = prev.makeDesktopItem {
      name = "Pocketcasts";
      desktopName = "Pocketcasts";
      genericName = "It’s smart listening, made simple.";
      exec = ''
        ${final.firefox}/bin/firefox "https://play.pocketcasts.com/podcasts?khaneliman.app=true"'';
      icon = ./icon.svg;
      type = "Application";
      categories = [ "Network" "Feed" "AudioVideo" "Audio" "Player" ];
      terminal = false;
    };
  };
}
