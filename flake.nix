# In future port to: https://github.com/Misterio77/nix-starter-configs
{
  description = "Wisp's ice flake";

  inputs = {
    # Nix packages source, using offical stable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # 'follows' means home-manager uses the same packages as
      # the system to avoid problems with different packages
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: {
    # Nixos config (referring to hostname 'jura')
    nixosConfigurations.jura = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import configuration.nix for old config
        ./configuration.nix

        # home-manager module of nixos
        # In future if you want to use nix on other distros
        # migrate home-manager to a seperate module from nix
        # then you can build with nix on eg. artix
        home-manager.nixosModules.home-manager
        # This is a function
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";

          # user specific config
          home-manager.users.wisp = import ./home.nix;

          home-manager.extraSpecialArgs = {inherit inputs;};
        }
      ];
    };
  };
}
