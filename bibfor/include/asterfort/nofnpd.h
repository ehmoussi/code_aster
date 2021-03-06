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
    subroutine nofnpd(ndim, nno1, nno2, nno3, npg,&
                      iw, vff1, vff2, vff3, idff1,&
                      vu, vp, vpi, typmod, mate,&
                      compor, geomi, nomte, sig, ddl,&
                      vect)
        integer :: npg
        integer :: nno3
        integer :: nno2
        integer :: nno1
        integer :: ndim
        integer :: iw
        real(kind=8) :: vff1(nno1, npg)
        real(kind=8) :: vff2(nno2, npg)
        real(kind=8) :: vff3(nno3, npg)
        integer :: idff1
        integer :: vu(3, 27)
        integer :: vp(27)
        integer :: vpi(3, 27)
        character(len=8) :: typmod(*)
        integer :: mate
        character(len=16) :: compor(*)
        real(kind=8) :: geomi(ndim, nno1)
        character(len=16) :: nomte
        real(kind=8) :: sig(2*ndim+1, npg)
        real(kind=8) :: ddl(*)
        real(kind=8) :: vect(*)
    end subroutine nofnpd
end interface
