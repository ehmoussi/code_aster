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
! - Type of Biot coefficients
    integer, parameter :: BIOT_TYPE_ISOT = 0
    integer, parameter :: BIOT_TYPE_ISTR = 1
    integer, parameter :: BIOT_TYPE_ORTH = 2
! - Type of saturation
    integer, parameter :: SATURATED         = 0
    integer, parameter :: UNSATURATED       = 1
    integer, parameter :: SATURATED_SPEC    = 2


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
! ----- Flag for weak coupling
        aster_logical :: l_weak_coupling
        real(kind=8) :: divu_prev
        real(kind=8) :: divu_curr
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
        integer :: satur_type
    end type THM_Behaviour

! - Initial condition (THM_INIT)
    type THM_ParaInit
        real(kind=8) :: temp_init
        real(kind=8) :: pre1_init
        real(kind=8) :: pre2_init
        real(kind=8) :: poro_init
        real(kind=8) :: prev_init
    end type THM_ParaInit

! - Material parameters
    type THM_Material
! ----- For Biot coefficient (evolution of porosity)
        integer :: biot_type
        real(kind=8) :: biot_coef
        real(kind=8) :: biot_l
        real(kind=8) :: biot_n
        real(kind=8) :: biot_t
! ----- For elasticity
        integer :: elas_id
        character(len=16) :: elas_keyword
        real(kind=8) :: e, nu, g
        real(kind=8) :: e_l, e_t, e_n
        real(kind=8) :: nu_lt, nu_ln, nu_tn
        real(kind=8) :: g_lt, g_ln, g_tn
        real(kind=8) :: alpha
        real(kind=8) :: alpha_l, alpha_t, alpha_n
        real(kind=8) :: d(6,6)
! ----- For hydraulic
        real(kind=8) :: n
        real(kind=8) :: pr
        real(kind=8) :: sr
        real(kind=8) :: smax
        real(kind=8) :: satuma
        real(kind=8) :: emmag
    end type THM_Material
!
end module
