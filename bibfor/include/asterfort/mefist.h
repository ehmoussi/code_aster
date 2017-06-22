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
    subroutine mefist(melflu, ndim, som, alpha, ru,&
                      promas, provis, matma, numgrp, nuor,&
                      freq, masg, fact, facpar, vite,&
                      xint, yint, rint, z, phix,&
                      phiy, defm, itypg, zg, hg,&
                      dg, tg, cdg, cpg, rugg,&
                      base)
        character(len=19) :: melflu
        integer :: ndim(14)
        real(kind=8) :: som(9)
        real(kind=8) :: alpha
        real(kind=8) :: ru
        character(len=8) :: promas
        character(len=8) :: provis
        real(kind=8) :: matma(*)
        integer :: numgrp(*)
        integer :: nuor(*)
        real(kind=8) :: freq(*)
        real(kind=8) :: masg(*)
        real(kind=8) :: fact(*)
        real(kind=8) :: facpar(*)
        real(kind=8) :: vite(*)
        real(kind=8) :: xint(*)
        real(kind=8) :: yint(*)
        real(kind=8) :: rint(*)
        real(kind=8) :: z(*)
        real(kind=8) :: phix(*)
        real(kind=8) :: phiy(*)
        real(kind=8) :: defm(*)
        integer :: itypg(*)
        real(kind=8) :: zg(*)
        real(kind=8) :: hg(*)
        real(kind=8) :: dg(*)
        real(kind=8) :: tg(*)
        real(kind=8) :: cdg(*)
        real(kind=8) :: cpg(*)
        real(kind=8) :: rugg(*)
        character(len=8) :: base
    end subroutine mefist
end interface
