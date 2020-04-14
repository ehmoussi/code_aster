# This file set the environment for code coverage with Intel compilers.

# If your platform dependent environment file is automatically sourced by waf
# check that these variables are not overridden.
# In this case, just source the your platform environment file manually
# (for example: eole_mpi.sh), and then this one.

export CFLAGS="${CFLAGS} -prof-gen=srcpos"
export CXXFLAGS="${CXXFLAGS} -prof-gen=srcpos"
export FCFLAGS="${FCFLAGS} -prof-gen=srcpos"
export LINKFLAGS="${LINKFLAGS} -prof-gen=srcpos"
