# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

# person_in_charge: jean-luc.flejou at edf.fr
#
from code_aster.Utilities import force_list


def affe_cara_elem_ops(self, **args):
    """
       Ecriture de la macro AFFE_CARA_ELEM
    """
    from code_aster.Commands.cara_elem import CARA_ELEM
    args = _F(args)
    MODELE = args['MODELE']
    INFO = args['INFO']
    VERIF = args['VERIF']
    POUTRE = args['POUTRE']
    BARRE = args['BARRE']
    COQUE = args['COQUE']
    CABLE = args['CABLE']
    DISCRET = args['DISCRET']
    DISCRET_2D = args['DISCRET_2D']
    ORIENTATION = args['ORIENTATION']
    MASSIF = args['MASSIF']
    POUTRE_FLUI = args['POUTRE_FLUI']
    GRILLE = args['GRILLE']
    MEMBRANE = args['MEMBRANE']
    RIGI_PARASOL = args['RIGI_PARASOL']
    RIGI_MISS_3D = args['RIGI_MISS_3D']
    MASS_AJOU = args['MASS_AJOU']
    MASS_REP = args['MASS_REP']
    GEOM_FIBRE = args['GEOM_FIBRE']
    MULTIFIBRE = args['MULTIFIBRE']
    #
    ier = 0
    # La macro compte pour ?? dans la numérotation des commandes
    self.set_icmd(1)
    #
    # Le concept sortant est nommé 'nomres' dans le contexte de la macro
    self.DeclareOut('nomres', self.sd)
    #
    motclef_cara_elem = {}
    if (MODELE):
        motclef_cara_elem['MODELE'] = MODELE
    if (INFO):
        motclef_cara_elem['INFO'] = INFO
    if (VERIF):
        motclef_cara_elem['VERIF'] = VERIF
    #
    if POUTRE is not None:
        motclef_cara_elem['POUTRE'] = force_list(POUTRE)
    #
    if BARRE is not None:
        motclef_cara_elem['BARRE'] = force_list(BARRE)
    #
    if COQUE is not None:
        motclef_cara_elem['COQUE'] = force_list(COQUE)
    #
    if CABLE is not None:
        motclef_cara_elem['CABLE'] = force_list(CABLE)
    #
    if DISCRET is not None:
        motclef_cara_elem['DISCRET'] = force_list(DISCRET)
    #
    if DISCRET_2D is not None:
        motclef_cara_elem['DISCRET_2D'] = force_list(DISCRET_2D)
    #
    if ORIENTATION is not None:
        motclef_cara_elem['ORIENTATION'] = force_list(ORIENTATION)
    #
    if MASSIF is not None:
        motclef_cara_elem['MASSIF'] = force_list(MASSIF)
    #
    if POUTRE_FLUI is not None:
        motclef_cara_elem['POUTRE_FLUI'] = force_list(POUTRE_FLUI)
    #
    if GRILLE is not None:
        motclef_cara_elem['GRILLE'] = force_list(GRILLE)
    #
    if MEMBRANE is not None:
        motclef_cara_elem['MEMBRANE'] = force_list(MEMBRANE)
    #
    if RIGI_PARASOL is not None:
        motclef_cara_elem['RIGI_PARASOL'] = force_list(RIGI_PARASOL)
    #
    if RIGI_MISS_3D is not None:
        motclef_cara_elem['RIGI_MISS_3D'] = force_list(RIGI_MISS_3D)
    #
    if MASS_AJOU is not None:
        motclef_cara_elem['MASS_AJOU'] = force_list(MASS_AJOU)
    #
    if MASS_REP is not None:
        motclef_cara_elem['MASS_REP'] = force_list(MASS_REP)
    #
    if GEOM_FIBRE is not None:
        motclef_cara_elem['GEOM_FIBRE'] = GEOM_FIBRE
    #
    if MULTIFIBRE is not None:
        motclef_cara_elem['MULTIFIBRE'] = force_list(MULTIFIBRE)
    #
    nomres = CARA_ELEM(**motclef_cara_elem)
    #
    return nomres
