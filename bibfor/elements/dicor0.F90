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

subroutine dicor0(k0, varim, varip1, varip2, dnsdu,&
                  dmsdt, dnsdt)
! ----------------------------------------------------------------------
    implicit none
    real(kind=8) :: k0(78), varim, varip1, varip2, dnsdu, dmsdt, dnsdt
!
!     UTILITAIRE POUR LE COMPORTEMENT CORNIERE.
!
! ----------------------------------------------------------------------
!
! IN  : K0     : COEFFICIENTS DE RAIDEUR TANGENTE
!       VARIM  : VARIABLE INTERNE PRECEDENTE
!
! OUT : VARIP$ : VARIABLES INTERNES ACTUALISEES
!       DNSDU  :
!       DMSDT  :
!       DNSDT  :
!
! ----------------------------------------------------------------------
    dnsdu = k0(1)
    dmsdt = k0(15)
    dnsdt = 0.d0
    varip1 = varim
    varip2 = 0.d0
! ----------------------------------------------------------------------
!
end subroutine
