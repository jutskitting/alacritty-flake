{
  description = "A flake for alacritty";

  inputs = {

    nixpkgs = {
	    url = "github:NixOS/nixpkgs/nixos-unstable";
    };

  };


  outputs = { self, nixpkgs, }:
  let 
    system = "x86_64-linux";

    pkgs = import nixpkgs {
        inherit system;
      };

    packages.${system}.alacritty = nixpkgs.legacyPackages.${system}.alacritty;

    alacritty-custom = pkgs.alacritty.overrideAttrs (oldAttrs: {
      postPatch = oldAttrs.postPatch + ''
        echo "Listing the contents of the source directory:"
        ls -laR
         
        install -D ${./alacritty/src/config/color.rs} ./alacritty/src/config/color.rs
      '';
    });

  in {
    inherit system;
    inherit alacritty-custom;

    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
      buildInputs = [
            alacritty-custom
      ];
    };

    packages.${system}.default = alacritty-custom;

  };
}


