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
interface 
    subroutine flu_inc3d(e0i, e1i, e2i, ve1i, ve2i,&
                         k0, k1, h1, h2, vk0,&
                         vk1, vh1, vh2, depst, delta,&
                         e0f, e1f, e2f, dsigma, ve1f,&
                         ve2f, dissip)
        real(kind=8) :: e0i
        real(kind=8) :: e1i
        real(kind=8) :: e2i
        real(kind=8) :: ve1i
        real(kind=8) :: ve2i
        real(kind=8) :: k0
        real(kind=8) :: k1
        real(kind=8) :: h1
        real(kind=8) :: h2
        real(kind=8) :: vk0
        real(kind=8) :: vk1
        real(kind=8) :: vh1
        real(kind=8) :: vh2
        real(kind=8) :: depst
        real(kind=8) :: delta
        real(kind=8) :: e0f
        real(kind=8) :: e1f
        real(kind=8) :: e2f
        real(kind=8) :: dsigma
        real(kind=8) :: ve1f
        real(kind=8) :: ve2f
        real(kind=8) :: dissip
    end subroutine flu_inc3d
end interface 
