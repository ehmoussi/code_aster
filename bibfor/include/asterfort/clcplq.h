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
    subroutine clcplq(ht, enrobg, typcmb, piva, pivb,&
                      es, cequi, sigaci, sigbet, effrts,&
                      dnsits, sigmbe, epsibe, ierr)
        real(kind=8) :: ht
        real(kind=8) :: enrobg
        integer :: typcmb
        real(kind=8) :: piva
        real(kind=8) :: pivb
        real(kind=8) :: es
        real(kind=8) :: cequi
        real(kind=8) :: sigaci
        real(kind=8) :: sigbet
        real(kind=8) :: effrts(8)
        real(kind=8) :: dnsits(5)
        real(kind=8) :: sigmbe
        real(kind=8) :: epsibe
        integer :: ierr
    end subroutine clcplq
end interface
