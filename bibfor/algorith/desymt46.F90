! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine desymt46(ftos, ftot)
!
implicit none
!
    real(kind=8), dimension(6,6), intent(in)      :: ftos
    real(kind=8), dimension(3,3,3,3), intent(out) :: ftot
! --------------------------------------------------------------------------------------------------
!     DESYMETRISE UN TENSEUR SUR 2 PREMIERS ET 2 DERNIERS INDICES
!     NOTATION DE VOIGT AVEC RAC2 : XX,YY,ZZ,RAC2*XY,RAC2*XZ,RAC2*YZ
!
! IN   FTOS    : TENSEUR (6,6)
! OUT  FTOT    : TENSEUR(3,3,3,3) F_IJKL AVEC SYMETRIES MINEURES
!               F_IJKL=F_JIKL et F_IJKL=F_IJLK
! --------------------------------------------------------------------------------------------------
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    integer :: i, j, k, l, ijk(3,3)
    real(kind=8) :: fnew(6, 6)
! ---------------------------------------------------------------------
!
    fnew = ftos
!
! -- On supprime les racines de 2
    do j = 4, 6
        do i = 1, 6
            fnew(i,j) = fnew(i,j) / rac2
        end do
    end do
!
    do j = 1, 6
        do i = 4, 6
            fnew(i,j) = fnew(i,j) / rac2
        end do
    end do
!
! -- tableau de correspondance
    ijk(1,1) = 1
    ijk(2,2) = 2
    ijk(3,3) = 3
    ijk(1,2) = 4
    ijk(2,1) = 4
    ijk(1,3) = 5
    ijk(3,1) = 5
    ijk(2,3) = 6
    ijk(3,2) = 6
!
! -- On converti le tenseur
    do i = 1, 3
        do j = 1, 3
            do k = 1, 3
                do l = 1, 3
                    ftot(i,j,k,l) = fnew(ijk(i,j), ijk(k,l))
                end do
            end do
        end do
    end do
!
end subroutine
