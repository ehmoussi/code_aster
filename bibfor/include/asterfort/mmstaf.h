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
!
! aslint: disable=W1504
#include "asterf_types.h"
!
interface
    subroutine mmstaf(mesh          , ndim  , chdepd, coef_frot   , lpenaf      , &
                      nummae        , aliase, nne   , nummam      , ksipc1      , &
                      ksipc2        , ksipr1, ksipr2, mult_lagr_f1, mult_lagr_f2, &
                      tang_1        , tang_2, norm  , pres_frot   , dist_frot   , &
                      indi_frot_eval)
        character(len=8), intent(in) :: mesh
        integer, intent(in) :: ndim
        character(len=19), intent(in) :: chdepd
        real(kind=8), intent(in) :: coef_frot
        aster_logical, intent(in) :: lpenaf
        integer, intent(in) :: nummae
        character(len=8), intent(in) :: aliase
        integer, intent(in) :: nne
        integer, intent(in) :: nummam
        real(kind=8), intent(in) :: ksipc1
        real(kind=8), intent(in) :: ksipc2
        real(kind=8), intent(in) :: ksipr1
        real(kind=8), intent(in) :: ksipr2
        real(kind=8), intent(in) :: mult_lagr_f1(9)
        real(kind=8), intent(in) :: mult_lagr_f2(9)
        real(kind=8), intent(in) :: tang_1(3)
        real(kind=8), intent(in) :: tang_2(3)
        real(kind=8), intent(in) :: norm(3)
        real(kind=8), intent(out) :: pres_frot(3)
        real(kind=8), intent(out) :: dist_frot(3)
        integer, intent(out) :: indi_frot_eval
    end subroutine mmstaf
end interface
