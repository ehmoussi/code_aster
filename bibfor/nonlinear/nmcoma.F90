! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine nmcoma(mesh          , modelz         , ds_material,&
                  cara_elem     , ds_constitutive, ds_algopara,&
                  lischa        , numedd         , numfix     ,&
                  solveu        , ds_system      , sddisc     ,&
                  sddyna        , ds_print       , ds_measure ,&
                  ds_algorom    , nume_inst      , iter_newt  ,&
                  list_func_acti, ds_contact     , hval_incr  ,&
                  hval_algo     , hhoField       , meelem     , measse,&
                  maprec        , matass         , faccvg     ,&
                  ldccvg        , sdnume)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
use HHO_type
use HHO_comb_module, only : hhoPrepMatrix
use NonLinear_module, only : getOption, getMatrType, isMatrUpdate,&
                             isDampMatrCompute, isMassMatrCompute,&
                             isRigiMatrCompute, isInteVectCompute
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/NonLinear_type.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmelcm.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmcmat.h"
#include "asterfort/nmfint.h"
#include "asterfort/nmimck.h"
#include "asterfort/nmmatr.h"
#include "asterfort/nmrenu.h"
#include "asterfort/nmxmat.h"
#include "asterfort/romAlgoNLCorrEFMatrixModify.h"
#include "asterfort/asmari.h"
#include "asterfort/nmrigi.h"
#include "asterfort/utmess.h"
#include "asterfort/mtdscr.h"
#include "asterfort/nmaint.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmtime.h"
#include "asterfort/preres.h"
!
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
character(len=*) :: modelz
character(len=8), intent(in) :: mesh
character(len=24) :: cara_elem
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24) :: numedd, numfix
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_System), intent(in) :: ds_system
character(len=19) :: sddisc, sddyna, lischa, solveu, sdnume
type(NL_DS_Print), intent(inout) :: ds_print
character(len=19) :: meelem(*)
character(len=19) :: hval_algo(*), hval_incr(*)
character(len=19) :: measse(*)
type(HHO_Field), intent(in) :: hhoField
integer, intent(in) :: list_func_acti(*), nume_inst, iter_newt
type(NL_DS_Contact), intent(inout) :: ds_contact
character(len=19) :: maprec, matass
integer :: faccvg, ldccvg
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! CALCUL DE LA MATRICE GLOBALE EN CORRECTION
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : MODELE
! IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
! IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  LISCHA : LISTE DES CHARGES
! IO  ds_contact       : datastructure for contact management
! IN  SDDYNA : SD POUR LA DYNAMIQUE
! In  ds_algopara      : datastructure for algorithm parameters
! IN  SOLVEU : SOLVEUR
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IO  ds_print         : datastructure for printing parameters
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_algorom       : datastructure for ROM parameters
! In  ds_system        : datastructure for non-linear system management
! In  list_func_acti   : list of active functionnalities
! In  nume_inst        : index of current time step
! In  iter_newt        : index of current Newton iteration
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! In  hhoField         : datastructure for HHO
! IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
! IN  MEELEM : VARIABLE CHAPEAU POUR NOM DES MATR_ELEM
! OUT LFINT  : .TRUE. SI FORCES INTERNES CALCULEES
! OUT MATASS : MATRICE DE RESOLUTION ASSEMBLEE
! OUT MAPREC : MATRICE DE RESOLUTION ASSEMBLEE - PRECONDITIONNEMENT
! OUT FACCVG : CODE RETOUR FACTORISATION MATRICE GLOBALE
!                -1 : PAS DE FACTORISATION
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : MATRICE SINGULIERE
!                 2 : ERREUR LORS DE LA FACTORISATION
!                 3 : ON NE SAIT PAS SI SINGULIERE
! OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 2 : ERREUR SUR LA NON VERIF. DE CRITERES PHYSIQUES
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_update_matr, l_comp_damp, l_diri_undead, l_rom, l_comp_mass
    aster_logical :: l_neum_undead, l_comp_fint, l_asse_rigi, l_hho, l_comp_rigi, l_comp_cont
    character(len=16) :: corrMatrType, option_nonlin
    character(len=19) :: matr_elem, rigid
    character(len=24) :: model
    aster_logical :: l_renumber
    integer :: ifm, niv
    integer :: nb_matr, ibid, reac_iter
    integer :: condcvg
    character(len=6) :: list_matr_type(20)
    character(len=16) :: list_calc_opti(20), list_asse_opti(20)
    aster_logical :: list_l_asse(20), list_l_calc(20)
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_68')
    endif
!
! - Initializations
!
    call nmchex(measse, 'MEASSE', 'MERIGI', rigid)
    nb_matr              = 0
    list_matr_type(1:20) = ' '
    model = modelz
    faccvg  = -1
    ldccvg  = -1
    condcvg = -1
!
! - Active functionnalites
!
    l_neum_undead = isfonc(list_func_acti, 'NEUM_UNDEAD')
    l_diri_undead = isfonc(list_func_acti, 'DIRI_UNDEAD')
    l_rom         = isfonc(list_func_acti, 'ROM')
    l_hho         = isfonc(list_func_acti, 'HHO')
    l_comp_cont   = isfonc(list_func_acti, 'ELT_CONTACT')
!
! - Renumbering equations ?
!
    call nmrenu(modelz    , list_func_acti, lischa,&
                ds_measure, ds_contact    , numedd,&
                l_renumber)
!
! - Get type of matrix
!
    call getMatrType(CORR_NEWTON , list_func_acti, sddisc, nume_inst, ds_algopara,&
                     corrMatrType, reac_iter_ = reac_iter)
!
! - Update global matrix ?
!
    call isMatrUpdate(CORR_NEWTON  , corrMatrType, list_func_acti,&
                      ds_contact   , sddyna      ,&
                      l_update_matr,&
                      iter_newt_ = iter_newt, reac_iter_ = reac_iter)
!
! - Select non-linear option for compute matrices
!
    call getOption(CORR_NEWTON, list_func_acti, corrMatrType, option_nonlin, l_update_matr)
!
! - Do the damping matrices have to be calculated ?
!
    call isDampMatrCompute(sddyna, l_renumber, l_comp_damp)
!
! - Do the mass matrices have to be calculated ?
!
    call isMassMatrCompute(sddyna, l_update_matr, l_comp_mass)
!
! - Do the rigidity matrices have to be calculated/assembled ?
!
    call isRigiMatrCompute(CORR_NEWTON  , list_func_acti,&
                           sddyna       , nume_inst     ,&
                           l_update_matr, l_comp_damp   ,&
                           l_comp_rigi  , l_asse_rigi)
!
! - Do the internal forces vectors have to be calculated ?
!
    call isInteVectCompute(CORR_NEWTON  , list_func_acti,&
                           option_nonlin, iter_newt     ,&
                           l_comp_rigi  , l_comp_fint)
!
! - Compute internal forces elementary vectors
!
    if (l_comp_fint) then
        call nmfint(model         , cara_elem      ,&
                    ds_material   , ds_constitutive,&
                    list_func_acti, iter_newt      , ds_measure, ds_system,&
                    hval_incr     , hval_algo      , hhoField,&
                    ldccvg        , sddyna)
    endif
!
! - No error => continue
!
    if (ldccvg .ne. 1) then
! ----- Assemble internal forces
        if (l_comp_fint) then
            call nmaint(numedd, list_func_acti, sdnume, ds_system)
        endif
! ----- Compute contact elementary matrices
        if (l_comp_cont) then
            call nmchex(meelem, 'MEELEM', 'MEELTC', matr_elem)
            call nmelcm(mesh           , model     ,&
                        ds_material    , ds_contact,&
                        ds_constitutive, ds_measure,&
                        hval_incr      , hval_algo ,&
                        matr_elem)
        endif
! ----- Update dualized matrix for non-linear Dirichlet boundary conditions (undead)
        if (l_neum_undead) then
            call nmcmat('MESUIV', ' ', ' ', ASTER_TRUE,&
                        ASTER_FALSE, nb_matr, list_matr_type, list_calc_opti, list_asse_opti,&
                        list_l_calc, list_l_asse)
        endif
! ----- Assembly rigidity matrix
        if (l_asse_rigi) then
            call asmari(ds_system, meelem, lischa, rigid)
        endif
! ----- Compute damping (Rayleigh) elementary matrices
        if (l_comp_damp) then
            call nmcmat('MEAMOR', 'AMOR_MECA', ' ', ASTER_TRUE,&
                        ASTER_TRUE, nb_matr, list_matr_type, list_calc_opti, list_asse_opti,&
                        list_l_calc, list_l_asse)
        endif
! ----- Update dualized relations for non-linear Dirichlet boundary conditions (undead)
        if (l_diri_undead) then
            call nmcmat('MEDIRI', ' ', ' ', ASTER_TRUE,&
                        ASTER_FALSE, nb_matr, list_matr_type, list_calc_opti, list_asse_opti,&
                        list_l_calc, list_l_asse)
        endif
! ----- Compute mass elementary matrices
        if (l_comp_mass) then
            call nmcmat('MEMASS', ' ', ' ', ASTER_FALSE,&
                        ASTER_TRUE, nb_matr, list_matr_type, list_calc_opti, list_asse_opti,&
                        list_l_calc, list_l_asse)
            ASSERT(l_update_matr)
        endif
! ----- For HHO: assembly rigidity and condensation
        if (l_hho) then
            call hhoPrepMatrix(modelz, ds_material%mater, ds_material%mateco,&
                               ds_system%merigi, ds_system%vefint, rigid,&
                               hhoField, meelem, lischa,&
                               ds_system, ds_measure, condcvg,&
                               l_cond = ASTER_FALSE, l_asse = ASTER_TRUE)
        endif
! ----- Compute and assemble matrices
        if (nb_matr .gt. 0) then
            call nmxmat(modelz         , ds_material   , cara_elem     ,&
                        ds_constitutive, sddisc        , nume_inst     ,&
                        hval_incr      , hval_algo     , lischa        ,&
                        numedd         , numfix        , ds_measure    ,&
                        nb_matr        , list_matr_type, list_calc_opti,&
                        list_asse_opti , list_l_calc   , list_l_asse   ,&
                        meelem         , measse        , ds_system)
        endif
! ----- Compute global matrix of system
        if (l_update_matr) then
            call nmmatr('CORRECTION', list_func_acti, lischa, numedd, sddyna,&
                        nume_inst   , ds_contact    , meelem, measse, matass)
        endif
! ----- Set matrix type in convergence table
        if (l_update_matr) then
            call nmimck(ds_print, 'MATR_ASSE', corrMatrType, ASTER_TRUE)
        else
            call nmimck(ds_print, 'MATR_ASSE', corrMatrType, ASTER_FALSE)
        endif
! ----- Factorization of global matrix of system
        if (l_update_matr) then
            call nmtime(ds_measure, 'Init', 'Factor')
            call nmtime(ds_measure, 'Launch', 'Factor')
            if (l_rom .and. ds_algorom%phase .eq. 'HROM') then
                call mtdscr(matass)
            elseif (l_rom .and. ds_algorom%phase .eq. 'CORR_EF') then
                call mtdscr(matass)
                call romAlgoNLCorrEFMatrixModify(numedd, matass, ds_algorom)
                call preres(solveu, 'V', faccvg, maprec, matass, ibid, -9999)
            else
                call preres(solveu, 'V', faccvg, maprec, matass, ibid, -9999)
            endif
            call nmtime(ds_measure, 'Stop', 'Factor')
            call nmrinc(ds_measure, 'Factor')
        endif
    endif
!
end subroutine
