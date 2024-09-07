{
  description = "A template for Nix based C++ project setup.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # utils.url = "github:numtide/flake-utils";
    # utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell.override
          {
            # Override stdenv in order to change compiler:
            stdenv = pkgs.clangStdenv;
          }
          {
            packages = with pkgs; [
              clang-tools
              cmake
              codespell
              conan
              cppcheck
              doxygen
              gtest
              lcov
              vcpkg
              vcpkg-tool
            ] ++ (if system == "aarch64-darwin" then [ ] else [ gdb ]);
          };
      });
    };
}

