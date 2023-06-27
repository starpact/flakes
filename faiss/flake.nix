{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      llvmPackages = pkgs.llvmPackages_16;
      stdenv = llvmPackages.stdenv;
    in
    {
      devShells.default = pkgs.mkShell.override { inherit stdenv; } {
        buildInputs = with pkgs; [
          blas
          cmake
          lld_16
          llvmPackages.lldb
          llvmPackages.openmp
        ];

        nativeBuildInputs = with pkgs; [ clang-tools_16 ]; # for wrapped clangd

        LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
      };
    }
  );
}
