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

subroutine ionfixe_3d(alfeq, sfeq, csh, csheff, temp,&
                      nasol, ssol, alsol, alpal, cash)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d : 
!     calcul des quantités d'ions fixés dans les csh à l'équilibre
!=====================================================================
    implicit none
    real(kind=8) :: alfeq
    real(kind=8) :: sfeq
    real(kind=8) :: csh
    real(kind=8) :: csheff
    real(kind=8) :: temp
    real(kind=8) :: nasol
    real(kind=8) :: ssol
    real(kind=8) :: alsol
    real(kind=8) :: alpal
    real(kind=8) :: cash
!     les alfeq contienne les cash de façon a nnuler la vitesse
!     liberation si alf=cash quand il ny aen pls en solution
    alfeq=csheff*(1.d0-dexp(-alsol/alpal))+cash
    sfeq=2.067d0*csh*ssol*(temp**0.2124d0)*(nasol**0.2004d0)
!      print*, 'sfeq', sfeq, 'nasol', nasol      
end subroutine
