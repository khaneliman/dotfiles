{channels, ...}: _final: _prev: {
  inherit (channels.unstable) wrapOBS obs-studio obs-studio-plugins;
}
