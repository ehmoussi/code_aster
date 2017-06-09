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

subroutine uttr24(vk24, ndim)
    implicit none
!
!     ARGUMENTS:
!     ----------
    integer :: ndim
    character(len=24) :: vk24(ndim)
! ----------------------------------------------------------------------
!     BUT : TRIER DANS L'ORDRE ALPHABETIQUE UN VECTEUR DE K24
!
!     IN:
!         NDIM : DIMENSION DU TABLEAU A TRIER
!     VAR:
!         VK24 : TABLEAU A TRIER
!
! ----------------------------------------------------------------------
    character(len=24) :: ct
    integer :: i, j
!-----------------------------------------------------------------------
!
! DEB-------------------------------------------------------------------
!
    do 1, i=1,ndim
    do 2, j=i+1,ndim
    if (vk24(j) .lt. vk24(i)) then
!              -- ON PERMUTE I ET J
        ct =vk24(i)
        vk24(i)=vk24(j)
        vk24(j)=ct
    endif
 2  continue
    1 end do
!
end subroutine
