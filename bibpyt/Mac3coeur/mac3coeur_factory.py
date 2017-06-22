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

# person_in_charge: samuel.geniaut at edf.fr

"""
Module dédié à la macro MAC3COEUR.

On définit ici les factories qui permettent de lire les fichiers datg,
et produisent les objets Assemblages ou Coeurs correspondants.
"""

import os.path as osp


class Mac3Factory(object):

    """Classe chapeau des factories."""
    prefix = ''

    def __init__(self, datg):
        """Initialisation"""
        self.rep_datg = datg
        self.cata = {}

    def _get_obj_fname(self, fname):
        """Retourne le nom du fichier définissant l'objet à importer."""
        fname = osp.join(self.rep_datg, fname + ".datg")
        assert osp.exists(fname), 'file not found %s' % fname
        return fname

    def build_supported_types(self):
        """Construit la liste des types autorisés."""
        raise NotImplementedError

    def _context_init(self):
        """Retourne un context pour l'import des modules dans datg."""
        ctxt = self.build_supported_types()
        return ctxt

    def _import_obj(self, objname):
        """Importe la classe d'un type d'objet."""
        fname = self._get_obj_fname(objname)
        ctxt = self._context_init()
        execfile(fname, ctxt)
        obj = ctxt.get(objname)
        assert obj, "No object named '%s' has been defined in the " \
                    "catalog '%s'" % (objname, fname)
        self.cata[objname] = ctxt[objname]

    def get(self, objname):
        """Retourne l'objet nommé."""
        objname = self.prefix + objname
        if self.cata.get(objname) is None:
            self._import_obj(objname)
        return self.cata[objname]
