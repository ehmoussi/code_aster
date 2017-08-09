! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
module THM_module
!
use THM_type
!
implicit none
!
private :: r8nnem
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/THM_type.h"
!
! --------------------------------------------------------------------------------------------------
!
! THM - Define module
!
! --------------------------------------------------------------------------------------------------
!
type THM_DS
    type(THM_ParaInit)  :: ds_parainit
    type(THM_Behaviour) :: ds_behaviour
    type(THM_Element)   :: ds_elem
    type(THM_Material)  :: ds_material
end type THM_DS

! Main variable    
type(THM_DS), public :: ds_thm

! Init all variables
public :: thmModuleInit

contains
!
subroutine thmModuleInit()
!   Initial parameters
    ds_thm%ds_parainit%temp_init = 0.d0
    ds_thm%ds_parainit%pre1_init = 0.d0
    ds_thm%ds_parainit%pre2_init = 0.d0
    ds_thm%ds_parainit%poro_init = 0.d0
    ds_thm%ds_parainit%prev_init = 0.d0
!   Behaviour
    ds_thm%ds_behaviour%rela_thmc     = ' '
    ds_thm%ds_behaviour%rela_meca     = ' '
    ds_thm%ds_behaviour%rela_ther     = ' '
    ds_thm%ds_behaviour%rela_hydr     = ' '
    ds_thm%ds_behaviour%l_temp        = .false.
    ds_thm%ds_behaviour%nb_pres       = 0
    ds_thm%ds_behaviour%nb_phase(1:2) = 0
    ds_thm%ds_behaviour%satur_type    = SATURATED
!   Type of FE: which dof on element ?
    ds_thm%ds_elem%l_dof_ther      = .false.
    ds_thm%ds_elem%l_dof_meca      = .false.
    ds_thm%ds_elem%l_dof_hydr1     = .false.
    ds_thm%ds_elem%l_dof_hydr2     = .false.
    ds_thm%ds_elem%nb_phase(1:2)   = 0
    ds_thm%ds_elem%l_weak_coupling = .false.
!   Material parameters (porosity)
    ds_thm%ds_material%biot%type    = BIOT_TYPE_ISOT
    ds_thm%ds_material%biot%coef    = r8nnem()
    ds_thm%ds_material%biot%l       = r8nnem()
    ds_thm%ds_material%biot%t       = r8nnem()
    ds_thm%ds_material%biot%n       = r8nnem()
!   Material parameters (elasticity)
    ds_thm%ds_material%elas%id           = 0
    ds_thm%ds_material%elas%keyword      = ' '
    ds_thm%ds_material%elas%e            = r8nnem()
    ds_thm%ds_material%elas%nu           = r8nnem()
    ds_thm%ds_material%elas%g            = r8nnem()
    ds_thm%ds_material%elas%e_l          = r8nnem()
    ds_thm%ds_material%elas%e_t          = r8nnem()
    ds_thm%ds_material%elas%e_n          = r8nnem()
    ds_thm%ds_material%elas%nu_lt        = r8nnem()
    ds_thm%ds_material%elas%nu_ln        = r8nnem()
    ds_thm%ds_material%elas%nu_tn        = r8nnem()
    ds_thm%ds_material%elas%g_lt         = r8nnem()
    ds_thm%ds_material%elas%g_ln         = r8nnem()
    ds_thm%ds_material%elas%g_tn         = r8nnem()
    ds_thm%ds_material%elas%d(:,:)       = r8nnem()
!   Material parameters (thermic)
    ds_thm%ds_material%ther%alpha        = r8nnem()
    ds_thm%ds_material%ther%alpha_l      = r8nnem()
    ds_thm%ds_material%ther%alpha_t      = r8nnem()
    ds_thm%ds_material%ther%alpha_n      = r8nnem()
!   Material parameters (hydraulic)
    ds_thm%ds_material%hydr%n            = r8nnem()
    ds_thm%ds_material%hydr%pr           = r8nnem()
    ds_thm%ds_material%hydr%sr           = r8nnem()
    ds_thm%ds_material%hydr%smax         = r8nnem()
    ds_thm%ds_material%hydr%satuma       = r8nnem()
    ds_thm%ds_material%hydr%emmag        = r8nnem()
!   Material parameters (gaz)
    ds_thm%ds_material%l_gaz             = .false.
    ds_thm%ds_material%gaz%mass_mol      = r8nnem()
    ds_thm%ds_material%gaz%visc          = r8nnem()
    ds_thm%ds_material%gaz%dvisc_dtemp   = r8nnem()
    ds_thm%ds_material%gaz%cp            = r8nnem()
!   Material parameters (steam)
    ds_thm%ds_material%l_steam           = .false.
    ds_thm%ds_material%steam%mass_mol    = r8nnem()
    ds_thm%ds_material%steam%visc        = r8nnem()
    ds_thm%ds_material%steam%dvisc_dtemp = r8nnem()
    ds_thm%ds_material%steam%cp          = r8nnem()
!   Material parameters (liquid)
    ds_thm%ds_material%l_liquid           = .false.
    ds_thm%ds_material%liquid%rho         = r8nnem()
    ds_thm%ds_material%liquid%unsurk      = r8nnem()
    ds_thm%ds_material%liquid%visc        = r8nnem()
    ds_thm%ds_material%liquid%dvisc_dtemp = r8nnem()
    ds_thm%ds_material%liquid%cp          = r8nnem()
    ds_thm%ds_material%liquid%alpha       = r8nnem()
!   Material parameters (dissolved air)
    ds_thm%ds_material%l_ad               = .false.
    ds_thm%ds_material%ad%cp              = r8nnem()
    ds_thm%ds_material%ad%coef_henry      = r8nnem()
!   Material parameters (solid)
    ds_thm%ds_material%l_r_gaz            = .false.
    ds_thm%ds_material%solid%rho          = r8nnem()
    ds_thm%ds_material%solid%r_gaz        = r8nnem()
    ds_thm%ds_material%solid%cp           = r8nnem()
!
end subroutine
!
end module
