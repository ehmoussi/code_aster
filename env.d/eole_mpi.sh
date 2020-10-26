# This file set the environment for code_aster.
# Configuration for Eole MPI

# keep path to this file
export WAFBUILD_ENV=$(readlink -n -f ${BASH_SOURCE})

# DEVTOOLS_COMPUTER_ID avoids waf to re-source the environment
export DEVTOOLS_COMPUTER_ID=eole
# expected version of official prerequisites
export OFFICIAL_PLATFORM=1
export PREREQ_PATH=/projets/simumeca/public/v15
export PREREQ_VERSION=20201002

# force parallel build
export ENABLE_MPI=1

# generic environment: compilers, python
. /etc/profile.d/lmod.sh
module load ifort/2016.0.047 icc/2016.0.047 mkl/2017.0.098 impi/2017.0.098
export CC=mpiicc
export FC=mpiifort
export CXX=mpiicpc

export LD_PRELOAD=${LD_PRELOAD}:/opt/impi-2017.0.098/lib64/libmpi.so:/opt/mkl-2017.0.098/compilers_and_libraries_2017.0.098/linux/mkl/lib/intel64_lin/libmkl_scalapack_lp64.so:/opt/mkl-2017.0.098/compilers_and_libraries_2017.0.098/linux/mkl/lib/intel64_lin/libmkl_intel_lp64.so:/opt/mkl-2017.0.098/compilers_and_libraries_2017.0.098/linux/mkl/lib/intel64_lin/libmkl_intel_thread.so:/opt/mkl-2017.0.098/compilers_and_libraries_2017.0.098/linux/mkl/lib/intel64_lin/libmkl_core.so:/opt/mkl-2017.0.098/compilers_and_libraries_2017.0.098/linux/mkl/lib/intel64_lin/libmkl_blacs_intelmpi_lp64.so:/opt/mkl-2017.0.098/compilers_and_libraries_2017.0.098/linux/compiler/lib/intel64_lin/libiomp5.so

# suppress too aggressive optimization with Intel impi/2017.0.98
export I_MPI_DAPL_TRANSLATION_CACHE=0

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

export LIBPATH_MED="${PREREQ_PATH}/prerequisites/Medfichier-410/lib"
export INCLUDES_MED="${PREREQ_PATH}/prerequisites/Medfichier-410/include"
export PYPATH_MED="${PREREQ_PATH}/prerequisites/Medfichier-410/lib/python3.6/site-packages"

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

export LIBPATH_MEDCOUPLING="${PREREQ_PATH}/tools/Medcoupling_mpi-V9_6_0a1/lib"
export INCLUDES_MEDCOUPLING="${PREREQ_PATH}/tools/Medcoupling_mpi-V9_6_0a1/include"
export PYPATH_MEDCOUPLING="${PREREQ_PATH}/tools/Medcoupling_mpi-V9_6_0a1/lib/python3.6/site-packages"

export LIBPATH_MPI4PY="${PREREQ_PATH}/prerequisites/Mpi4py-200_intel2016/lib"
export PYPATH_MPI4PY="${PREREQ_PATH}/prerequisites/Mpi4py-200_intel2016/lib/python3.6/site-packages"

export TFELHOME="${PREREQ_PATH}/prerequisites/Mfront-TFEL321"
export TFELVERS="3.2.1"
export LIBPATH_MFRONT="${TFELHOME}/lib"
export INCLUDES_MFRONT="${TFELHOME}/include"
export PYPATH_MFRONT="${TFELHOME}/lib/python3.6/site-packages"

export INCLUDES_BOOST="${PREREQ_PATH}/prerequisites/Boost-1580/include"
export LIBPATH_BOOST="${PREREQ_PATH}/prerequisites/Boost-1580/lib"
export LIB_BOOST="boost_python3-mt"


export LD_LIBRARY_PATH=${LIBPATH_HDF5}:${LIBPATH_MED}:${LIBPATH_METIS}:${LIBPATH_SCOTCH}:${LIBPATH_MUMPS}:${LIBPATH_MFRONT}:${LIBPATH_BOOST}:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${LIBPATH_PARMETIS}:${LIBPATH_PETSC}:${LIBPATH_MEDCOUPLING}:${LIBPATH_MPI4PY}:${LD_LIBRARY_PATH}

export PYTHONPATH=${PYPATH_NUMPY}:${PYPATH_ASRUN}:${PYPATH_MFRONT}:${PYPATH_MEDCOUPLING}:${PYPATH_MPI4PY}:${PYPATH_MED}:${PYTHONPATH}

export PATH=\
${PREREQ_PATH}/prerequisites/Medfichier-410/bin:\
${PREREQ_PATH}/prerequisites/Gmsh_bin-2120Linux64/bin:\
${PREREQ_PATH}/tools/Miss3d-67_aster3:\
${PREREQ_PATH}/tools/Homard_aster-1112_aster2:\
${PREREQ_PATH}/tools/Ecrevisse-322:\
/projets/simumeca/salomemeca/appli_V2019:\
${TFELHOME}/bin:\
${PATH}
