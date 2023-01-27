{
  programs = {
    git = {
      enable = true;
      userName = "khaneliman";
      userEmail = "khaneliman12@gmail.com";
      signing = {
        key = "";
        signByDefault = true;
      };
      extraConfig = {
        url = {
          "ssh://git@github.com:khaneliman" = {
            insteadOf = "https://github.com/khaneliman/";
          };
        };
      };
    };
  };
}
