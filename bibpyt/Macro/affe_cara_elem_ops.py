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

# person_in_charge: jean-luc.flejou at edf.fr
#

def affe_cara_elem_ops(self, MODELE, INFO, VERIF,
    POUTRE, BARRE, COQUE, CABLE,
    DISCRET, DISCRET_2D, ORIENTATION, MASSIF, POUTRE_FLUI, GRILLE, MEMBRANE,
    RIGI_PARASOL, RIGI_MISS_3D, MASS_AJOU, MASS_REP,
    GEOM_FIBRE, MULTIFIBRE, **args):
    """
       Ecriture de la macro AFFE_CARA_ELEM
    """
    #
    ier = 0
    # On importe les définitions des commandes à utiliser dans la macro
    # Le nom de la variable doit être obligatoirement le nom de la commande
    from Macro.cara_elem import CARA_ELEM
    # La macro compte pour ?? dans la numérotation des commandes
    self.set_icmd(1)
    #
    # Le concept sortant est nommé 'nomres' dans le contexte de la macro
    self.DeclareOut('nomres', self.sd)
    #
    motclef_cara_elem = {}
    if ( MODELE ):  motclef_cara_elem['MODELE']   = MODELE
    if ( INFO ):    motclef_cara_elem['INFO']     = INFO
    if ( VERIF ):   motclef_cara_elem['VERIF']    = VERIF
    #
    if POUTRE != None:
        motclef_cara_elem['POUTRE']         = POUTRE.List_F()
    #
    if BARRE != None:
        motclef_cara_elem['BARRE']          = BARRE.List_F()
    #
    if COQUE != None:
        motclef_cara_elem['COQUE']          = COQUE.List_F()
    #
    if CABLE != None:
        motclef_cara_elem['CABLE']          = CABLE.List_F()
    #
    if DISCRET != None:
        motclef_cara_elem['DISCRET']        = DISCRET.List_F()
    #
    if DISCRET_2D != None:
        motclef_cara_elem['DISCRET_2D']     = DISCRET_2D.List_F()
    #
    if ORIENTATION != None:
        motclef_cara_elem['ORIENTATION']    = ORIENTATION.List_F()
    #
    if MASSIF != None:
        motclef_cara_elem['MASSIF']         = MASSIF.List_F()
    #
    if POUTRE_FLUI != None:
        motclef_cara_elem['POUTRE_FLUI']    = POUTRE_FLUI.List_F()
    #
    if GRILLE != None:
        motclef_cara_elem['GRILLE']         = GRILLE.List_F()
    #
    if MEMBRANE != None:
        motclef_cara_elem['MEMBRANE']       = MEMBRANE.List_F()
    #
    if RIGI_PARASOL != None:
        motclef_cara_elem['RIGI_PARASOL']   = RIGI_PARASOL.List_F()
    #
    if RIGI_MISS_3D != None:
        motclef_cara_elem['RIGI_MISS_3D']   = RIGI_MISS_3D.List_F()
    #
    if MASS_AJOU != None:
        motclef_cara_elem['MASS_AJOU']      = MASS_AJOU.List_F()
    #
    if MASS_REP != None:
        motclef_cara_elem['MASS_REP']       = MASS_REP.List_F()
    #
    if GEOM_FIBRE != None:
        motclef_cara_elem['GEOM_FIBRE']     = GEOM_FIBRE
    #
    if MULTIFIBRE != None:
        motclef_cara_elem['MULTIFIBRE']     = MULTIFIBRE.List_F()
    #
    nomres = CARA_ELEM( **motclef_cara_elem )
    #
    return ier
