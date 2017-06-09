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
    subroutine arlten(coorc1,coorc2,npgs    , ndim , poijcs, &
                      ndml1,ndml2,fcpig1,dfdx1,dfdy1,dfdz1,mcpln1)
        integer :: ndim
        integer :: npgs
        integer :: ndml1
        integer :: ndml2
        real(kind=8) :: poijcs(npgs)
        real(kind=8) :: coorc1(ndim*ndml1)
        real(kind=8) :: fcpig1(npgs*ndim*ndim*ndml1)
        real(kind=8) :: dfdx1(npgs*ndim*ndim*ndml1)
        real(kind=8) :: dfdy1(npgs*ndim*ndim*ndml1)
        real(kind=8) :: dfdz1(npgs*ndim*ndim*ndml1)
        real(kind=8) :: coorc2(6)
        real(kind=8) :: mcpln1(2*ndim*ndml2,ndim*ndml1)
    end subroutine arlten
end interface
