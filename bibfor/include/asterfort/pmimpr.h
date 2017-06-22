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
    subroutine pmimpr(ind, inst, indimp, fonimp, valimp,&
                      iter, eps, sig, vi, nbvari,&
                      r, ee, eini)
        integer :: nbvari
        integer :: ind
        real(kind=8) :: inst
        integer :: indimp(6)
        character(len=8) :: fonimp(6)
        real(kind=8) :: valimp(6)
        integer :: iter
        real(kind=8) :: eps(6)
        real(kind=8) :: sig(6)
        real(kind=8) :: vi(nbvari)
        real(kind=8) :: r(12)
        real(kind=8) :: ee
        real(kind=8) :: eini
    end subroutine pmimpr
end interface
