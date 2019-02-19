! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nonlinInitDisp.h"
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
    aster_logical :: ldyna, lnkry, l_cont, l_diri_undead
    integer :: ifm, niv
    character(len=19) :: disp_prev, vari_prev, vari_curr
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_30')
    endif
!
! - Active functionnalites
!
    ldyna         = ndynlo(sddyna,'DYNAMIQUE')
    l_cont        = isfonc(list_func_acti,'CONTACT')
    lnkry         = isfonc(list_func_acti,'NEWTON_KRYLOV')
    l_diri_undead = isfonc(list_func_acti,'DIRI_UNDEAD')
!
! - Get hat variables
!
    call nmchex(hval_incr, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(hval_incr, 'VALINC', 'VARMOI', vari_prev)
    call nmchex(hval_incr, 'VALINC', 'VARPLU', vari_curr)
!
! - Update internal state variables for current time step
!
    call copisd('CHAMP_GD', 'V', vari_prev, vari_curr)
!
! - Initializations of residuals for current time step
!
    call SetResi(ds_conv, vale_calc_ = r8vide())
!
! - Initializations of displacements for current time step
!
    call nonlinInitDisp(list_func_acti, sdnume   , nume_dof,&
                        hval_algo     , hval_incr)
!
! - Update dualized relations for non-linear Dirichlet boundary conditions (undead)
!
    if (l_diri_undead) then
        call cldual_maj(list_load, disp_prev)
    endif
!
! - Initializations for dynamic for current time step
!
    if (ldyna) then
        call ndnpas(list_func_acti, nume_dof, nume_inst, sddisc, sddyna,&
                    hval_incr     , hval_algo)
    endif
!
! - Initializations for NEWTON-KRYLOV for current time step
!
    if (lnkry) then
        call nmnkft(solver, sddisc)
    endif
!
! - Initializations of contact for current time step
!
    if (l_cont) then
        call cont_init(mesh  , model    , ds_contact, nume_inst     , ds_measure,&
                       sddyna, hval_incr, sdnume    , list_func_acti)
    endif
!
! - Update material parameters for new time step
!
    call nonlinDSMaterialTimeStep(model          , ds_material, cara_elem,&
                                  ds_constitutive, hval_incr  ,&
                                  nume_dof       , sddisc     , nume_inst)
!
! - Print management - Initializations for new step time
!
    call nmimin(list_func_acti, sddisc, sdsuiv, nume_inst, ds_print)
!
end subroutine
