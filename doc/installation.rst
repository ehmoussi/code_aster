##################################
Building and installing code_aster
##################################


*******************
Getting the sources
*******************

The code_aster sources are under `Mercurial <https://www.mercurial-scm.org/>`_
version control system.
Use this command to check out the latest project source code::

    $ mkdir -p $HOME/dev/codeaster
    $ cd $HOME/dev/codeaster
    $ hg clone https://bitbucket.org/code_aster/codeaster-src src

In this manual, we assume that the working directory corresponds to the code_aster
source folder (``cd $HOME/dev/codeaster/src``).


*********************
Required dependencies
*********************

- Python 3.5 or later with development files (under Debian python-dev).

- For the other third party prerequisites for the development version,
  please read the `Prerequisites page on the wiki
  <https://bitbucket.org/code_aster/codeaster-src/wiki/Prerequisites>`_.


**********************************
Building and installing code_aster
**********************************

The building and installation instructions can be found on
`Building code_aster page on the wiki
<https://bitbucket.org/code_aster/codeaster-src/wiki/BuildCodeAster>`_.
