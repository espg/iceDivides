{
  stable ? import (builtins.fetchTarball {
             url = "https://github.com/NixOS/nixpkgs/archive/21.05.tar.gz";
             # Hash obtained using `nix-prefetch-url --unpack <url>`
             sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";

           }) {}
}:

with stable;

stdenv.mkDerivation rec {
  name = "env" ;
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [ git hdf4 nodejs gcc wget libjpeg openjpeg awscli curl #stdenv
    (python38.buildEnv.override {
      ignoreCollisions = true;
      extraLibs = with python38Packages; [
	(dask.override { withExtraComplete = true; })
        numpy
	qtpy
	pyqt4
	pyqt5_with_qtwebkit
	jupyterlab
	ipywidgets
	llvmlite 
	widgetsnbextension
	pyside
        scipy
        flake8
        matplotlib
	pip
	tqdm
	intake
        scikitlearn
        h5py
        netcdf4
        pyproj
	future
	astropy
	numba
        xarray
	tabulate
	plotly
        notebook
        pandas
        wheel
        gdal
	six
	env
	notebook
	datashader
      ];
     })
    ];

  shellHook = ''
            alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' \pip"
            export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.8/site-packages:$PYTHONPATH"
	    export LD_LIBRARY_PATH=${lib.makeLibraryPath [stdenv.cc.cc]}
	    export AWS_REGION="us-west-2"
	    export AWS_WEB_IDENTITY_TOKEN_FILE=~/s3access.key
	    export AWS_DEFAULT_REGION="us-west-2"
	    export AWS_ROLE_ARN="arn:aws:iam::286354552638:role/eksctl-jmte-addon-iamserviceaccount-prod-s3-Role1-KABCYRSSWEQR"
	    export PREFIX_PATH="$(pwd)/_build/pip_packages"
            export JUPYTERLAB_DIR="$(pwd)/jupyterlab"
            pip install  ipyleaflet --prefix=$PREFIX_PATH
            pip install  ipyvuetify --prefix=$PREFIX_PATH
            jupyter nbextension install --py --symlink --user ipyleaflet
	    jupyter nbextension install --py --symlink --user ipyvuetify
            jupyter nbextension enable --py --user ipyleaflet
            jupyter nbextension enable --py --user ipyvuetify
            #jupyter labextension install @jupyter-widgets/jupyterlab-manager jupyter-leaflet --app-dir=$JUPYTERLAB_DIR
            unset SOURCE_DATE_EPOCH
  '';}
