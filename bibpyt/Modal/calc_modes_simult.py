# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
from code_aster.Commands.ExecuteCommand import ExecuteCommand
from code_aster.Objects import (MechanicalModeContainer,
                                GeneralizedModeContainer,
                                ResultsContainer)
from code_aster.Objects import (AssemblyMatrixDisplacementDouble,
                                AssemblyMatrixTemperatureDouble,
                                AssemblyMatrixDisplacementComplex,
                                AssemblyMatrixPressureDouble,
                                GeneralizedAssemblyMatrixDouble,
                                GeneralizedAssemblyMatrixComplex)
from code_aster.Objects import MechanicalModeComplexContainer, BucklingModeContainer
from Modal.mode_iter_simult import MODE_ITER_SIMULT as MODE_ITER_SIMULT_CATA


class ModalCalculationSimult(ExecuteCommand):
    """Internal (non public) command to call the underlying operator."""
    command_name = "MODE_ITER_SIMULT"
    command_cata = MODE_ITER_SIMULT_CATA

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        TYPE_RESU = keywords.get("TYPE_RESU")
        print "TYPE_RESU", TYPE_RESU
        if TYPE_RESU in ("MODE_FLAMB", "GENERAL"):
            self._result = BucklingModeContainer()
            return

        vale_rigi = keywords.get("MATR_RIGI")
        vale_amor = keywords.get("MATR_AMOR")
        if vale_amor is not None and isinstance(vale_amor, AssemblyMatrixDisplacementDouble):
            self._result = MechanicalModeComplexContainer()
        elif isinstance(vale_rigi, AssemblyMatrixDisplacementDouble):
            self._result = MechanicalModeContainer()
        elif isinstance(vale_rigi, AssemblyMatrixTemperatureDouble):
            self._result = MechanicalModeContainer()
        elif isinstance(vale_rigi, AssemblyMatrixDisplacementComplex):
            self._result = MechanicalModeComplexContainer()
        elif isinstance(vale_rigi, AssemblyMatrixPressureDouble):
            self._result = MechanicalModeComplexContainer()
        elif isinstance(vale_rigi, GeneralizedAssemblyMatrixDouble):
            self._result = GeneralizedModeContainer()
        elif isinstance(vale_rigi, GeneralizedAssemblyMatrixComplex):
            self._result = GeneralizedModeContainer()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        matrRigi = keywords.get("MATR_RIGI")
        if matrRigi is not None:
            if isinstance(self._result, GeneralizedModeContainer):
                self._result.setGeneralizedDOFNumbering(matrRigi.getGeneralizedDOFNumbering())
            else:
                self._result.setDOFNumbering(matrRigi.getDOFNumbering())
            self._result.setStiffnessMatrix(matrRigi)
        matrAmor = keywords.get("MATR_AMOR")
        if matrAmor is not None:
            self._result.setDampingMatrix(matrAmor)
        self._result.update()


MODE_ITER_SIMULT = ModalCalculationSimult.run


def calc_modes_simult(self, stop_erreur, sturm, TYPE_RESU, OPTION, INFO, **args):
    """
       Macro-command CALC_MODES, case of the simultaneous iterations method
    """
    from code_aster.Cata.Syntax import _F

    args = _F(args)
    SOLVEUR = args.get("SOLVEUR")
    SOLVEUR_MODAL = args.get("SOLVEUR_MODAL")
    VERI_MODE = args.get("VERI_MODE")
    TITRE = args.get("TITRE")

    motcles = {}
    matrices = {}

    # read the input matrices
    if TYPE_RESU == 'DYNAMIQUE':
        type_vp = 'FREQ'
        matrices['MATR_RIGI'] = args['MATR_RIGI']
        matrices['MATR_MASS'] = args['MATR_MASS']
        if args['MATR_AMOR'] != None:
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

    if OPTION in ('PLUS_PETITE', 'PLUS_GRANDE'):
        motcles_calc_vp[nmax_vp] = calc_vp[nmax_vp]

    if OPTION == 'CENTRE':
        motcles_calc_vp[type_vp] = calc_vp[type_vp]
        if type_vp == 'FREQ':
            if calc_vp['AMOR_REDUIT'] != None:
                motcles_calc_vp['AMOR_REDUIT'] = calc_vp['AMOR_REDUIT']
        motcles_calc_vp[nmax_vp] = calc_vp[nmax_vp]

    if OPTION == 'BANDE':
        motcles_calc_vp[type_vp] = calc_vp[type_vp]
        if calc_vp['TABLE_'+type_vp] != None:
            motcles_calc_vp['TABLE_'+type_vp] = calc_vp['TABLE_'+type_vp]

    motcles_calc_vp['SEUIL_' + type_vp] = calc_vp['SEUIL_' + type_vp]

    if SOLVEUR_MODAL['DIM_SOUS_ESPACE'] != None:
        motcles_calc_vp['DIM_SOUS_ESPACE'] = SOLVEUR_MODAL['DIM_SOUS_ESPACE']
    if SOLVEUR_MODAL['COEF_DIM_ESPACE'] != None:
        motcles_calc_vp['COEF_DIM_ESPACE'] = SOLVEUR_MODAL['COEF_DIM_ESPACE']
    if SOLVEUR_MODAL['APPROCHE'] != None:
        motcles_calc_vp['APPROCHE'] = SOLVEUR_MODAL['APPROCHE']

    motcles['CALC_' + type_vp] = _F(OPTION=OPTION,
                                    NMAX_ITER_SHIFT=calc_vp['NMAX_ITER_SHIFT'],
                                    PREC_SHIFT=calc_vp['PREC_SHIFT'],
                                    **motcles_calc_vp)

    #
    # read the modal solver parameters
    motcles_solveur_modal = {}

    methode = SOLVEUR_MODAL['METHODE']
    motcles_solveur_modal['METHODE'] = methode

    if methode == 'TRI_DIAG':
        if SOLVEUR_MODAL['NMAX_ITER_ORTHO'] != None:
            motcles_solveur_modal[
                'NMAX_ITER_ORTHO'] = SOLVEUR_MODAL['NMAX_ITER_ORTHO']
        if SOLVEUR_MODAL['PREC_ORTHO'] != None:
            motcles_solveur_modal[
                'PREC_ORTHO'] = SOLVEUR_MODAL['PREC_ORTHO']
        if SOLVEUR_MODAL['PREC_LANCZOS'] != None:
            motcles_solveur_modal[
                'PREC_LANCZOS'] = SOLVEUR_MODAL['PREC_LANCZOS']
        if SOLVEUR_MODAL['NMAX_ITER_QR'] != None:
            motcles_solveur_modal[
                'NMAX_ITER_QR'] = SOLVEUR_MODAL['NMAX_ITER_QR']
        if SOLVEUR_MODAL['MODE_RIGIDE'] != None:
            if SOLVEUR_MODAL['MODE_RIGIDE'] == 'OUI':
                motcles['OPTION'] = 'MODE_RIGIDE'
            else:
                motcles['OPTION'] = 'SANS'
    elif methode == 'JACOBI':
        if SOLVEUR_MODAL['NMAX_ITER_BATHE'] != None:
            motcles_solveur_modal[
                'NMAX_ITER_BATHE'] = SOLVEUR_MODAL['NMAX_ITER_BATHE']
        if SOLVEUR_MODAL['PREC_BATHE'] != None:
            motcles_solveur_modal[
                'PREC_BATHE'] = SOLVEUR_MODAL['PREC_BATHE']
        if SOLVEUR_MODAL['NMAX_ITER_JACOBI'] != None:
            motcles_solveur_modal[
                'NMAX_ITER_JACOBI'] = SOLVEUR_MODAL['NMAX_ITER_JACOBI']
        if SOLVEUR_MODAL['PREC_JACOBI'] != None:
            motcles_solveur_modal[
                'PREC_JACOBI'] = SOLVEUR_MODAL['PREC_JACOBI']
    elif methode == 'SORENSEN':
        if SOLVEUR_MODAL['NMAX_ITER_SOREN'] != None:
            motcles_solveur_modal[
                'NMAX_ITER_SOREN'] = SOLVEUR_MODAL['NMAX_ITER_SOREN']
        if SOLVEUR_MODAL['PARA_ORTHO_SOREN'] != None:
            motcles_solveur_modal[
                'PARA_ORTHO_SOREN'] = SOLVEUR_MODAL['PARA_ORTHO_SOREN']
        if SOLVEUR_MODAL['PREC_SOREN'] != None:
            motcles_solveur_modal[
                'PREC_SOREN'] = SOLVEUR_MODAL['PREC_SOREN']
    elif methode == 'QZ':
        if SOLVEUR_MODAL['TYPE_QZ'] != None:
            motcles_solveur_modal['TYPE_QZ'] = SOLVEUR_MODAL['TYPE_QZ']

    motcles.update(motcles_solveur_modal)

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
    if sturm in ('GLOBAL', 'LOCAL','OUI'):
        # for MODE_ITER_SIMULT, value for STURM can be only OUI or NON. Other
        # values are equivalent to OUI
        motveri = 'OUI'
    elif sturm in ('NON'):
        # for keyword AMELIORATION
        motveri = 'NON'
    else:
        assert(False)  # Pb parametrage STURM

    motcles['VERI_MODE'] = _F(STOP_ERREUR=stop_erreur,
                              SEUIL=VERI_MODE['SEUIL'],
                              STURM=motveri,
                              PREC_SHIFT=VERI_MODE['PREC_SHIFT']
                              )

    #

    if args['STOP_BANDE_VIDE'] != None:
        motcles['STOP_BANDE_VIDE'] = args['STOP_BANDE_VIDE']

    if TITRE != None:
        motcles['TITRE'] = TITRE

    modes = MODE_ITER_SIMULT(TYPE_RESU=TYPE_RESU,
                             INFO=INFO,
                             **motcles
                             )

    materialOnMesh = None
    for matrice in matrices.values():
        try:
            if matrice.getNumberOfElementaryMatrix() != 0:
                modes.appendMaterialOnMeshOnAllRanks(matrice.getMaterialOnMesh())
                break
        except: pass

    return modes
