# This file set the environment for code_aster.
# Configuration for Scibian 9 MPI

# keep path to this file
export WAFBUILD_ENV=$(readlink -n -f ${BASH_SOURCE})

# DEVTOOLS_COMPUTER_ID avoids waf to re-source the environment
export DEVTOOLS_COMPUTER_ID=scibian9
# expected version of official prerequisites
export OFFICIAL_PLATFORM=1
export PREREQ_PATH=${HOME}/dev/codeaster-prerequisites/v15
export PREREQ_VERSION=20200129

# force parallel build
export ENABLE_MPI=1

# generic environment: compilers, python
. /etc/profile.d/lmod.sh
module load python/3.6.5 numpy/1.15.1 python3-scipy/0.19.1 python3-matplotlib/2.2.2 python3-sphinx/1.7.6 boost/1.58.0 hdf5/1.10.3

# do not report 'literal-suffix' warnings from openmpi headers
export CXXFLAGS="-Wno-literal-suffix"

# custom configuration
export CONFIG_PARAMETERS_tmpdir="/local00/tmp"
export CONFIG_PARAMETERS_addmem=1900

# prerequisites paths
export PYPATH_NUMPY="/opt/numpy/1.15.1/lib/python3.6/site-packages"
export PYPATH_ASRUN="${PREREQ_PATH}/tools/Code_aster_frontend-salomemeca/lib/python3.6/site-packages"

export LIBPATH_HDF5="/opt/hdf5/1.10.3/lib"
export INCLUDES_HDF5="/opt/hdf5/1.10.3/include"

export LIBPATH_MED="${PREREQ_PATH}/prerequisites/Medfichier-400/lib"
export INCLUDES_MED="${PREREQ_PATH}/prerequisites/Medfichier-400/include"

export LIBPATH_METIS="${PREREQ_PATH}/prerequisites/Metis_aster-510_aster4/lib"
export INCLUDES_METIS="${PREREQ_PATH}/prerequisites/Metis_aster-510_aster4/include"

export LIBPATH_PARMETIS="${PREREQ_PATH}/prerequisites/Parmetis_aster-403_aster3/lib"
export INCLUDES_PARMETIS="${PREREQ_PATH}/prerequisites/Parmetis_aster-403_aster3/include"

export LIBPATH_SCOTCH="${PREREQ_PATH}/prerequisites/Scotch_aster-604_aster7/MPI/lib"
export INCLUDES_SCOTCH="${PREREQ_PATH}/prerequisites/Scotch_aster-604_aster7/MPI/include"

export LIBPATH_MUMPS="${PREREQ_PATH}/prerequisites/Mumps-521_consortium_aster/MPI/lib"
export INCLUDES_MUMPS="${PREREQ_PATH}/prerequisites/Mumps-521_consortium_aster/MPI/include"

export LIBPATH_PETSC="${PREREQ_PATH}/prerequisites/Petsc_mpi-3123_aster/lib"
export INCLUDES_PETSC="${PREREQ_PATH}/prerequisites/Petsc_mpi-3123_aster/include"

export TFELHOME="${PREREQ_PATH}/prerequisites/Mfront-TFEL321"
export TFELVERS="3.2.1"
export LIBPATH_MFRONT="${TFELHOME}/lib"
export INCLUDES_MFRONT="${TFELHOME}/include"
export PYPATH_MFRONT="${TFELHOME}/lib/python3.6/site-packages"

export INCLUDES_BOOST="/opt/boost/1.58.0/include"
export LIBPATH_BOOST="/opt/boost/1.58.0/lib"
export LIB_BOOST="boost_python3-mt"


export LD_LIBRARY_PATH=${LIBPATH_HDF5}:${LIBPATH_MED}:${LIBPATH_METIS}:${LIBPATH_SCOTCH}:${LIBPATH_MUMPS}:${LIBPATH_MFRONT}:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${LIBPATH_PARMETIS}:${LIBPATH_PETSC}:${LD_LIBRARY_PATH}

export PYTHONPATH=${PYPATH_NUMPY}:${PYPATH_ASRUN}:${PYPATH_MFRONT}:${PYTHONPATH}

export PATH=\
${PREREQ_PATH}/prerequisites/Medfichier-400/bin:\
${PREREQ_PATH}/prerequisites/Gmsh_bin-2120Linux64/bin:\
${PREREQ_PATH}/tools/Miss3d-67_aster2:\
${PREREQ_PATH}/tools/Homard_aster-1112_aster2:\
${PREREQ_PATH}/tools/Ecrevisse-322:\
${TFELHOME}/bin:\
${PATH}
