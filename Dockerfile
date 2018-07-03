# Copyright (c) Deren Eaton.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/base-notebook
LABEL maintainer="Deren Eaton <de2356@columbia.edu>"

# install as root
USER root

# nano and ffmpeg for matplotlib and toyplot animations
RUN apt-get update && \
    apt-get install nano -y && \
    apt-get install -y --no-install-recommends ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install into (base) py3 environment
RUN conda install conda jupyterhub notebook ipykernel -q -y && \
    conda install -q -y \
        'conda-forge::blas=*=openblas' \
        'conda-forge::scikit-allel' \
        #'conda-forge::ipywidgets=7.2*' \
        #'conda-forge::ipyleaflet' \
        'eaton-lab::toytree' \
        'bioconda::raxml' \
        'bioconda::sra-tools' \
        'bioconda::entrez-direct' \
        'ipyparallel' \
        'matplotlib=2.2*' && \
    conda clean -tipsy && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# install py2 environment
RUN conda create -n py27 python=2 notebook ipykernel -y && \
    $CONDA_DIR/envs/py27/bin/ipython kernel install \
        --name 'py27' \
        --display-name 'Python 2' && \
    conda install -n py27 -q -y \
        'conda-forge::blas=*=openblas' \
        'conda-forge::scikit-allel' \
        # 'conda-forge::ipywidgets=7.2*' \
        # 'conda-forge::ipyleaflet' \
        'ipyrad::ipyrad' \
        'ipyrad::bpp' \
        'ipyrad::bucky' \
        'ipyrad::structure' \
        'ipyrad::clumpp' \
        'BioBuilds::mrbayes' \
        'bioconda::raxml' \
        'bioconda::sra-tools' \
        'bioconda::entrez-direct' \
        'eaton-lab::toytree' \
        'matplotlib=2.2*' && \
    conda clean -tipsy && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Import matplotlib the first time to build the font cache.
USER $NB_UID
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg $CONDA_DIR/bin/python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

USER $NB_UID