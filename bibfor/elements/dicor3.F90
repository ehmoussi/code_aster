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

subroutine dicor3(k0, dur, dryr, si1, si2,&
                  dnsdu, dmsdt, dnsdt)
! ----------------------------------------------------------------------
    implicit none
    real(kind=8) :: k0(78), dur, dryr, si1(12), si2(12)
    real(kind=8) :: dnsdu, dmsdt, dnsdt
!
!     UTILITAIRE POUR LE COMPORTEMENT CORNIERE.
!
! ----------------------------------------------------------------------
!
! IN  : K0     : COEFFICIENTS DE RAIDEUR TANGENTE
!       DUR    : INCREMENT DE DEPLACEMENT
!       DRYR   : INCREMENT DE ROTATION
!       SI1    : EFFORTS GENERALISES PRECEDENTS
!       SI2    : EFFORTS GENERALISES COURANTS
!
! OUT : DNSDU  :
!       DMSDT  :
!       DNSDT  :
!
! ----------------------------------------------------------------------
    if (dur .ne. 0.d0) then
        dnsdu = (si2(7)-si1(7)) / dur
    else
        dnsdu = k0(1)
    endif
!
    if (dryr .ne. 0.d0) then
        dmsdt = (si2(11)-si1(11)) / dryr
    else
        dmsdt = k0(15)
    endif
    dnsdt = 0.d0
! ----------------------------------------------------------------------
!
end subroutine
