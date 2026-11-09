{
  description = "suuzu chan flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
      };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { self, nixpkgs, home-manager, aagl, ... }@inputs: {
    nixosConfigurations.suuzu = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        {
        imports = [aagl.nixosModules.default];
        nix.settings = aagl.nixConfig;
        programs.anime-game-launcher.enable = true;
        programs.anime-games-launcher.enable = true;
        programs.honkers-railway-launcher.enable = false;
        programs.honkers-launcher.enable = false;
        programs.wavey-launcher.enable = false;
        programs.sleepy-launcher.enable = true;
        }
      ];
    };
    homeConfigurations.callie = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./home.nix ];
    };
  };
}
