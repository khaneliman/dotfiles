{
  pkgs,
  lib,
  gitHostCommitUrl ? "https://github.com/khaneliman/dotfiles/commit",
  ...
}:
pkgs.writeShellScriptBin "nixos-revision" ''
  HAS_HELP=false
  HAS_OPEN=false

  while [[ $# -gt 0 ]]; do
  	case $1 in
  		-h|--help)
  			HAS_HELP=true
  			shift
  			;;
  		-o|--open)
  			HAS_OPEN=true
  			shift
  			;;
  		*)
  			shift
  			;;
  	esac
  done

  if [ $HAS_HELP == true ]; then
  	HELP_MSG="
  nixos-revision

  USAGE

    nixos-revision [options]

  OPTIONS

    -h, --help              Show this help message
    -o, --open              Open the revision on GitHub

  EXAMPLES

    $ # Print the current revision
    $ nixos-revision

    $ # Open the current revision on GitHub
    $ nixos-revision --open
  "
  	echo "$HELP_MSG"
    exit 0
  fi

  REVISION=$(nixos-version --json | ${pkgs.jq}/bin/jq -r .configurationRevision)

  if [ $HAS_OPEN == true ]; then
    GITHUB_URL="${gitHostCommitUrl}/$REVISION"
    echo "Opening URL: $GITHUB_URL"
    ${pkgs.xdg-utils}/bin/xdg-open $GITHUB_URL
  else
    echo $REVISION
  fi
''
