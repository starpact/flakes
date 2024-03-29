{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      llvmPackages = pkgs.llvmPackages_17;
      stdenv = llvmPackages.stdenv;
    in
    {
      devShells.default = pkgs.mkShell.override { inherit stdenv; } {
        buildInputs = with pkgs; [
          lld_17
          openssl
          pkg-config
        ];

        LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
        RUST_BACKTRACE = 1;
      };
    }
  );
}
