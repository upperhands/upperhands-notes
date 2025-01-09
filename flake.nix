{
  description = "Flake to manage node builds";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        build_inputs = with pkgs; [
          nodejs_22
        ];
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = build_inputs;
        };
        packages = {
          default = pkgs.stdenv.mkDerivation {
		    name = "quartz";
			src = ./.;
			buildInputs = build_inputs;
			buildPhase = ''
			  runHook preInstall

			  npm install
			  npx quartz build

			  runHook postInstall
			'';
			installPhase = ''
			  runHook preInstall

			  cp -r node_modules $out/node_modules
			  cp package.json $out/package.json
			  cp -r public $out/public

			  runHook postInstall
			'';
		  };
        };
      }
    );
}
