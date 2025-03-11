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
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    # Nixos config (referring to hostname 'jura')
    nixosConfigurations.jura = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import configuration.nix for old config
	./configuration.nix

	# home-manager module of nixos
	home-manager.nixosModules.home-manager 
	# This is a function
	{
 	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.backupFileExtension = "bak";

	  # user specific config
	  home-manager.users.wisp = import ./home.nix;
	}
      ];
    };
  };
}
