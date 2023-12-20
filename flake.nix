{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # pr branch
    hercules-ci-effects.url = "github:zmrocze/hercules-ci-effects?ref=karol/push-cache-effect";
    
    # useful till attic lands in nixpkgs: https://github.com/NixOS/nixpkgs/pull/274481
    attic = {
      url = "github:zhaofengli/attic";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs = inputs @ {flake-parts, hercules-ci-effects, attic, nixpkgs, ...}:
  let
    hello = (import nixpkgs { system = "x86_64-linux"; }).hello;
    hello-darwin = (import nixpkgs { system = "x86_64-darwin"; }).hello;
  in
    flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      debug = true;
      imports = [
        hercules-ci-effects.push-cache-effect
        hercules-ci-effects.flakeModule
      ];
      flake = {

      };
      herculesCI.ciSystems = ["x86_64-linux" "x86_64-darwin"];
      push-cache-effect = {
        enable = true;
        attic-client-pkg = attic.packages.x86_64-linux.attic-client;
        caches = {
          mlabs-attic = {
            type = "attic";
            secretName = "attic-test-token";
            branches = null; # all branches
            packages = [hello];
          };
          mlabs-cachix = {
            type = "cachix";
            secretName = "cachix-test-token";
            branches = ["main" "master" "push-to-attic"];
            packages = [hello hello-darwin];
          };
        };
      };
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      perSystem = {system, pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = [ 
            pkgs.hci # test effect locally: https://docs.hercules-ci.com/hercules-ci-agent/hci/
            # pkgs.cachix
            # attic.packages.x86_64-linux.attic-client
          ];
        };
      };
    };
}
