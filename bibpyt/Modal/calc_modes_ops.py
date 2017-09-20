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


def calc_modes_ops(self, TYPE_RESU, OPTION,
                         SOLVEUR_MODAL, SOLVEUR, VERI_MODE, AMELIORATION,
                         INFO, TITRE, **args):
    """
       Macro-command CALC_MODES, main file
    """

    ier=0

    import aster
    from code_aster.Cata.Syntax import _F
    from Noyau.N_utils import AsType
    from Modal.calc_modes_simult import calc_modes_simult
    from Modal.calc_modes_inv import calc_modes_inv
    from Modal.calc_modes_multi_bandes import calc_modes_multi_bandes
    from Modal.calc_modes_amelioration import calc_modes_amelioration
    from Modal.calc_modes_post import calc_modes_post

    
    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    self.DeclareOut('modes', self.sd)

    l_multi_bandes = False # logical indicating if the computation is performed
                           # for DYNAMICAL modes on several bands

    # to prepare the work of AMELIORATION='OUI'
    stop_erreur= None
    sturm     = None
    if (AMELIORATION=='OUI'):
        if OPTION in ('SEPARE', 'AJUSTE', 'PROCHE'):
          assert(False)   
        stop_erreur='NON'
        sturm      ='NON'
    else:
        stop_erreur=VERI_MODE['STOP_ERREUR']
        sturm      =VERI_MODE['STURM']


    if (TYPE_RESU == 'DYNAMIQUE'):

        if (OPTION == 'BANDE'):
            if len(args['CALC_FREQ']['FREQ']) > 2:
                l_multi_bandes = True
                # modes computation over several frequency bands,
                # with optional parallelization of the bands
                modes = calc_modes_multi_bandes(self, SOLVEUR_MODAL, SOLVEUR,
                                                VERI_MODE, stop_erreur, sturm, INFO, TITRE, **args)

    if not l_multi_bandes:
        if OPTION in ('PLUS_PETITE', 'PLUS_GRANDE', 'CENTRE', 'BANDE', 'TOUT'):
            # call the MODE_ITER_SIMULT command
            modes = calc_modes_simult(self, TYPE_RESU, OPTION, SOLVEUR_MODAL,
                                      SOLVEUR, VERI_MODE, stop_erreur, sturm, INFO, TITRE, **args)

        elif OPTION in ('SEPARE', 'AJUSTE', 'PROCHE'):
            # call the MODE_ITER_INV command
            modes = calc_modes_inv(self, TYPE_RESU, OPTION, SOLVEUR_MODAL,
                                   SOLVEUR, VERI_MODE, stop_erreur, sturm, INFO, TITRE, **args)

    if AMELIORATION=='OUI':
        # after a 1st modal computation, achieve a 2nd computation with MODE_ITER_INV
        # and option 'PROCHE' to refine the modes
        modes = calc_modes_amelioration(self, modes, TYPE_RESU, SOLVEUR_MODAL,
                                        SOLVEUR, VERI_MODE, INFO, TITRE, **args)



    ##################
    # post-traitements
    ##################
    if (TYPE_RESU == 'DYNAMIQUE'):

        lmatphys = False # logical indicating if the matrices are physical or not (generalized)
        iret, ibid, nom_matrrigi = aster.dismoi('REF_RIGI_PREM', modes.nom, 'RESU_DYNA', 'F')
        matrrigi = self.get_concept(nom_matrrigi)
        if AsType(matrrigi).__name__ == 'matr_asse_depl_r':
            lmatphys = True

        if lmatphys:
            norme_mode = None
            if args['NORM_MODE'] != None:
                norme_mode = args['NORM_MODE']
            filtre_mode = None
            if args['FILTRE_MODE'] != None:
                filtre_mode = args['FILTRE_MODE']
            impression = None
            if args['IMPRESSION'] != None:
                impression = args['IMPRESSION']
            if (norme_mode != None) or (filtre_mode != None) or (impression != None):
                modes = calc_modes_post(self, modes, lmatphys, norme_mode, filtre_mode, impression)


    return ier
