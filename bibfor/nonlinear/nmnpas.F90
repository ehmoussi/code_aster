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
!
subroutine nmnpas(mesh          , model          , cara_elem,&
                  list_func_acti, list_load      ,&
                  ds_material   , ds_constitutive,&
                  ds_measure    , ds_print       ,&
                  sddisc        , nume_inst      ,&
                  sdsuiv        , sddyna         ,&
                  ds_contact    , ds_conv        ,&
                  sdnume        , nume_dof       , solver   ,&
                  hval_incr     , hval_algo )
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/isnnem.h"
#include "asterc/r8vide.h"
#include "asterfort/copisd.h"
#include "asterfort/dismoi.h"
#include "asterfort/initia.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/cldual_maj.h"
#include "asterfort/cont_init.h"
#include "asterfort/ndnpas.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmimin.h"
#include "asterfort/nmnkft.h"
#include "asterfort/nmvcle.h"
#include "asterfort/SetResi.h"
#include "asterfort/nonlinDSMaterialTimeStep.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
character(len=8) :: mesh
character(len=24), intent(in) :: model, cara_elem
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: list_load
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Print), intent(inout) :: ds_print
character(len=19), intent(in) :: sddisc
integer, intent(in) :: nume_inst
character(len=24), intent(in) :: sdsuiv
character(len=19), intent(in) :: sddyna
type(NL_DS_Contact), intent(inout) :: ds_contact
type(NL_DS_Conv), intent(inout) :: ds_conv
character(len=19), intent(in) :: sdnume, solver
character(len=24), intent(in)  :: nume_dof
character(len=19), intent(in) :: hval_algo(*), hval_incr(*)
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Updates for new time step
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  list_func_acti   : list of active functionnalities
! In  list_load        : name of datastructure for list of loads
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_measure       : datastructure for measure and statistics management
! IO  ds_print         : datastructure for printing parameters
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! In  sdsuiv           : datastructure for DOF monitoring
! In  sddyna           : datastructure for dynamic
! IO  ds_contact       : datastructure for contact management
! IO  ds_conv          : datastructure for convergence management
! In  sdnume           : datastructure for dof positions
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  solver           : datastructure for solver parameters
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: lgrot, ldyna, lnkry
    aster_logical :: l_cont, l_diri_undead
    integer :: neq, ifm, niv
    character(len=19) :: depmoi, varmoi
    character(len=19) :: depplu, varplu
    character(len=19) :: depdel
    integer :: jdepde, indro
    real(kind=8), pointer :: depp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_30')
    endif
    call dismoi('NB_EQUA', nume_dof, 'NUME_DDL', repi=neq)
!
! - Active functionnalites
!
    ldyna         = ndynlo(sddyna,'DYNAMIQUE')
    l_cont        = isfonc(list_func_acti,'CONTACT')
    lgrot         = isfonc(list_func_acti,'GD_ROTA')
    lnkry         = isfonc(list_func_acti,'NEWTON_KRYLOV')
    l_diri_undead = isfonc(list_func_acti,'DIRI_UNDEAD')
!
! --- POUTRES EN GRANDES ROTATIONS
!
    if (lgrot) then
        call jeveuo(sdnume(1:19)//'.NDRO', 'L', indro)
    else
        indro = isnnem()
    endif
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(hval_incr, 'VALINC', 'DEPMOI', depmoi)
    call nmchex(hval_incr, 'VALINC', 'VARMOI', varmoi)
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', depplu)
    call nmchex(hval_incr, 'VALINC', 'VARPLU', varplu)
    call nmchex(hval_algo, 'SOLALG', 'DEPDEL', depdel)
!
! --- ESTIMATIONS INITIALES DES VARIABLES INTERNES
!
    call copisd('CHAMP_GD', 'V', varmoi, varplu)
!
! --- INITIALISATION DES DEPLACEMENTS
!
    call copisd('CHAMP_GD', 'V', depmoi, depplu)
!
! - Initializations of residuals
!
    call SetResi(ds_conv, vale_calc_ = r8vide())
!
! --- INITIALISATION DE L'INCREMENT DE DEPLACEMENT DEPDEL
!
    call jeveuo(depdel//'.VALE', 'E', jdepde)
    call jeveuo(depplu//'.VALE', 'L', vr=depp)
    call initia(neq, lgrot, zi(indro), depp, zr(jdepde))
!
! - Update dualized relations for non-linear Dirichlet boundary conditions (undead)
!
    if (l_diri_undead) then
        call cldual_maj(list_load, depmoi)
    endif
!
! --- INITIALISATIONS EN DYNAMIQUE
!
    if (ldyna) then
        call ndnpas(list_func_acti, nume_dof, nume_inst, sddisc, sddyna,&
                    hval_incr, hval_algo)
    endif
!
! --- NEWTON-KRYLOV : COPIE DANS LA SD SOLVEUR DE LA PRECISION DE LA
!                     RESOLUTION POUR LA PREDICTION (FORCING-TERM)
    if (lnkry) then
        call nmnkft(solver, sddisc)
    endif
!
! - Initializations of contact for current time step
!
    if (l_cont) then
        call cont_init(mesh  , model, ds_contact, nume_inst, ds_measure,&
                       sddyna, hval_incr, sdnume    , list_func_acti)
    endif
!
! - Print management - Initializations for new step time
!
    call nmimin(list_func_acti, sddisc, sdsuiv, nume_inst, ds_print)
!
! - Update material parameters for new time step
!
    call nonlinDSMaterialTimeStep(model          , ds_material, cara_elem,&
                                  ds_constitutive, hval_incr  ,&
                                  nume_dof       , sddisc     , nume_inst)
!
end subroutine
