# This file set the environment for code_aster.
# Configuration for Eole STD

# keep path to this file
export WAFBUILD_ENV=$(readlink -n -f ${BASH_SOURCE})

# DEVTOOLS_COMPUTER_ID avoids waf to re-source the environment
export DEVTOOLS_COMPUTER_ID=eole
# expected version of official prerequisites
export OFFICIAL_PLATFORM=1
export PREREQ_PATH=/projets/simumeca/public/v15
export PREREQ_VERSION=20191105

# generic environment: compilers, python
. /etc/profile.d/lmod.sh
module load ifort/2016.0.047 icc/2016.0.047 mkl/2016.0.047

export LD_PRELOAD=/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/mkl/lib/intel64_lin/libmkl_scalapack_lp64.so:/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/mkl/lib/intel64_lin/libmkl_intel_lp64.so:/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/mkl/lib/intel64_lin/libmkl_intel_thread.so:/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/mkl/lib/intel64_lin/libmkl_core.so:/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/mkl/lib/intel64_lin/libmkl_blacs_intelmpi_lp64.so:/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/compiler/lib/intel64_lin/libiomp5.so
# openblas on Eole: issue27636
export OPENBLAS_CORETYPE=Sandybridge
# threads placement: issue24556
export I_MPI_PIN_DOMAIN=omp:compact

export PATH=${PREREQ_PATH}/prerequisites/Python-365/bin:${PATH}
export LD_LIBRARY_PATH=${PREREQ_PATH}/prerequisites/Python-365/lib:${LD_LIBRARY_PATH}

# custom configuration
export CONFIG_PARAMETERS_addmem=2500

# prerequisites paths
export PYPATH_NUMPY="${PREREQ_PATH}/prerequisites/Numpy-1151/lib/python3.6/site-packages"
export PYPATH_ASRUN="${PREREQ_PATH}/tools/Code_aster_frontend-salomemeca/lib/python3.6/site-packages"

export LIBPATH_HDF5="${PREREQ_PATH}/prerequisites/Hdf5-1103/lib"
export INCLUDES_HDF5="${PREREQ_PATH}/prerequisites/Hdf5-1103/include"

export LIBPATH_MED="${PREREQ_PATH}/prerequisites/Medfichier-400/lib"
export INCLUDES_MED="${PREREQ_PATH}/prerequisites/Medfichier-400/include"

export LIBPATH_METIS="${PREREQ_PATH}/prerequisites/Metis_aster-510_aster4/lib"
export INCLUDES_METIS="${PREREQ_PATH}/prerequisites/Metis_aster-510_aster4/include"

export LIBPATH_SCOTCH="${PREREQ_PATH}/prerequisites/Scotch_aster-604_aster7/SEQ/lib"
export INCLUDES_SCOTCH="${PREREQ_PATH}/prerequisites/Scotch_aster-604_aster7/SEQ/include"

export LIBPATH_MUMPS="${PREREQ_PATH}/prerequisites/Mumps-521_consortium_aster/SEQ/lib"
export INCLUDES_MUMPS="${PREREQ_PATH}/prerequisites/Mumps-521_consortium_aster/SEQ/include ${PREREQ_PATH}/prerequisites/Mumps-521_consortium_aster/SEQ/include_seq"

export TFELHOME="${PREREQ_PATH}/prerequisites/Mfront-TFEL321"
export TFELVERS="3.2.1"
export LIBPATH_MFRONT="${TFELHOME}/lib"
export INCLUDES_MFRONT="${TFELHOME}/include"
export PYPATH_MFRONT="${TFELHOME}/lib/python3.6/site-packages"

export INCLUDES_BOOST="${PREREQ_PATH}/prerequisites/Boost-1580/include"
export LIBPATH_BOOST="${PREREQ_PATH}/prerequisites/Boost-1580/lib"
export LIB_BOOST="boost_python3-mt"


export LD_LIBRARY_PATH=${LIBPATH_HDF5}:${LIBPATH_MED}:${LIBPATH_METIS}:${LIBPATH_SCOTCH}:${LIBPATH_MUMPS}:${LIBPATH_MFRONT}:${LIBPATH_BOOST}:${LD_LIBRARY_PATH}

export PYTHONPATH=${PYPATH_NUMPY}:${PYPATH_ASRUN}:${PYPATH_MFRONT}:${PYTHONPATH}

export PATH=\
${PREREQ_PATH}/prerequisites/Medfichier-400/bin:\
${PREREQ_PATH}/prerequisites/Gmsh_bin-2120Linux64/bin:\
${PREREQ_PATH}/tools/Miss3d-67_aster2:\
${PREREQ_PATH}/tools/Homard_aster-1112_aster2:\
${PREREQ_PATH}/tools/Ecrevisse-322:\
/projets/simumeca/salomemeca/appli_V2019:\
${TFELHOME}/bin:\
${PATH}
