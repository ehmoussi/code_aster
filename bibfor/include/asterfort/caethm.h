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
    subroutine caethm(axi, perman, vf, typvf,&
                      typmod, modint, mecani, press1, press2,&
                      tempe, dimdep, dimdef, dimcon, nmec,&
                      np1, np2, ndim, nno, nnos,&
                      nnom, nface, npi, npg, nddls,&
                      nddlm, nddlfa, nddlk, dimuel, ipoids,&
                      ivf, idfde, ipoid2, ivf2, idfde2,&
                      npi2, jgano)
        aster_logical, intent(in) :: axi
        aster_logical, intent(in) :: perman
        aster_logical, intent(in) :: vf
        integer, intent(in) :: ndim
        integer, intent(out) :: mecani(5)
        integer, intent(out) :: press1(7)
        integer, intent(out) :: press2(7)
        integer, intent(out) :: tempe(5)
        integer :: typvf
        character(len=8) :: typmod(2)
        character(len=3) :: modint
        integer, intent(out) :: dimdep
        integer, intent(out) :: dimdef
        integer, intent(out) :: dimcon
        integer, intent(out) :: nmec
        integer, intent(out) :: np1
        integer, intent(out) :: np2
        integer :: nno
        integer :: nnos
        integer :: nnom
        integer :: nface
        integer :: npi
        integer :: npg
        integer :: nddls
        integer :: nddlm
        integer :: nddlfa
        integer :: nddlk
        integer :: dimuel
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        integer :: ipoid2
        integer :: ivf2
        integer :: idfde2
        integer :: npi2
        integer :: jgano
    end subroutine caethm
end interface
