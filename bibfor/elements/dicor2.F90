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

subroutine dicor2(k0, p1, p2, dur, dryr,&
                  dxu, dryu, feq, nu, mu,&
                  uu, tt, si1, dnsdu, dmsdt,&
                  dnsdt, varip1, varip2, si2)
! ----------------------------------------------------------------------
    implicit none
    real(kind=8) :: k0(78), p1, p2, dur, dryr, dxu, dryu, feq, nu, mu, uu, tt
    real(kind=8) :: si1(12)
    real(kind=8) :: dnsdu, dmsdt, dnsdt, varip1, varip2, si2(12)
!
!     UTILITAIRE POUR LE COMPORTEMENT CORNIERE.
!
! ----------------------------------------------------------------------
!
! IN  : K0     : COEFFICIENTS DE RAIDEUR TANGENTE
!       P1     : VARIABLE INTERNE
!       P2     : VARIABLE INTERNE
!       DUR    : INCREMENT DE DEPLACEMENT
!       DRYR   : INCREMENT DE ROTATION
!       DXU    :
!       DRYU   :
!       FEQ    : FORCE EQUIVALENTE
!       NU     : EFFORT LIMITE ULTIME
!       MU     : MOMENT LIMITE ULTIME
!       UU     :
!       TT     :
!       SI1    : EFFORTS GENERALISES PRECEDENTS
!
! OUT : DNSDU  :
!       DMSDT  :
!       DNSDT  :
!       VARIP1 : VARIABLE INTERNE
!       VARIP2 : VARIABLE INTERNE
!       SI2    : EFFORTS GENERALISES COURANTS
!
! ----------------------------------------------------------------------
    varip1 = p1
    varip2 = 1.d0
    dnsdu = feq*nu/dxu/p2
    if (dur .eq. 0.d0) dnsdu = k0(1)
    dmsdt = feq*mu/dryu/p2
    if (dryr .eq. 0.d0) dmsdt = k0(15)
    dnsdt = 0.d0
    si2(7) = dnsdu*uu
    si2(11) = dmsdt*tt
    si2(1) = -si1(7)
    si2(5) = -si1(11)
! ----------------------------------------------------------------------
!
end subroutine
