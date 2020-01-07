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
subroutine nmprma(mesh       , modelz     , ds_material   , carele    , ds_constitutive,&
                  ds_algopara, lischa     , numedd        , numfix    , solveu, ds_system,&
                  ds_print   , ds_measure , ds_algorom    , sddisc    ,&
                  sddyna     , nume_inst  , list_func_acti, ds_contact,&
                  valinc     , solalg     , hhoField      , meelem    , measse,&
                  maprec     , matass     , faccvg        , ldccvg    , condcvg)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
use HHO_type
use HHO_comb_module, only : hhoPrepMatrix
use NonLinear_module, only : getOption, getMatrType, isMatrUpdate,&
                             isDampMatrCompute, isMassMatrCompute, isRigiMatrCompute,&
                             factorSystem
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/NonLinear_type.h"
#include "asterc/r8prem.h"
#include "asterfort/asmari.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisl.h"
#include "asterfort/dismoi.h"
#include "asterfort/echmat.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmcmat.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nmelcm.h"
#include "asterfort/nmimck.h"
#include "asterfort/nmmatr.h"
#include "asterfort/nmrenu.h"
#include "asterfort/nmrigi.h"
#include "asterfort/nmxmat.h"
#include "asterfort/romAlgoNLCorrEFMatrixModify.h"
#include "asterfort/nonlinIntForceAsse.h"
#include "asterfort/sdmpic.h"
#include "asterfort/utmess.h"
!
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
character(len=8), intent(in) :: mesh
character(len=*) :: modelz
character(len=24) :: carele
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Print), intent(inout) :: ds_print
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
type(HHO_Field), intent(in) :: hhoField
character(len=24) :: numedd, numfix
character(len=19) :: sddisc, sddyna, lischa, solveu
character(len=19) :: solalg(*), valinc(*)
character(len=19) :: meelem(*), measse(*)
type(NL_DS_System), intent(in) :: ds_system
integer, intent(in) :: nume_inst, list_func_acti(*)
type(NL_DS_Contact), intent(inout) :: ds_contact
character(len=19) :: maprec, matass
character(len=8) :: partit
aster_logical :: ldist
integer :: faccvg, ldccvg, condcvg
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! CALCUL DE LA MATRICE GLOBALE EN PREDICTION
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : MODELE
! IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
! IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! In  ds_constitutive  : datastructure for constitutive laws management
! In  ds_material      : datastructure for material parameters
! IN  LISCHA : LISTE DES CHARGES
! IO  ds_contact       : datastructure for contact management
! IO  ds_print         : datastructure for printing parameters
! IN  SDDYNA : SD POUR LA DYNAMIQUE
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_algopara      : datastructure for algorithm parameters
! In  list_func_acti   : list of active functionnalities
! In  ds_algorom       : datastructure for ROM parameters
! In  ds_system        : datastructure for non-linear system management
! In  hhoField         : datastructure for HHO
! In  nume_inst        : index of current time step
! IN  SOLVEU : SOLVEUR
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
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
! OUT CONDCVG : CODE RETOUR DE LA CONDENSATION STATIQUE
!                -1 : PAS DE CONDENSATION
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE LA CONDENSATION
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_update_matr, l_renumber
    aster_logical :: l_comp_rigi, l_comp_damp, l_asse_rigi, l_hho, lmhpc
    aster_logical :: l_neum_undead, l_diri_undead, l_rom, l_comp_cont, l_comp_mass
    character(len=16) :: predMatrType, option_nonlin
    character(len=19) :: matr_elem, rigid
    character(len=3) :: mathpc
    integer :: ifm, niv
    integer :: iter_newt
    integer :: nb_matr, reac_incr
    character(len=6) :: list_matr_type(20)
    character(len=16) :: list_calc_opti(20), list_asse_opti(20)
    aster_logical :: list_l_asse(20), list_l_calc(20)
    aster_logical :: l_contact_adapt,l_cont_cont
    real(kind=8) ::  minmat, maxmat, exponent_val
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_35')
    endif
!
! - Initializations
!
    call nmchex(measse, 'MEASSE', 'MERIGI', rigid)
    nb_matr              = 0
    list_matr_type(1:20) = ' '
    faccvg  = -1
    ldccvg  = -1
    condcvg = -1
!
! - Prediction
!
    iter_newt = 0
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
    call getMatrType(PRED_EULER  , list_func_acti, sddisc, nume_inst, ds_algopara,&
                     predMatrType, reac_incr_ = reac_incr)
!
! - Update global matrix ?
!
    call isMatrUpdate(PRED_EULER   , predMatrType, list_func_acti,&
                      sddyna       , ds_system   ,&
                      l_update_matr,&
                      nume_inst_ = nume_inst, reac_incr_ = reac_incr)
!
! - Select non-linear option for compute matrices
!
    call getOption(PRED_EULER, list_func_acti, predMatrType, option_nonlin)
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
    call isRigiMatrCompute(PRED_EULER   , list_func_acti,&
                           sddyna       , nume_inst     ,&
                           l_update_matr, l_comp_damp   ,&
                           l_comp_rigi  , l_asse_rigi)
!
! - Compute contact elementary matrices
!
    if (l_comp_cont) then
        call nmchex(meelem, 'MEELEM', 'MEELTC', matr_elem)
        call nmelcm(mesh       , modelz    ,&
                    ds_material, ds_contact, ds_constitutive, ds_measure,&
                    valinc     , solalg    ,&
                    matr_elem)
    endif
!
! - Compute rigidity elementary matrices / internal forces elementary vectors
!
    if (l_comp_rigi) then
        call nmrigi(modelz        , carele         ,&
                    ds_material   , ds_constitutive,&
                    list_func_acti, iter_newt      , sddyna  , ds_measure, ds_system,&
                    valinc        , solalg         , hhoField, &
                    option_nonlin , ldccvg)
        if (l_asse_rigi) then
            call asmari(ds_system, meelem, lischa, rigid)
        endif
    endif
!
! - Update dualized matrix for non-linear Dirichlet boundary conditions (undead)
!
    if (l_diri_undead .and. (predMatrType.ne.'EXTRAPOLE')) then
        call nmcmat('MEDIRI', ' ', ' ', ASTER_TRUE,&
                    ASTER_FALSE, nb_matr, list_matr_type, list_calc_opti, list_asse_opti,&
                    list_l_calc, list_l_asse)
    endif
!
! - Compute damping (Rayleigh) elementary matrices
!
    if (l_comp_damp) then
        call nmcmat('MEAMOR', 'AMOR_MECA', ' ', ASTER_TRUE,&
                    ASTER_TRUE, nb_matr, list_matr_type, list_calc_opti, list_asse_opti,&
                    list_l_calc, list_l_asse)
    endif
!
! --- CALCUL DES MATR-ELEM DES CHARGEMENTS
!
    if (l_neum_undead .and. (predMatrType.ne.'EXTRAPOLE')) then
        call nmcmat('MESUIV', ' ', ' ', ASTER_TRUE,&
                    ASTER_FALSE, nb_matr, list_matr_type, list_calc_opti, list_asse_opti,&
                    list_l_calc, list_l_asse)
    endif
!
! - Compute mass elementary matrices
!
    if (l_comp_mass) then
        call nmcmat('MEMASS', ' ', ' ', ASTER_FALSE,&
                    ASTER_TRUE, nb_matr, list_matr_type, list_calc_opti, list_asse_opti,&
                    list_l_calc, list_l_asse)
        ASSERT(l_update_matr)
    endif
!
! - For HHO: assembly rigidity and condensation
!
    if (l_hho) then
        call hhoPrepMatrix(modelz    , ds_material, lischa,&
                           ds_system , ds_measure ,&
                           meelem    , hhoField   ,&
                           ASTER_TRUE, ASTER_TRUE ,&
                           rigid     , condcvg)
    endif
!
! --- CALCUL ET ASSEMBLAGE DES MATR_ELEM DE LA LISTE
!
    if (nb_matr .gt. 0) then
        call nmxmat(modelz         , ds_material   , carele        ,&
                    ds_constitutive, sddisc        , nume_inst        ,&
                    valinc         , solalg        , lischa        ,&
                    numedd         , numfix        , ds_measure    ,&
                    nb_matr        , list_matr_type, list_calc_opti,&
                    list_asse_opti , list_l_calc   , list_l_asse   ,&
                    meelem         , measse        , ds_system)
    endif
!
! --- CALCUL DE LA MATRICE ASSEMBLEE GLOBALE
!
    if (l_update_matr) then
        call nmmatr('PREDICTION', list_func_acti    , lischa, numedd, sddyna,&
                    nume_inst      , ds_contact, meelem, measse, matass)
        call nmimck(ds_print, 'MATR_ASSE', predMatrType, ASTER_TRUE)
    else
        call nmimck(ds_print, 'MATR_ASSE', ' '   , ASTER_FALSE)
    endif
    l_cont_cont         = isfonc(list_func_acti,'CONT_CONTINU')
    if (l_cont_cont) then
        minmat=0.0
        maxmat=0.0
        exponent_val=0.0
    !   -- Avant la factorisation et pour le cas ou il y a du contact continu avec adaptation de
    !      coefficient
    !   -- On cherche le coefficient optimal pour eviter une possible singularite de matrice
    !   -- La valeur est estimee une seule fois a la premiere prediction du premier pas de
    !      temps pour l'etape de calcul
    !   -- Cette valeur estimee est passee directement a mmchml_c sans passer par mmalgo car
    !   -- a la premiere iteration on ne passe pas par mmalgo
        l_contact_adapt = cfdisl(ds_contact%sdcont_defi,'EXIS_ADAP')
!            write (6,*) "l_contact_adapt", &
!                l_contact_adapt,ds_contact%update_init_coefficient
        if ((nint(ds_contact%update_init_coefficient) .eq. 0) .and. l_contact_adapt) then
            call dismoi('MATR_HPC', matass, 'MATR_ASSE', repk=mathpc)
            lmhpc = mathpc .eq. 'OUI'
            call dismoi('PARTITION', modelz, 'MODELE', repk=partit)
            ldist = partit .ne. ' '
            call echmat(matass, ldist, lmhpc, minmat, maxmat)
            ds_contact%max_coefficient = maxmat
            if (abs(log(minmat)) .ge. r8prem()) then

                if (abs(log(maxmat))/abs(log(minmat)) .lt. 4.0d0) then
!                     Le rapport d'arete max/min est
!  un bon compromis pour initialiser le coefficient
                    ds_contact%estimated_coefficient =&
                    ((1.D3*ds_contact%arete_max)/(1.D-2*ds_contact%arete_min))
                    ds_contact%update_init_coefficient = 1.0d0
                else
                    exponent_val = min(abs(log(minmat)),abs(log(maxmat)))/10.d0
                    ds_contact%estimated_coefficient = 10.d0**(exponent_val)
                    ds_contact%update_init_coefficient = 1.0d0
                endif
            else
               ds_contact%estimated_coefficient = 1.d16*ds_contact%arete_min
                    ds_contact%update_init_coefficient = 1.0d0
            endif
!             write (6,*) "min,max,coef estime,abs(log(maxmat))/abs(log(minmat))", &
!                 minmat,maxmat,ds_contact%estimated_coefficient,abs(log(maxmat))/abs(log(minmat))
        endif
    endif
!
! - Factorization of global matrix of system
!
    if (l_update_matr) then
        call factorSystem(list_func_acti, ds_measure, ds_algorom,&
                          numedd        , solveu    , maprec    , matass,&
                          faccvg)
    endif
!
end subroutine
