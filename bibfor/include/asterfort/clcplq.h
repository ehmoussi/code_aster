! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine clcplq(typcmb, typco, es, cequi, enrobs, enrobi, sigaci,&
                      sigbet, coeff1, coeff2, gammas, gammac, facier,&
                      fbeton, clacier, uc, ht, effrts, dnsits, sigmbe,&
                      epsibe, ierr)
        integer :: typcmb
        integer :: typco
        real(kind=8) :: es
        real(kind=8) :: cequi
        real(kind=8) :: enrobs
        real(kind=8) :: enrobi
        real(kind=8) :: sigaci
        real(kind=8) :: sigbet
        real(kind=8) :: coeff1
        real(kind=8) :: coeff2
        real(kind=8) :: gammas
        real(kind=8) :: gammac
        real(kind=8) :: facier
        real(kind=8) :: fbeton
        integer :: clacier
        integer :: uc
        real(kind=8) :: ht
        real(kind=8) :: effrts(8)
        real(kind=8) :: dnsits(5)
        real(kind=8) :: sigmbe
        real(kind=8) :: epsibe
        integer :: ierr
    end subroutine clcplq
end interface
