{
  pkgs ? import <nixpkgs> { }
}:
let
  app = pkgs.poetry2nix.mkPoetryEnv {
    projectDir = ./.;
    overrides = pkgs.poetry2nix.overrides.withDefaults (self: super: {
        yaramod = super.yaramod.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
                self.setuptools
                pkgs.cmake
            ];
            preBuild = ''
                rm CMakeCache.txt
                cp ../LICENSE .
                cp ../setup.py .
                cp ../setup.cfg .
                cp -rf ../src .
                cp -rf ../include .
                cp -rf ../deps .
                cp -rf ../cmake .
                cp ../README.md .
                cp ../CMakeLists.txt .
            '';
        });
    });
  };
in app.env