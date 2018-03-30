! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
! person_in_charge: mickael.abbas at edf.fr
! aslint: disable=W1504
!
subroutine nmprta(model          , nume_dof , numfix     , ds_material, cara_elem,&
                  ds_constitutive, list_load, ds_algopara, solveu     ,&
                  list_func_acti , ds_print , ds_measure , ds_algorom , sddisc,&
                  nume_inst      , hval_incr, hval_algo  , matass     , maprec,&
                  ds_contact     , sddyna   , hval_meelem, hval_measse, hval_veelem,&
                  hval_veasse    , sdnume   , ldccvg     , faccvg,&
                  rescvg    )
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/diinst.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmassp.h"
#include "asterfort/nmforc_pred.h"
#include "asterfort/nmfint_pred.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdep0.h"
#include "asterfort/nmfocc.h"
#include "asterfort/nmprma.h"
#include "asterfort/nmresd.h"
#include "asterfort/vtzero.h"
!
integer :: list_func_acti(*)
integer :: nume_inst, faccvg, rescvg, ldccvg
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
type(NL_DS_Measure), intent(inout) :: ds_measure
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
type(NL_DS_Print), intent(inout) :: ds_print
type(NL_DS_Material), intent(in) :: ds_material
character(len=19) :: matass, maprec
character(len=19) :: list_load, solveu, sddisc, sddyna, sdnume
character(len=24) :: model, cara_elem
character(len=24) :: nume_dof, numfix
character(len=19) :: hval_algo(*), hval_incr(*)
type(NL_DS_Contact), intent(inout) :: ds_contact
character(len=19) :: hval_veelem(*), hval_veasse(*)
character(len=19) :: hval_meelem(*), hval_measse(*)
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PREDICTION)
!
! PREDICTION PAR METHODE DE NEWTON-EULER
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  list_load        : name of datastructure for list of loads
! IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! In  ds_algopara      : datastructure for algorithm parameters
! IN  SOLVEU : SOLVEUR
! IO  ds_print         : datastructure for printing parameters
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_algorom       : datastructure for ROM parameters
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  hval_meelem      : hat-variable for elementary matrix
! In  hval_measse      : hat-variable for matrix
! In  sddyna           : datastructure for dynamic
! IO  ds_contact       : datastructure for contact management
! IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
! IN  MAPREC : NOM DE LA MATRICE DE PRECONDITIONNEMENT (GCPC)
! IN  SDNUME : SD NUMEROTATION
! OUT FACCVG : CODE RETOUR FACTORISATION MATRICE GLOBALE
!                -1 : PAS DE FACTORISATION
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : MATRICE SINGULIERE
!                 2 : ERREUR LORS DE LA FACTORISATION
!                 3 : ON NE SAIT PAS SI SINGULIERE
! OUT RESCVG : CODE RETOUR RESOLUTION SYSTEME LINEAIRE
!                -1 : PAS DE RESOLUTION
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : NOMBRE MAXIMUM D'ITERATIONS ATTEINT
! OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 2 : ERREUR SUR LA NON VERIF. DE CRITERES PHYSIQUES
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iter_newt
    real(kind=8) :: time_prev, time_curr
    character(len=19) :: cncine, cndonn, cnpilo
    aster_logical :: leltc
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> PREDICTION TYPE EULER'
    endif
!
! - Active functionnalities
!
    leltc = isfonc(list_func_acti,'ELT_CONTACT')
!
! --- INITIALISATIONS
!
    ldccvg = -1
    faccvg = -1
    rescvg = -1
    cndonn = '&&CNCHAR.DONN'
    cnpilo = '&&CNCHAR.PILO'
    call vtzero(cndonn)
    call vtzero(cnpilo)
!
! - Get time
!
    ASSERT(nume_inst .gt. 0)
    time_prev = diinst(sddisc,nume_inst-1)
    time_curr = diinst(sddisc,nume_inst)
    iter_newt = 0
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(hval_veasse, 'VEASSE', 'CNCINE', cncine)
!
! --- INCREMENT DE DEPLACEMENT NUL EN PREDICTION
!
    call nmdep0('ON ', hval_algo)
!
! --- CALCUL DE LA MATRICE GLOBALE
!
    call nmprma(model      , ds_material, cara_elem, ds_constitutive,&
                ds_algopara, list_load  , nume_dof, numfix, solveu,&
                ds_print   , ds_measure , ds_algorom, sddisc,&
                sddyna     , nume_inst  , list_func_acti, ds_contact,&
                hval_incr  , hval_algo  , hval_veelem, hval_meelem, hval_measse,&
                maprec     , matass     , faccvg, ldccvg)
!
! --- ERREUR SANS POSSIBILITE DE CONTINUER
!
    if ((faccvg.eq.1) .or. (faccvg.eq.2)) goto 999
    if (ldccvg .eq. 1) goto 999
!
! - Compute forces for second member at prediction
!
    call nmforc_pred(list_func_acti,&
                     model         , cara_elem      ,&
                     nume_dof      , matass         ,&
                     list_load     , sddyna         ,&
                     ds_material   , ds_constitutive,&
                     ds_measure    , ds_algopara    ,&
                     sddisc        , nume_inst      ,&
                     hval_incr     , hval_algo      ,&
                     hval_veelem   , hval_veasse    ,&
                     hval_measse)
!
! --- CALCUL DU SECOND MEMBRE POUR CONTACT/XFEM
!
    if (leltc) then
        call nmfocc('PREDICTION', model     , ds_material, nume_dof , list_func_acti ,&
                    ds_contact  , ds_measure, hval_algo  , hval_incr, ds_constitutive)
    endif
!
! - Compute internal forces at prediction
!
    call nmfint_pred(model      , cara_elem      , list_func_acti, &
                     sddyna     , nume_dof       , &
                     ds_material, ds_constitutive, ds_measure    ,&
                     time_prev  , time_curr      , iter_newt     ,&
                     hval_incr  , hval_algo      ,&
                     hval_veelem, hval_veasse    ,&
                     ldccvg     , sdnume)
    if (ldccvg .eq. 1) then
        goto 999
    endif
!
! - Evaluate second member for prediction
!
    call nmassp(ds_material   , list_func_acti,&
                ds_algorom    , sddyna        ,&
                ds_contact    , hval_veasse   ,&
                cnpilo        , cndonn)
!
! --- INCREMENT DE DEPLACEMENT NUL EN PREDICTION
!
    call nmdep0('OFF', hval_algo)
!
! --- RESOLUTION K.DU = DF
!
    call nmresd(list_func_acti, sddyna   , ds_measure, solveu    , nume_dof,&
                time_curr     , maprec   , matass    , cndonn    , cnpilo  ,&
                cncine        , hval_algo, rescvg    , ds_algorom)
!
999 continue
!
end subroutine
