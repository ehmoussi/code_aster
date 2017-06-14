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

import os
import os.path as osp
from waflib import Configure, Errors


def options(self):
    group = self.add_option_group('External programs options')
    group.add_option('--with-prog-metis', action='store_true', default=None,
                    dest='with_prog_metis',
                    help='Fails if metis program is not found')
    group.add_option('--with-prog-gmsh', action='store_true', default=None,
                    dest='with_prog_gmsh',
                    help='Fails if gmsh program is not found')
    group.add_option('--with-prog-salome', action='store_true', default=None,
                    dest='with_prog_salome',
                    help='Fails if salome program is not found')
    group.add_option('--with-prog-europlexus', action='store_true', default=None,
                    dest='with_prog_europlexus',
                    help='Fails if europlexus program is not found')
    group.add_option('--with-prog-miss3d', action='store_true', default=None,
                    dest='with_prog_miss3d',
                    help='Fails if miss3d program is not found')
    group.add_option('--with-prog-homard', action='store_true', default=None,
                    dest='with_prog_homard',
                    help='Fails if homard program is not found')
    group.add_option('--with-prog-ecrevisse', action='store_true', default=None,
                    dest='with_prog_ecrevisse',
                    help='Fails if ecrevisse program is not found')
    group.add_option('--with-prog-xmgrace', action='store_true', default=None,
                    dest='with_prog_xmgrace',
                    help='Fails if xmgrace program is not found')


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
                self.find_program(prog, var='PROG_' + name.upper(),
                                  path_list=add_paths + paths)
            except Errors.ConfigurationError:
                success = False
                break
        if success:
            break
    if not success and with_prog:
        raise Errors.ConfigurationError("not found in $PATH: {0}"
                                        .format(programs))
