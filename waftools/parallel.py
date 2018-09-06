# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import os
import os.path as osp
from functools import partial
from waflib import Options, Configure, Errors, Logs, Utils


def options(self):
    self.load('compiler_c')
    self.load('compiler_cxx')
    self.load('compiler_fc')

    group = self.get_option_group("code_aster options")
    group.add_option('--enable-mpi', dest='parallel', action='store_true',
                     help='Build a parallel version with mpi')
    group.add_option('--enable-openmp', dest='openmp', action='store_true',
                     help='Build a parallel version supporting OpenMP')
    group.add_option('--disable-openmp', dest='openmp', action='store_false',
                     help='Disable OpenMP')

def configure(self):
    opts = self.options
    if opts.parallel:
        # Configure.find_program uses first self.environ, then os.environ
        self.environ.setdefault('CC', 'mpicc')
        self.environ.setdefault('CXX', 'mpicxx')
        self.environ.setdefault('FC', 'mpif90')
    self.load_compilers()
    self.check_compilers_version()
    self.check_fortran_verbose_flag()
    self.check_openmp()
    self.check_fortran_clib()
    self.check_vmsize()

###############################################################################

@Configure.conf
def check_compilers_version(self):
    self.start_msg('Checking for C compiler version')
    self.end_msg(self.env.CC_NAME.lower() + ' ' + \
                 '.'.join(Utils.to_list(self.env.CC_VERSION)))
    # CXX_VERSION does not exist, c++ == c
    self.start_msg('Checking for Fortran compiler version')
    self.end_msg(self.env.FC_NAME.lower() + ' ' + \
                 '.'.join(Utils.to_list(self.env.FC_VERSION)))

@Configure.conf
def load_compilers(self):
    self.load('compiler_c')
    self.load('compiler_cxx')
    self.load('compiler_fc')
    if self.options.parallel:
        cc = self.env.CC[0]
        cxx = self.env.CXX[0]
        fc = self.env.FC[0]
        check = partial(self.check_cfg, args='--showme:compile --showme:link -show',
                        package='', uselib_store='MPI', mandatory=False)
        # do not add flags given by cxx linker
        if check(path=cc) and check(path=fc):
            self.check_mpi()
        if not self.get_define('HAVE_MPI'):
            self.fatal("Unable to configure the parallel environment")
        self.env.BUILD_PARALLEL = 1

@Configure.conf
def check_mpi(self):
    self.check_cc(header_name='mpi.h', use='MPI', define_name='_USE_MPI')
    if self.get_define('_USE_MPI'):
        self.define('HAVE_MPI', 1)

@Configure.conf
def check_openmp(self):
    opts = self.options
    if opts.openmp is False:
        self.msg('Checking for OpenMP flag', 'no', color='YELLOW')
        return
    try:
        self.detect_openmp()
    except (Errors.ConfigurationError, Errors.BuildError):
        if opts.openmp is True:
            raise
        self.env.append_value('FCFLAGS_OPENMP', ['-fopenmp'])
        self.env.append_value('FCLINKFLAGS_OPENMP', ['-fopenmp'])
    if self.env.FCFLAGS_OPENMP:
        self.env.BUILD_OPENMP = 1
        self.define('_USE_OPENMP', 1)

@Configure.conf
def check_sizeof_mpi_int(self):
    """Check size of MPI_Fint"""
    if self.get_define('HAVE_MPI'):
        fragment = '\n'.join([
            '#include <stdio.h>',
            '#include "mpi.h"',
            'int main(void){',
            '    MPI_Fint var;',
            '    printf("%d", (int)sizeof(var));',
            '    return 0;',
            '}',
            ''])
        self.code_checker('MPI_INT_SIZE', self.check_cc, fragment,
                          'Checking size of MPI_Fint integers',
                          'unexpected value for sizeof(MPI_Fint): %(size)s',
                          into=(4, 8), use='MPI')

@Configure.conf
def check_vmsize(self):
    """Check for VmSize 'bug' with MPI."""
    if self.get_define('HAVE_MPI'):
        self.code_checker('ENABLE_PROC_STATUS', self.check_cc,
                          fragment_failure_vmsize,
                          'Checking failure for VmSize in MPI',
                          'Can not use /proc/xx/status for memory usage',
                          setbool=True, use='MPI')
    else:
        self.define('ENABLE_PROC_STATUS', 1)


fragment_failure_vmsize = r"""
/*
   Check for unexpected value of VmPeak passing MPI_Init.
*/

#include <stdio.h>
#include <fcntl.h>
#include <string.h>

#include "mpi.h"


long read_vmsize()
{
    static char filename[80];
    static char sbuf[1024];
    char* str;
    int fd, size;

    sprintf(filename, "/proc/%ld/status", (long)getpid());
    fd = open(filename, O_RDONLY, 0);
    if (fd == -1)
        return -1;
    size = read(fd, sbuf, (sizeof sbuf) - 1);
    close(fd);

    str = strstr(sbuf, "VmSize:") + 8;
    return atol(str);
}

int main(int argc, char *argv[])
{
    int procid;
    long size;

    size = read_vmsize();

    MPI_Init(&argc, &argv);

    sleep(1);
    size = read_vmsize() - size;

    MPI_Finalize();

    if ( size > 10 * 1024 * 1024 ) {
        // it should be around 100 kB
        printf("MPI initialization allocated more than 10 MB (%ld bytes)\n", size);
        MPI_Abort(MPI_COMM_WORLD, 1);
        return 1;
    }

    printf("ok");
    return 0;
}
"""
