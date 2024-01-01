{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      llvmPackages = pkgs.llvmPackages_17;
      stdenv = llvmPackages.stdenv;
    in
    {
      devShells.default = pkgs.mkShell.override { inherit stdenv; } {
        buildInputs = with pkgs; [
          lapack
          sccache
          thrift
        ];

        LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
        RUST_BACKTRACE = 1;
      };
    }
  );
}
