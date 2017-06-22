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
    subroutine cmtrf2(codcm1, codtrf, ncm1, lcm1, ntrf,&
                      ltrf, nbma, codint, lint, nint)
        integer :: nbma
        integer :: ntrf
        integer :: ncm1
        integer :: codcm1
        integer :: codtrf
        integer :: lcm1(ncm1)
        integer :: ltrf(ntrf)
        integer :: codint
        integer :: lint(nbma)
        integer :: nint
    end subroutine cmtrf2
end interface
