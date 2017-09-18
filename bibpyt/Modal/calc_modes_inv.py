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

# person_in_charge: nicolas.brie at edf.fr


def calc_modes_inv(self, TYPE_RESU, OPTION, SOLVEUR_MODAL,
                   SOLVEUR, VERI_MODE, stop_erreur, INFO, TITRE, **args):
    """
       Macro-command CALC_MODES, case of the inverse iterations method
    """

    from code_aster.Cata.Syntax import _F
    from Modal.mode_iter_inv import MODE_ITER_INV


    motcles = {}
    matrices = {}

    # read the input matrices
    if TYPE_RESU == 'DYNAMIQUE':
        type_vp = 'FREQ'
        matrices['MATR_RIGI'] = args['MATR_RIGI']
        matrices['MATR_MASS'] = args['MATR_MASS']
        if args.has_key('MATR_AMOR'):
            matrices['MATR_AMOR'] = args['MATR_AMOR']

    elif TYPE_RESU == 'MODE_FLAMB':
        type_vp = 'CHAR_CRIT'
        matrices['MATR_RIGI'] = args['MATR_RIGI']
        matrices['MATR_RIGI_GEOM'] = args['MATR_RIGI_GEOM']

    elif TYPE_RESU == 'GENERAL':
        type_vp = 'CHAR_CRIT'
        matrices['MATR_A'] = args['MATR_A']
        matrices['MATR_B'] = args['MATR_B']

    motcles.update(matrices)

    #
    # read the keyword CALC_FREQ or CALC_CHAR_CRIT
    motcles_calc_vp = {}

    calc_vp = args['CALC_' + type_vp]
    nmax_vp = 'NMAX_' + type_vp

    motcles_calc_vp[type_vp] = calc_vp[type_vp]
    motcles_calc_vp[nmax_vp] = calc_vp[nmax_vp]
    motcles_calc_vp['SEUIL_' + type_vp] = calc_vp['SEUIL_' + type_vp]

    motcles['CALC_' + type_vp] = _F(OPTION=OPTION,
                                    NMAX_ITER_SHIFT=calc_vp[
                                    'NMAX_ITER_SHIFT'],
                                    PREC_SHIFT=calc_vp['PREC_SHIFT'],
                                    NMAX_ITER_SEPARE=SOLVEUR_MODAL[
                                    'NMAX_ITER_SEPARE'],
                                    PREC_SEPARE=SOLVEUR_MODAL[
                                    'PREC_SEPARE'],
                                    NMAX_ITER_AJUSTE=SOLVEUR_MODAL[
                                    'NMAX_ITER_AJUSTE'],
                                    PREC_AJUSTE=SOLVEUR_MODAL[
                                    'PREC_AJUSTE'],
                                    **motcles_calc_vp
                                    )

    #
    # read the keyword CALC_MODE
    motcles['CALC_MODE'] = _F(OPTION=SOLVEUR_MODAL['OPTION_INV'],
                              PREC=SOLVEUR_MODAL['PREC_INV'],
                              NMAX_ITER=SOLVEUR_MODAL['NMAX_ITER_INV'],
                              )

    #
    # read the keyword SOLVEUR (linear solver)
    solveur = SOLVEUR[0].cree_dict_valeurs(SOLVEUR[0].mc_liste)
    if solveur.has_key('TYPE_RESU'):  # because TYPE_RESU is a keyword with a 'global' position
        solveur.pop('TYPE_RESU')
    if solveur.has_key('OPTION'):    # because OPTION is a keyword with a 'global' position
        solveur.pop('OPTION')
    if solveur.has_key('FREQ'):      # because FREQ can be a keyword with a 'global' position
        solveur.pop('FREQ')
    motcles['SOLVEUR'] = _F(**solveur)

    #
    # read the keyword VERI_MODE
    motcles['VERI_MODE'] = _F(STOP_ERREUR=stop_erreur,
                              SEUIL=VERI_MODE['SEUIL'],
                              STURM=VERI_MODE['STURM'],
                              PREC_SHIFT=VERI_MODE['PREC_SHIFT']
                              )

    #

    if TITRE != None:
        motcles['TITRE'] = TITRE

    modes = MODE_ITER_INV(TYPE_RESU=TYPE_RESU,
                          INFO=INFO,
                          **motcles
                          )

    return modes
