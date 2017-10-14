{ rev ? "beb1f1ea91ef15d5f1b272108b0cf964e47665f2"
, sha256 ? "02n73jmc0vbb2dq5af70zxms63jbgbnzc70fmw50mcq07fpwa3p9"
, pkgs ? import ((import <nixpkgs> {}).pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    inherit rev;
    inherit sha256;
  }) {}
}:

with pkgs;

stdenv.mkDerivation rec {
  name = "env";
  src = ./.;
  env = buildEnv { name = name; paths = buildInputs; };
  builder = builtins.toFile "builder.pl" ''
    source $stdenv/setup; ln -s $env $out
  '';
  buildInputs = [
    (texlive.combine {
      inherit (texlive)
        scheme-basic
        beamer
        cm-super
        contour
        dejavu
        ec
        enumitem
        epstopdf
        etoolbox
        fancyvrb
        float
        framed
        graphics
        hyperref
        ifplatform
        latex
        latexmk
        lineno
        lm
        microtype
        minted
        ms
        pgf
        preview
        upquote
        xstring;
    })
    curl
    ghostscript
    gnumake
    pythonPackages.pygments
    which
  ];
}
