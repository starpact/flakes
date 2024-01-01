{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      llvmPackages = pkgs.llvmPackages_17;
    in
    {
      devShells.default = pkgs.mkShell.override { stdenv = pkgs.clang16Stdenv; } {
        buildInputs = with pkgs; [
          ccache
          cmake
          gawk
          lld_17
          llvmPackages.lldb
          nasm
          ninja
          yasm
        ];

        nativeBuildInputs = with pkgs; [ clang-tools_17 ]; # for wrapped clangd

        LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
      };
    }
  );
}
