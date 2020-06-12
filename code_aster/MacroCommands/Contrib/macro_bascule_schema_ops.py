# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

import copy

import aster
from ...Messages import UTMESS, MasquerAlarme, RetablirAlarme

from ...Cata.Syntax import _F
from ...Commands import CREA_CHAMP, DEFI_LIST_REEL, DYNA_NON_LINE


def macro_bascule_schema_ops(self, **args):

    args = _F(args)
    # On importe les definitions des commandes a utiliser dans la macro
    #

    CARA_ELEM = args.get("CARA_ELEM")
    MODELE = args.get("MODELE")
    CHAM_MATER = args.get("CHAM_MATER")
    SCHEMA_INIT = args.get("SCHEMA_INIT")

    motscles = {}
    motscles['MODELE'] = MODELE
    motscles['CHAM_MATER'] = CHAM_MATER
    if CARA_ELEM is not None:
        motscles['CARA_ELEM'] = CARA_ELEM

    #
    dexct = args.get("EXCIT")
    #
    dComp_incri = args.get("COMPORTEMENT_IMPL")
    #
    dComp_incre = args.get("COMPORTEMENT_EXPL")
    #
    dincri = [args.get("INCR_IMPL")]
    #
    dincre = [args.get("INCR_EXPL")]
    #
    dschi = args.get("SCHEMA_TEMPS_IMPL")
    #
    dsche = args.get("SCHEMA_TEMPS_EXPL")
    #
    dscheq = [args.get("SCHEMA_TEMPS_EQUI")]
    #
    dnew = args.get("NEWTON")
    #
    dconv = args.get("CONVERGENCE")
    #
    dini = args.get("ETAT_INIT")
    #
    dequi = [args.get("EQUILIBRAGE")]
    #
    dsolv = args.get("SOLVEUR")
    #
    dobs = args.get("OBSERVATION")
    #
    darch = args.get("ARCHIVAGE")
    #
    dener = args.get("ENERGIE")

    __L0 = args.get("LIST_INST_BASCULE").getValues()

    dincri1 = dincri
    dincri1[-1]['INST_FIN'] = __L0[0]
    #
    __dtimp = dequi[-1]['PAS_IMPL']
    __dtexp = dequi[-1]['PAS_EXPL']
    #
    __non_lin = 'NON'
    for comp in dComp_incri:
        if (comp['RELATION'] != 'DIS_CHOC' and comp['RELATION'] != 'ELAS'):
            __non_lin = 'OUI'
            break
    #
    #

    # alarme de DYNA_NON_LINE si les mot-cles de COMPORTEMENT sont renseignes
    # a tort
    MasquerAlarme('COMPOR4_70')

    if SCHEMA_INIT == 'IMPLICITE':
        dincri1 = dincri
        dincri1[-1]['INST_FIN'] = __L0[0]
        nomres = DYNA_NON_LINE(EXCIT=dexct,
                               COMPORTEMENT=dComp_incri,
                               INCREMENT=dincri1,
                               SCHEMA_TEMPS=dschi,
                               NEWTON=dnew, CONVERGENCE=dconv,
                               SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                               ETAT_INIT=dini, **motscles)
        __prc = 'IMPLICITE'
    #
    if SCHEMA_INIT == 'EXPLICITE':
        dincre1 = dincre
        dincre1[-1]['INST_FIN'] = __L0[0]
        nomres = DYNA_NON_LINE(MASS_DIAG='OUI',
                               EXCIT=dexct,
                               COMPORTEMENT=dComp_incre,
                               INCREMENT=dincre1,
                               SCHEMA_TEMPS=dsche,
                               NEWTON=dnew, CONVERGENCE=dconv,
                               SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                               ETAT_INIT=dini, **motscles)

        __prc = 'EXPLICITE'

  #
    __nb = len(__L0)
    j = 1
    while 1:
        #
        if __prc == 'IMPLICITE':
            __Ue = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='DEPL', INST=__L0[j - 1],)
            #
            __Ve = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='VITE', INST=__L0[j - 1],)
            #
            __Ae = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='ACCE', INST=__L0[j - 1],)
            #
            __Ce = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='ELGA_SIEF_R', NOM_CHAM='SIEF_ELGA', INST=__L0[j - 1],)
            #
            __Vae = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='ELGA_VARI_R', NOM_CHAM='VARI_ELGA', INST=__L0[j - 1],)
            dincre1 = dincre
            dincre1[-1]['INST_INIT'] = __L0[j - 1]
            if (j < __nb):
                dincre1[-1]['INST_FIN'] = __L0[j]
            else:
                if 'INST_FIN' in dincre1[-1]:
                    del dincre1[-1]['INST_FIN']

            nomres = DYNA_NON_LINE(reuse=nomres,
                                   EXCIT=dexct,
                                   ETAT_INIT=_F(
                                       DEPL=__Ue, VITE=__Ve, ACCE=__Ae,
                                   SIGM=__Ce, VARI=__Vae,),
                                   COMPORTEMENT=dComp_incre,
                                   INCREMENT=dincre1,
                                   SCHEMA_TEMPS=dsche,
                                   SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                                   NEWTON=dnew, CONVERGENCE=dconv, **motscles)
            #
            __prc = 'EXPLICITE'
            bool = (j != (__nb))
            if (not bool):
                break
            j = j + 1
            #
        if __prc == 'EXPLICITE':
            # calcul sur la zone de recouvrement
            print('Calcul d''une solution explicite stabilisée')
            __U1 = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='DEPL', INST=__L0[j - 1],)
            #
            __V1 = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='VITE', INST=__L0[j - 1],)
            #
            __A1 = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='ACCE', INST=__L0[j - 1],)
            #
            __C1 = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='ELGA_SIEF_R', NOM_CHAM='SIEF_ELGA', INST=__L0[j - 1],)
            #
            __Va1 = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='ELGA_VARI_R', NOM_CHAM='VARI_ELGA', INST=__L0[j - 1],)
            #
            __lrec = DEFI_LIST_REEL(DEBUT=__L0[j - 1],
                                    INTERVALLE=_F(
                                    JUSQU_A=(__L0[j - 1]) + (10 * (__dtexp)),
                                    PAS=__dtexp),)
            schema_equi = dscheq[-1]['SCHEMA']
            if (schema_equi == 'TCHAMWA') or (schema_equi == 'DIFF_CENT'):
                masse_diago = 'OUI'
            else:
                masse_diago = 'NON'
            __u_rec = DYNA_NON_LINE(MASS_DIAG=masse_diago,
                                    EXCIT=dexct,
                                    ETAT_INIT=_F(
                                        DEPL=__U1, VITE=__V1, ACCE=__A1,
                                    SIGM=__C1, VARI=__Va1,),
                                    COMPORTEMENT=dComp_incre,
                                    INCREMENT=_F(LIST_INST=__lrec,
                                                 INST_INIT=__L0[j - 1],
                                                 INST_FIN=(
                                                 __L0[j - 1]) + (
                                                 10 * (__dtexp))),
                                    SCHEMA_TEMPS=dscheq,
                                    SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                                    NEWTON=dnew, CONVERGENCE=dconv, **motscles)
            #
            __Ui = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=__u_rec,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='DEPL',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Vi = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=__u_rec,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='VITE',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Ai = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=__u_rec,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='ACCE',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            # equilibrage du premier pas implicite
            print('Equilibrage du pas explicite stabilisée')
            dincri1 = dincri
            dincri1[-1]['INST_FIN'] = ((__L0[j - 1]) + (10 * (__dtexp)))
            dincri1[-1]['INST_INIT'] = (__L0[j - 1])
            nomres = DYNA_NON_LINE(reuse=nomres,
                                   EXCIT=dexct,
                                   ETAT_INIT=_F(
                                       DEPL=__Ui, VITE=__Vi, ACCE=__Ai,
                                   SIGM=__C1, VARI=__Va1,),
                                   COMPORTEMENT=dComp_incri,
                                   INCREMENT=dincri1,
                                   SCHEMA_TEMPS=dschi,
                                   SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                                   NEWTON=dnew, CONVERGENCE=dconv, **motscles)
            #
            __Ui = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='DEPL',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Vi = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='VITE',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Ai = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='ACCE',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Ci = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=nomres,
                TYPE_CHAM='ELGA_SIEF_R', NOM_CHAM='SIEF_ELGA', INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Vai = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=nomres,
                TYPE_CHAM='ELGA_VARI_R', NOM_CHAM='VARI_ELGA', INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            print('Calcul implicite après équilibrage')
            dincri1 = dincri
            dincri1[-1]['INST_INIT'] = ((__L0[j - 1]) + (10 * (__dtexp)))
            if (j < __nb):
                dincri1[-1]['INST_FIN'] = __L0[j]
            else:
                del dincri1[-1]['INST_FIN']
            nomres = DYNA_NON_LINE(reuse=nomres,
                                   EXCIT=dexct,
                                   ETAT_INIT=_F(
                                       DEPL=__Ui, VITE=__Vi, ACCE=__Ai,
                                   SIGM=__Ci, VARI=__Vai,
                                   ),
                                   COMPORTEMENT=dComp_incri,
                                   INCREMENT=dincri1,
                                   SCHEMA_TEMPS=dschi,
                                   SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                                   NEWTON=dnew, CONVERGENCE=dconv, **motscles)
            #
            __prc = 'IMPLICITE'
            bool = (j != (__nb))
            if (not bool):
                break
            j = j + 1
    #
    RetablirAlarme('COMPOR4_70')
    return nomres
