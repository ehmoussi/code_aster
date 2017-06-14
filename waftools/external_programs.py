# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

"""
Checking for external programs called from code_aster.
"""

import os
import os.path as osp
from waflib import Configure, Errors


def options(self):
    group = self.add_option_group('External programs options')
    group.add_option('--with-prog-metis', action='store_true', default=None,
                    dest='with_prog_metis',
                    help='Force support of metis program')
    group.add_option('--with-prog-gmsh', action='store_true', default=None,
                    dest='with_prog_gmsh',
                    help='Force support of gmsh program')
    group.add_option('--with-prog-salome', action='store_true', default=None,
                    dest='with_prog_salome',
                    help='Force support of salome program')
    group.add_option('--with-prog-europlexus', action='store_true', default=None,
                    dest='with_prog_europlexus',
                    help='Force support of europlexus program')
    group.add_option('--with-prog-miss3d', action='store_true', default=None,
                    dest='with_prog_miss3d',
                    help='Force support of miss3d program')
    group.add_option('--with-prog-homard', action='store_true', default=None,
                    dest='with_prog_homard',
                    help='Force support of homard program')
    group.add_option('--with-prog-ecrevisse', action='store_true', default=None,
                    dest='with_prog_ecrevisse',
                    help='Force support of ecrevisse program')
    group.add_option('--with-prog-xmgrace', action='store_true', default=None,
                    dest='with_prog_xmgrace',
                    help='Force support of xmgrace program')


def configure(self):
    _check_prog(self, 'metis', ['gpmetis'],
                add_paths=[osp.join('${METISDIR}', 'bin')])

    _check_prog(self, 'gmsh', ['gmsh'])

    _check_prog(self, 'gibi', ['gibi_aster.py'],
                add_paths=['${GIBI_DIR}'])

    _check_prog(self, 'salome', ['salome'],
                add_paths=['${ABSOLUTE_APPLI_PATH}'])

    _check_prog(self, 'europlexus', ['europlexus'],
                add_paths=['${ABSOLUTE_APPLI_PATH}'])

    _check_prog(self, 'miss3d', ['run_miss3d'],
                add_paths=['${MISS3D_DIR}'])

    _check_prog(self, 'homard', ['homard'],
                add_paths=['${HOMARD_ASTER_ROOT_DIR}'])

    _check_prog(self, 'ecrevisse', ['ecrevisse'],
                add_paths=['${ECREVISSE_ROOT_DIR}'])

    _check_prog(self, 'xmgrace', ['xmgrace', 'gracebat'])


def _check_prog(self, name, programs, add_paths=None):
    opts = self.options
    paths0 = self.environ.get('PATH', '').split(os.pathsep)
    paths1 = [i for i in paths0 if 'outils' not in i]
    # try first without 'outils' in $PATH
    to_check = [paths1, paths0]
    add_paths = [osp.expandvars(i) for i in add_paths or []]
    with_prog = getattr(opts, 'with_prog_' + name, None)

    while to_check:
        success = True
        paths = to_check.pop(0)
        for prog in programs:
            try:
                self.find_program(prog, var='PROG_' + prog.upper(),
                                  path_list=add_paths + paths)
            except Errors.ConfigurationError:
                success = False
                break
        if success:
            break
    if not success and with_prog:
        raise Errors.ConfigurationError("not found in $PATH: {0}"
                                        .format(programs))
