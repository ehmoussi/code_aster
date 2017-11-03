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
!
subroutine thmGetGene(l_steady, l_vf  , ndim,&
                      mecani  , press1, press2, tempe)
!
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
aster_logical, intent(in) :: l_steady
aster_logical, intent(in) :: l_vf
integer, intent(in)  :: ndim
integer, intent(out) :: mecani(5)
integer, intent(out) :: press1(7)
integer, intent(out) :: press2(7)
integer, intent(out) :: tempe(5)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Initializations
!
! Get generalized coordinates
!
! --------------------------------------------------------------------------------------------------
!
! Out mecani       : parameters for mechanic
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Adress of first component in generalized strain vector
!                    (3) - Adress of first component in generalized stress vector
!                    (4) - Number of components for strains
!                    (5) - Number of components for stresses
! Out press1       : parameters for hydraulic (first pressure)
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Number of phases
!                    (3) - Adress of first component in generalized strain vector
!                    (4) - Adress of first component in vector of gen. stress for first phase 
!                    (5) - Adress of first component in vector of gen. stress for second phase
!                    (6) - Number of components for strains
!                    (7) - Number of components for stresses (for each phase)
! Out press1       : parameters for hydraulic (second pressure)
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Number of phases
!                    (3) - Adress of first component in generalized strain vector
!                    (4) - Adress of first component in vector of gen. stress for first phase 
!                    (5) - Adress of first component in vector of gen. stress for second phase
!                    (6) - Number of components for strains
!                    (7) - Number of components for stresses (for each phase)
! Out tempe        : parameters for thermic
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Adress of first component in generalized strain vector
!                    (3) - Adress of first component in generalized stress vector
!                    (4) - Number of components for strains
!                    (5) - Number of components for stresses
!
! --------------------------------------------------------------------------------------------------
!
    mecani(:) = 0
    press1(:) = 0
    press2(:) = 0
    tempe(:)  = 0
!
! - Main parameters: mechanic, thermic, hydraulic
!
    if (ds_thm%ds_elem%l_dof_meca) then
        mecani(1) = 1 
    endif
    if (ds_thm%ds_elem%l_dof_ther) then
        tempe(1)  = 1 
    endif
    if (ds_thm%ds_elem%l_dof_pre1) then
        press1(1) = 1
    endif
    if (ds_thm%ds_elem%l_dof_pre2) then
        press2(1) = 1
    endif
    press1(2) = ds_thm%ds_elem%nb_phase(1)
    press2(2) = ds_thm%ds_elem%nb_phase(2)
!
! - Number of (generalized) stress/strain components - Mechanic
!
    if (mecani(1) .eq. 1) then
        mecani(4) = ndim + 6
        mecani(5) = 6 + 6
    endif
!
! - Number of (generalized) stress/strain components - Thermic
!
    if (tempe(1) .eq. 1) then
        tempe(4) = 1 + ndim
        tempe(5) = 1 + ndim
    endif
!
! - Number of (generalized) stress/strain components - Hydraulic
!
    if (press1(1) .eq. 1) then
        press1(6) = 1 + ndim
        if (l_steady) then
            press1(7) = ndim
        else
            press1(7) = ndim + 1
        endif
        if (tempe(1) .eq. 1) then
            press1(7) = press1(7) + 1
        endif
    endif
    if (press2(1) .eq. 1) then
        press2(6) = 1 + ndim
        if (l_steady) then
            press2(7) = ndim
        else
            press2(7) = ndim + 1
        endif
        if (tempe(1) .eq. 1) then
            press2(7) = press2(7) + 1
        endif
    endif
    if (l_vf) then
        press1(7) = 2
        press2(7) = 2
    endif
!
! - Index for adress in (generalized) vectors - Mechanic
!
    if (mecani(1) .eq. 1) then
        mecani(2) = 1
        mecani(3) = 1
    endif
!
! - Index for adress in (generalized) vectors - Hydraulic
!
    if (press1(1) .eq. 1) then
        press1(3) = mecani(4) + 1
        press1(4) = mecani(5) + 1
        if (press1(2) .eq. 2) then
            press1(5) = press1(4) + press1(7)
        endif
    endif
!
    if (press2(1) .eq. 1) then
        press2(3) = press1(3) + press1(6)
        press2(4) = press1(4) + press1(2)*press1(7)
        if (press2(2) .eq. 2) then
            press2(5) = press2(4) + press2(7)
        endif
    endif
!
! - Index for adress in (generalized) vectors - Thermic
!
    if (tempe(1) .eq. 1) then
        tempe(2) = mecani(4) + press1(6) + press2(6) + 1
        tempe(3) = mecani(5) + press1(2)*press1(7) + press2(2)* press2(7) + 1
    endif
!
end subroutine
