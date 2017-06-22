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
    subroutine fstapv(nbpt, fn, t, offset, fnmoyt,&
                      fnmoyc, fnrmst, fnrmsc, fnmax, fnmin,&
                      fmaxmo, fminmo, sfn, sfn2, tchoc,&
                      nbmaxr, nbminr)
        integer :: nbpt
        real(kind=8) :: fn(*)
        real(kind=8) :: t(*)
        real(kind=8) :: offset
        real(kind=8) :: fnmoyt
        real(kind=8) :: fnmoyc
        real(kind=8) :: fnrmst
        real(kind=8) :: fnrmsc
        real(kind=8) :: fnmax
        real(kind=8) :: fnmin
        real(kind=8) :: fmaxmo
        real(kind=8) :: fminmo
        real(kind=8) :: sfn
        real(kind=8) :: sfn2
        real(kind=8) :: tchoc
        integer :: nbmaxr
        integer :: nbminr
    end subroutine fstapv
end interface
