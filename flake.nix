{
  description = "Home Manager configuration of krispian";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # mac-app-util.url = "github:hraban/mac-app-util";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    # mac-app-util,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."krispian" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inputs = inputs;
      };

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
        sops-nix.homeManagerModules.sops
        # mac-app-util.homeManagerModules.default
      ];
      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
