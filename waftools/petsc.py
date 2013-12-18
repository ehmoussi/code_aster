# coding=utf-8

import os.path as osp
from functools import partial
from waflib import Options, Configure, Logs, Utils, Errors

def options(self):
    group = self.add_option_group("Petsc library options")
    group.add_option('--disable-petsc', dest='enable_petsc',
                   action='store_false', default=None,
                   help='Disable PETSC support')
    group.add_option('--enable-petsc', dest='enable_petsc',
                   action='store_true', default=None,
                   help='Force PETSC support')
    group.add_option('--petsc-libs', type='string',
                   dest='petsc_libs', default=None,
                   help='petsc librairies used when linking')
    group.add_option('--embed-petsc', dest='embed_petsc',
                    default=False, action='store_true',
                    help='Embed PETSC libraries as static library')


def configure(self):
    try:
        self.env.stash()
        self.check_petsc()
    except Errors.ConfigurationError:
        self.env.revert()
        if self.options.enable_petsc == True:
            raise
    else:
        self.define('_HAVE_PETSC', 1)
        self.define('HAVE_PETSC', 1)

###############################################################################
@Configure.conf
def check_petsc(self):
    opts = self.options
    if opts.enable_petsc == False:
        raise Errors.ConfigurationError('PETSC disabled')

    optlibs = None
    if opts.petsc_libs is None:
        opts.petsc_libs = 'petsc'
        # add optional libs
        optlibs ='ml HYPRE stdc++'
    if opts.petsc_libs:
        self.check_petsc_libs(optlibs)

    self.check_petsc_headers()

@Configure.conf
def check_petsc_libs(self, optlibs):
    opts = self.options
    keylib = ('st' if opts.embed_all or opts.embed_scotch else '') + 'lib'
    for lib in Utils.to_list(opts.petsc_libs):
        self.check_cc(uselib_store='PETSC', use='MPI', mandatory=True, **{ keylib: lib})
    for lib in Utils.to_list(optlibs or ''):
        self.check_cc(uselib_store='PETSC', use='MPI', mandatory=False, **{ keylib: lib})

@Configure.conf
def check_petsc_headers(self):
    check = partial(self.check, header_name='petsc.h', uselib='PETSC')

    self.start_msg('Checking for header petsc.h')
    try:
        if not check(mandatory=False):
            if not check(includes=[osp.join(self.env.INCLUDEDIR, 'petsc')], mandatory=False):
                check(includes=[osp.join(self.env.OLDINCLUDEDIR, 'petsc')], mandatory=True)
    except:
        self.end_msg('no', 'YELLOW')
        raise
    else:
        self.end_msg('yes')
