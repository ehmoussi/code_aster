# This file set the environment for code_aster.
# Configuration for clap0f0q STD

# DEVTOOLS_COMPUTER_ID avoids waf to re-source the environment
export DEVTOOLS_COMPUTER_ID=clap0f0q
# expected version of official prerequisites
export OFFICIAL_PLATFORM=1
export PREREQ_PATH=/home/aster/dev/codeaster-prerequisites/v15
export PREREQ_VERSION=20200117

# generic environment: compilers, python
export PATH=\
/home/aster/public/gcc_4_9_2/bin:\
${PREREQ_PATH}/prerequisites/Python-365/bin:\
${PATH}

export LD_LIBRARY_PATH=\
/home/aster/public/gcc_4_9_2/lib:\
${PREREQ_PATH}/prerequisites/Python-365/lib:\
${PREREQ_PATH}/prerequisites/Tcl-860/lib:\
${PREREQ_PATH}/prerequisites/Tk-860/lib:\
${LD_LIBRARY_PATH}

# for using metis with standard integer (since Metis_aster-510_aster4)
export CFLAGS="-DINTSIZE32"

# custom configuration
export CONFIG_PARAMETERS_addmem=500

# prerequisites paths
export LIBPATH_MATH="/home/aster/public/OpenBLAS_v0.3.7/lib"

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


export LD_LIBRARY_PATH=${LIBPATH_MATH}:${LIBPATH_HDF5}:${LIBPATH_MED}:${LIBPATH_METIS}:${LIBPATH_SCOTCH}:${LIBPATH_MUMPS}:${LIBPATH_MFRONT}:${LIBPATH_BOOST}:${LD_LIBRARY_PATH}

export PYTHONPATH=${PYPATH_NUMPY}:${PYPATH_ASRUN}:${PYPATH_MFRONT}:${PYTHONPATH}

export PATH=\
${PREREQ_PATH}/prerequisites/Medfichier-400/bin:\
${PREREQ_PATH}/prerequisites/Gmsh_bin-2120Linux32/bin:\
${PREREQ_PATH}/tools/Miss3d-67_aster2:\
${PREREQ_PATH}/tools/Homard_aster-1112_aster2:\
${PREREQ_PATH}/tools/Ecrevisse-322:\
${TFELHOME}/bin:\
${PATH}
