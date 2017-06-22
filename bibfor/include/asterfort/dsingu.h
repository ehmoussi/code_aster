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
    subroutine dsingu(ndim, nelem, nnoem, nsommx, nelcom,&
                      degre, icnc, numeli, xy, erreur,&
                      energi, mesu, alpha, nalpha)
        integer :: nelcom
        integer :: nsommx
        integer :: nnoem
        integer :: nelem
        integer :: ndim
        integer :: degre
        integer :: icnc(nsommx+2, nelem)
        integer :: numeli(nelcom+2, nnoem)
        real(kind=8) :: xy(3, nnoem)
        real(kind=8) :: erreur(nelem)
        real(kind=8) :: energi(nelem)
        real(kind=8) :: mesu(nelem)
        real(kind=8) :: alpha(nelem)
        integer :: nalpha
    end subroutine dsingu
end interface
