{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # we use effects for CI and documentation
    hercules-ci-effects.url = "github:zmrocze/hercules-ci-effects?ref=karol/push-cache-effect";
    
    attic = {
      url = "github:zhaofengli/attic";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs = inputs @ {flake-parts, hercules-ci-effects, ...}:
    flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      debug = true;
      imports = [
        hercules-ci-effects.push-cache-module
      ];
      push-cache-effect = {
        enable = true;

      };
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      perSystem = {system, pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.hci ];
        };
      };
    };
}
