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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    1 : _(u"""
Contact LAC
Seuls les algorithmes en Newton sont utilisables (ALGO_RESO_GEOM et ALGO_RESO_CONT)
"""),

    2 : _(u"""
Contact LAC
    Le maillage %(k1)s ne contient pas les objets spécifiques à la méthode ALGO_CONT='LAC'.
Conseil:
    Il faut faire CREA_MAILLAGE/DECOUPE_LAC avant DEFI_CONTACT
"""),

    4 : _(u"""
Contact LAC
        ALGO_CONT='LAC' ne fonctionne pas avec le frottement. 
"""),

    5 : _(u"""
Contact LAC
         On ne détecte pas le bon nombre de mailles esclaves. 
         Conseil :
             Cette erreur est probablement dû au fait que vous avez inversé les rôles maîtres et esclaves. 
             Vérifiez que votre GROUP_MA_ESCL est bien celui utilisé par DECOUPE_LAC de CREA_MAILLAGE.  
"""),

    6 : _(u"""
Contact LAC
         Le frottement n'est pas autorisé (COULOMB=0.0).   
"""),

}
