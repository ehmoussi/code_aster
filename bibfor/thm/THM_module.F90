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

module THM_module
!
use THM_type
!
implicit none
!
#include "asterf_types.h"
!
! person_in_charge: mickael.abbas at edf.fr
!

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
end type THM_DS

! Main variable    
type(THM_DS), public :: ds_thm

! Init all variables
public :: thmModuleInit

contains
!
subroutine thmModuleInit()
!
   ds_thm%ds_parainit%temp_init = 0.d0
   ds_thm%ds_parainit%pre1_init = 0.d0
   ds_thm%ds_parainit%pre2_init = 0.d0
   ds_thm%ds_parainit%poro_init = 0.d0
   ds_thm%ds_parainit%prev_init = 0.d0
! Behaviour
    ds_thm%ds_behaviour%rela_thmc  = ' '
    ds_thm%ds_behaviour%rela_meca  = ' '
    ds_thm%ds_behaviour%rela_ther  = ' '
    ds_thm%ds_behaviour%rela_hydr  = ' '
    ds_thm%ds_behaviour%l_temp        = .false.
    ds_thm%ds_behaviour%nb_pres       = 0
    ds_thm%ds_behaviour%nb_phase(1:2) = 0
!  Type of FE: which dof on element ?
   ds_thm%ds_elem%l_dof_ther     = .false.
   ds_thm%ds_elem%l_dof_meca     = .false.
   ds_thm%ds_elem%l_dof_hydr1    = .false.
   ds_thm%ds_elem%l_dof_hydr2    = .false.

end subroutine
!
end module
