# coding=utf-8

"""
Configuration using Intel compilers

Use automatically MPI wrappers if opt.parallel was previously set.
"""

def configure(self):
    opts = self.options
    mpi = 'mpi' if opts.parallel else ''
    self.env['FC'] = mpi + 'ifort'
    self.env['CC'] = mpi + 'icc'
    self.env['CXX'] = mpi + 'icpc'
