{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    { self, nixpkgs, ... }:
    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
      {
        packages = forEachSupportedSystem (
          { pkgs }:
          {
            default = pkgs.stdenv.mkDerivation {
              name = "custom-css";
              src = ./.;
              nativeBuildInputs = with pkgs; [
                pkg-config
              ];
              buildInputs = with pkgs; [
                emacs-pgtk gtk3
              ];
              installPhase = ''
                mkdir -p $out/lib
                cp *.so $out/lib/
              '';
            };
          }
        );
      };
}
