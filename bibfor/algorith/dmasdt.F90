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

function dmasdt(rho12, rho21, sat, phi, pas,&
                h11, h12, temp, alp21)
!
implicit none
!
real(kind=8), intent(in) :: temp
! 
real(kind=8) :: rho12, rho21, sat, phi, pas, h11, h12, alp21, dmasdt
! --- CALCUL DE LA DERIVEE DE L APPORT MASSIQUE DE L AIR SEC PAR -------
! --- RAPPORT A LA TEMPERATURE -----------------------------------------
! ======================================================================
    dmasdt = -rho21*(rho12*phi*(1.d0-sat)*(h12-h11)/pas/temp+3.d0*alp21)
! ======================================================================
end function
