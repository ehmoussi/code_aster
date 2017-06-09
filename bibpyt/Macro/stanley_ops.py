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

def stanley_ops(self, RESULTAT, MODELE, CHAM_MATER, CARA_ELEM, DISPLAY, **args):
    """
       Importation et lancement de Stanley
    """

    import os
    import string
    import aster
    from code_aster.Cata.Syntax import _F
    from Noyau.N_utils import AsType
    from Utilitai.Utmess import UTMESS
    from Utilitai.UniteAster import UniteAster

    prev_onFatalError = aster.onFatalError()
    aster.onFatalError('EXCEPTION')

    ier = 0

    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    # Redefinition eventuelle du DISPLAY
    if DISPLAY:
        UTMESS('I', 'STANLEY_1', valk=DISPLAY)
        os.environ['DISPLAY'] = DISPLAY

    # Mode validation de la non-regression
    if args['UNITE_VALIDATION']:
        UTMESS('I', 'STANLEY_2')
        UL = UniteAster()
        FICHIER_VALID = UL.Nom(args['UNITE_VALIDATION'])
    else:
        FICHIER_VALID = None

    # On ne lance Stanley que si la variable DISPLAY est définie
    if os.environ.has_key('DISPLAY'):

        import Stanley
        from Stanley import stanley_engine

        if (RESULTAT and MODELE and CHAM_MATER):
            _MAIL = aster.getvectjev(
                string.ljust(MODELE.nom, 8) + '.MODELE    .LGRF        ')
            _MAIL = string.strip(_MAIL[0])
            MAILLAGE = self.jdc.g_context[_MAIL]
            if CARA_ELEM:
                stanley_engine.STANLEY(
                    RESULTAT, MAILLAGE, MODELE, CHAM_MATER, CARA_ELEM)
            else:
                stanley_engine.STANLEY(
                    RESULTAT, MAILLAGE, MODELE, CHAM_MATER, None)
        else:
            stanley_engine.PRE_STANLEY(FICHIER_VALID)

    else:
        UTMESS('A', 'STANLEY_3', valk=['STANLEY'])

    aster.onFatalError(prev_onFatalError)

    return ier
