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

let self = rec {
  rise = python35Packages.buildPythonPackage rec {
    pname = "rise";
    version = "5.0.0";
    name = "${pname}-${version}";
    src = pkgs.fetchurl {
      url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
      sha256 = "8a24ef247fd349296fba9bba3bf334de4fb268e3dcdf4bfcb5639294315aeeba";
    };
    postPatch = ''
      sed -i "s|README.md'|README.md', encoding='utf-8'|" setup.py
    '';
    propagatedBuildInputs = with python35Packages; [
      notebook
      nbconvert
    ];
  };
  jupyter = (rise.overrideDerivation (old: {
    postInstall = with python35Packages; ''
      mkdir -p $out/bin
      ln -s ${jupyter_core}/bin/jupyter $out/bin
      wrapProgram $out/bin/jupyter \
        --prefix PYTHONPATH : "${notebook}/lib/python3.5/site-packages:$PYTHONPATH" \
        --prefix PATH : "${notebook}/bin:$PATH"
    '';
  }));
  python35_with_packages = python35.buildEnv.override {
    extraLibs = with python35Packages; [
      # Kernel
      ipykernel
      ipywidgets
      # Custom packages
      # ...
    ];
  };
  python35_kernel = stdenv.mkDerivation rec {
    name = "python35";
    buildInputs = [ python35_with_packages ];
    json = builtins.toJSON {
      argv = [ "${python35_with_packages}/bin/python3.5"
               "-m" "ipykernel" "-f" "{connection_file}" ];
      display_name = "Python 3.5";
      language = "python";
      env = { PYTHONPATH = ""; };
    };
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out
      cat > $out/kernel.json << EOF
      $json
      EOF
    '';
  };
  jupyter_nbconfig = stdenv.mkDerivation rec {
    name = "jupyter";
    json = builtins.toJSON {
      load_extensions = {
        "rise/main" = true;
      };
    };
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out
      cat > $out/notebook.json << EOF
      $json
      EOF
    '';
  };
  jupyter_config_dir = stdenv.mkDerivation {
    name = "jupyter";
    buildInputs = [
      python35_kernel
      rise
    ];
    builder = writeText "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out/etc/jupyter/nbextensions
      mkdir -p $out/etc/jupyter/kernels
      mkdir -p $out/etc/jupyter/migrated
      ln -s ${python35_kernel} $out/etc/jupyter/kernels/${python35_kernel.name}
      ln -s ${jupyter_nbconfig} $out/etc/jupyter/nbconfig
      ln -s ${rise}/lib/python3.5/site-packages/rise/static $out/etc/jupyter/nbextensions/rise
      cat > $out/etc/jupyter/jupyter_notebook_config.py << EOF
      import os
      import rise
      c.KernelSpecManager.whitelist = {
        '${python35_kernel.name}'
      }
      c.NotebookApp.ip = os.environ.get('JUPYTER_NOTEBOOK_IP', 'localhost')
      EOF
    '';
  };
};

in with self;

stdenv.mkDerivation rec {
  name = "jupyter";
  env = buildEnv { name = name; paths = buildInputs; };
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';
  buildInputs = [
    jupyter
    jupyter_config_dir
  ] ++ stdenv.lib.optionals stdenv.isLinux [ bash fontconfig tini ];
  shellHook = ''
    mkdir -p $PWD/.jupyter
    export JUPYTER_CONFIG_DIR=${jupyter_config_dir}/etc/jupyter
    export JUPYTER_PATH=${jupyter_config_dir}/etc/jupyter
    export JUPYTER_DATA_DIR=$PWD/.jupyter
    export JUPYTER_RUNTIME_DIR=$PWD/.jupyter
  '';
}
