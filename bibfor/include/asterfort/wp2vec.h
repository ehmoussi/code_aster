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
interface
    subroutine wp2vec(appr, opt, nbfreq, nbvect, neq,&
                      shift, yh, yb, vr, nlivr,&
                      vpr, vpi, vecp, mxresf, resufi,&
                      resufr, lagr, omecor)
        integer :: mxresf
        integer :: nlivr
        integer :: neq
        character(len=1) :: appr
        character(len=*) :: opt
        integer :: nbfreq
        integer :: nbvect
        complex(kind=8) :: shift
        real(kind=8) :: yh(neq, *)
        real(kind=8) :: yb(neq, *)
        real(kind=8) :: vr(nlivr, *)
        real(kind=8) :: vpr(*)
        real(kind=8) :: vpi(*)
        complex(kind=8) :: vecp(neq, *)
        integer :: resufi(mxresf, *)
        real(kind=8) :: resufr(mxresf, *)
        integer :: lagr(*)
        real(kind=8) :: omecor
    end subroutine wp2vec
end interface
