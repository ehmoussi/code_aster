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

subroutine cash_3d(alf, dcash, khi, csheff, casol,&
                   alsol, nasol, cash)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d : 
!     calcul des vistesses de cash
!=====================================================================
    implicit none
    real(kind=8) :: alf
    real(kind=8) :: dcash
    real(kind=8) :: khi
    real(kind=8) :: csheff
    real(kind=8) :: casol
    real(kind=8) :: alsol
    real(kind=8) :: nasol
    real(kind=8) :: cash
!     attention desormais alf contient cash
!     condition sur alf (si alf est faible on ne peut plus former de cash)
    if (alf .le. cash) then
        dcash=0.d0
    else
!       les alus fice ds les csh le sont definitvement      
        dcash=max((log10(alf)-log10(cash)),0.d0)*khi*100.
    endif
end subroutine 
