# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

import os.path as osp
from glob import glob

from code_aster.Cata.Syntax import Command


def _init_command(ctx, debug):
    """Import de toutes les commandes et les copie dans le contexte"""
    pkgdir = osp.dirname(__file__)
    pkg = osp.basename(pkgdir)
    l_mod = [osp.splitext(osp.basename(modname))[0]
             for modname in glob(osp.join(pkgdir, '*.py'))]
    for modname in l_mod:
        mod = __import__('code_aster.Cata.{}.{}'.format(pkg, modname),
                         globals(), locals(), [modname])
        # liste des commandes définies dans le module
        for objname in dir(mod):
            obj = getattr(mod, objname)
            if isinstance(obj, Command):
                if debug:
                    print '<Commande> Module "%s" - ajout "%s"' % (modname, objname)
                ctx[objname] = obj

_init_command(ctx=globals(), debug=False)
del _init_command
