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
    subroutine ecla2d(nomte, elrefa, fapg, npg, npoini,&
                      nterm1, nsomm1, csomm1, tyma, nbno2,&
                      connx, mxnbn2, mxnbpi, mxnbte, mxnbse,&
                      nbsel, corsel)
        integer :: mxnbse
        integer :: mxnbte
        integer :: mxnbpi
        integer :: mxnbn2
        character(len=16) :: nomte
        character(len=8) :: elrefa
        character(len=8) :: fapg
        integer :: npg
        integer :: npoini
        integer :: nterm1(mxnbpi)
        integer :: nsomm1(mxnbpi, mxnbte)
        real(kind=8) :: csomm1(mxnbpi, mxnbte)
        integer :: tyma(mxnbse)
        integer :: nbno2(mxnbse)
        integer :: connx(mxnbn2, mxnbse)
        integer :: nbsel
        integer :: corsel(mxnbse)
    end subroutine ecla2d
end interface
