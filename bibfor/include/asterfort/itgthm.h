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
#include "asterf_types.h"
!
interface
    subroutine itgthm(vf, typvf, modint, mecani, press1,&
                      press2, tempe, ndim, nno, nnos,&
                      nnom, nface, npi, npg, nddls,&
                      nddlk, nddlm, nddlfa, dimuel, ipoids,&
                      ivf, idfde, ipoid2, ivf2, idfde2,&
                      npi2, jgano)
        aster_logical :: vf
        integer :: typvf
        character(len=3) :: modint
        integer :: mecani(5)
        integer :: press1(7)
        integer :: press2(7)
        integer :: tempe(5)
        integer :: ndim
        integer :: nno
        integer :: nnos
        integer :: nnom
        integer :: nface
        integer :: npi
        integer :: npg
        integer :: nddls
        integer :: nddlk
        integer :: nddlm
        integer :: nddlfa
        integer :: dimuel
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        integer :: ipoid2
        integer :: ivf2
        integer :: idfde2
        integer :: npi2
        integer :: jgano
    end subroutine itgthm
end interface
