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

module THM_type
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
! THM - Define types 
!
! --------------------------------------------------------------------------------------------------
!

! - Type of FE
    type THM_Element
! ----- Type of FE: element where dof TEMP exist
        aster_logical :: l_dof_ther 
! ----- Type of FE: element where dof DX, DY, DZ exist
        aster_logical :: l_dof_meca
! ----- Type of FE: element where dof PRE1 exist
        aster_logical :: l_dof_hydr1
! ----- Type of FE: element where dof PRE2 exist
        aster_logical :: l_dof_hydr2
! ----- Type of FE: element where dof PRE1 and PRE2 exist
        aster_logical :: l_dof_hydr
! ----- Type of FE: number of phasis for each fluid
        integer :: nb_phase(2)
    end type THM_Element

! - Behaviour
    type THM_Behaviour
        character(len=16) :: rela_thmc
        character(len=16) :: rela_meca
        character(len=16) :: rela_ther
        character(len=16) :: rela_hydr
        aster_logical :: l_temp
        integer :: nb_pres
        integer :: nb_phase(2)
    end type THM_Behaviour

! - Initial condition (THM_INIT)
    type THM_ParaInit
        real(kind=8) :: temp_init
        real(kind=8) :: pre1_init
        real(kind=8) :: pre2_init
        real(kind=8) :: poro_init
        real(kind=8) :: prev_init
    end type THM_ParaInit
!
end module
