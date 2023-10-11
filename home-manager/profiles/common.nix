{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {

  options.link.options = {
    type = mkOption {
      type = types.enum [ "desktop" "laptop" "server" ];
      default = system-config.link.options.type;
      example = "server";
    };
  };
  imports = with flake-self.homeManagerModules; [ git zsh neovim ];
  config = {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs;
      [
        bottom
        fastfetch
        gdb
        lldb
        tldr
        tree
        unzip
        (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      ] ++ lib.optionals
      (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];

    programs = {
      nix-index = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    # Services to start on all systems
    services = { };

    # Home-manager nixpkgs config
    nixpkgs = {
      # Allow "unfree" licenced packages
      config = { allowUnfree = true; };
      overlays = [
        # our packages
        flake-self.overlays.default
        flake-self.inputs.nur.overlay
      ];
    };

    # Include man-pages
    manual.manpages.enable = true;

    home = {
      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "23.11";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

  };

}