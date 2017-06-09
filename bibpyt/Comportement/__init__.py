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

# person_in_charge: mathieu.courtois at edf.fr

"""
Ce package contient la définition des comportements.
"""

import os.path as osp
from glob import glob

from cata_comportement import CataComportementError, LoiComportement, KIT, catalc


def _init_cata(debug):
    """Import de tous les comportements"""
    from Execution.strfunc import ufmt
    from cata_vari import DICT_NOM_VARI
    pkgdir = osp.dirname(__file__)
    pkg = osp.basename(pkgdir)
    l_mod = [osp.splitext(osp.basename(modname))[0]
             for modname in glob(osp.join(pkgdir, '*.py'))]
    l_mod = [modname for modname in l_mod
             if modname not in ('__init__', 'cata_comportement')]
    all_vari = set()
    for modname in l_mod:
        try:
            mod = __import__('%s.%s' %
                             (pkg, modname), globals(), locals(), [modname])
            # liste des lois de comportements définies dans le module
            for objname in dir(mod):
                obj = getattr(mod, objname)
                if isinstance(obj, LoiComportement):
                    if debug:
                        print '<Comportement> Module "%s" - ajout objet "%s"' % (modname, objname)
                    catalc.add(obj)
                    all_vari.update(obj.nom_vari)
        except Exception, msg:
            err = ufmt(u"Erreur import de '%s' : %s", modname, str(msg))
            raise CataComportementError(err)
    if debug:
        print catalc
    # vérification que toutes les variables déclarées sont utilisées
    unused = list(set(DICT_NOM_VARI.keys()).difference(all_vari))
    if unused:
        unused.sort()
        msg = u"Variables déclarées dans cata_vari mais non utilisées: %s" \
            % ', '.join(unused)
        raise CataComportementError(msg)

_init_cata(debug=False)
del _init_cata
