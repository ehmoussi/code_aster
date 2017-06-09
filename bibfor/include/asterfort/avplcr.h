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
    subroutine avplcr(nbvec, vectn, vectu, vectv, nbordr,&
                      kwork, somnow, vwork, tdisp, tspaq,&
                      i, nomcri, nomfor, grdvie, forvie,&
                      fordef, fatsoc, proaxe, nommat, vala,&
                      coefpa, post, cudomx, nxm, nym,&
                      nzm)
        integer :: tdisp
        integer :: nbordr
        integer :: nbvec
        real(kind=8) :: vectn(3*nbvec)
        real(kind=8) :: vectu(3*nbvec)
        real(kind=8) :: vectv(3*nbvec)
        integer :: kwork
        integer :: somnow
        real(kind=8) :: vwork(tdisp)
        integer :: tspaq
        integer :: i
        character(len=16) :: nomcri
        character(len=16) :: nomfor
        character(len=16) :: grdvie
        character(len=16) :: forvie
        aster_logical :: fordef
        real(kind=8) :: fatsoc
        character(len=16) :: proaxe
        character(len=8) :: nommat
        real(kind=8) :: vala
        real(kind=8) :: coefpa
        aster_logical :: post
        real(kind=8) :: cudomx
        real(kind=8) :: nxm(2)
        real(kind=8) :: nym(2)
        real(kind=8) :: nzm(2)
    end subroutine avplcr
end interface
