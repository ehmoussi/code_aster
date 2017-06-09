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

subroutine calcdq(proj, nub, nu, d, pqx,&
                  pqy, pqz, dq)
    implicit none
    integer :: proj, i, ii
    real(kind=8) :: nu, nub, pqx(4), pqy(4), pqz(4), d(6, 6), dq(72)
    real(kind=8) :: dx(6), dy(6), dz(6)
!.......................................................................
!
!     BUT:  CALCUL  DE L'INCREMENT DQ POUR ACTUALISER LES CONTRAINTES
!           EN HYPO-ELASTICITE 3D POUR LE HEXA8 SOUS INTEGRE
!           STABILITE PAR ASSUMED STRAIN (3 VARIANTES)
!.......................................................................
! IN  PROJ     : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  NUB      : NUB = NU/(1-NU)
! IN  NU       : COEFFICIENT DE POISSON
! IN  D        : NOMBRE DE POINTS DE GAUSS
! IN  PQX      : INCREMENT DE DEFORMATIONS GENERALISEES EN X
! IN  PQY      : INCREMENT DE DEFORMATIONS GENERALISEES EN Y
! IN  PQZ      : INCREMENT DE DEFORMATIONS GENERALISEES EN Z
! OUT  DQ      : INCREMENT SERVANT AU CALCUL DES CONTRAINTES
!
!         QUAS4 SANS PROJECTION
!         ---------------------
    if (proj .eq. 0) then
        do 1 i = 1, 6
            ii = 12*(i-1)
            dq(ii+1) = d(i,1)*pqx(1)+ d(i,4)*pqy(1) + d(i,5)*pqz(1)
            dq(ii+2) = d(i,4)*pqx(1)+ d(i,2)*pqy(1) + d(i,6)*pqz(1)
            dq(ii+3) = d(i,5)*pqx(1)+ d(i,6)*pqy(1) + d(i,3)*pqz(1)
            dq(ii+4) = d(i,1)*pqx(2)+ d(i,4)*pqy(2) + d(i,5)*pqz(2)
            dq(ii+5) = d(i,4)*pqx(2)+ d(i,2)*pqy(2) + d(i,6)*pqz(2)
            dq(ii+6) = d(i,5)*pqx(2)+ d(i,6)*pqy(2) + d(i,3)*pqz(2)
            dq(ii+7) = d(i,1)*pqx(3)+ d(i,4)*pqy(3) + d(i,5)*pqz(3)
            dq(ii+8) = d(i,4)*pqx(3)+ d(i,2)*pqy(3) + d(i,6)*pqz(3)
            dq(ii+9) = d(i,5)*pqx(3)+ d(i,6)*pqy(3) + d(i,3)*pqz(3)
            dq(ii+10) = d(i,1)*pqx(4)+ d(i,4)*pqy(4) + d(i,5)*pqz(4)
            dq(ii+11) = d(i,4)*pqx(4)+ d(i,2)*pqy(4) + d(i,6)*pqz(4)
            dq(ii+12) = d(i,5)*pqx(4)+ d(i,6)*pqy(4) + d(i,3)*pqz(4)
 1      continue
!
!         ADS
!         ---
    else if (proj.eq.1) then
        do 2 i = 1, 6
            ii = 12*(i-1)
            dx(i) = (2.0d0*d(i,1) -d(i,2) -d(i,3))/3.0d0
            dy(i) = ( -d(i,1) +2.0d0*d(i,2) -d(i,3))/3.0d0
            dz(i) = ( -d(i,1) -d(i,2) +2.0d0*d(i,3))/3.0d0
            dq(ii+1) = dx(i)*pqx(1) + d(i,4)*pqy(1) + d(i,5)*pqz(1)
            dq(ii+2) = d(i,4)*pqx(1) + dy(i)*pqy(1)
            dq(ii+3) = d(i,5)*pqx(1) + dz(i)*pqz(1)
            dq(ii+4) = dx(i)*pqx(2) + d(i,4)*pqy(2)
            dq(ii+5) = d(i,4)*pqx(2) + dy(i)*pqy(2) + d(i,6)*pqz(2)
            dq(ii+6) = d(i,6)*pqy(2) + dz(i)*pqz(2)
            dq(ii+7) = dx(i)*pqx(3) + d(i,5)*pqz(3)
            dq(ii+8) = dy(i)*pqy(3) + d(i,6)*pqz(3)
            dq(ii+9) = d(i,5)*pqx(3)+ d(i,6)*pqy(3) + dz(i)*pqz(3)
            dq(ii+10) = dx(i)*pqx(4)
            dq(ii+11) = dy(i)*pqy(4)
            dq(ii+12) = dz(i)*pqz(4)
 2      continue
!
!         ASBQI
!         -----
    else if (proj.eq.2) then
        do 4 i = 1, 6
            ii = 12*(i-1)
            dx(i) = d(i,1) -nu*d(i,2) -nu*d(i,3)
            dy(i) = -nu*d(i,1) +d(i,2) -nu*d(i,3)
            dz(i) = -nu*d(i,1) -nu*d(i,2) +d(i,3)
            dq(ii+1) = dx(i)*pqx(1) + d(i,4)*pqy(1) + d(i,5)*pqz(1)
            dq(ii+2) = d(i,4)*pqx(1) + (d(i,2)-d(i,3)*nub)*pqy(1)
            dq(ii+3) = d(i,5)*pqx(1) + (d(i,3)-d(i,2)*nub)*pqz(1)
            dq(ii+4) = (d(i,1)-d(i,3)*nub)*pqx(2) + d(i,4)*pqy(2)
            dq(ii+5) = d(i,4)*pqx(2) + dy(i)*pqy(2) + d(i,6)*pqz(2)
            dq(ii+6) = d(i,6)*pqy(2) + (d(i,3)-d(i,1)*nub)*pqz(2)
            dq(ii+7) = (d(i,1)-d(i,2)*nub)*pqx(3) + d(i,5)*pqz(3)
            dq(ii+8) = (d(i,2)-d(i,1)*nub)*pqy(3) + d(i,6)*pqz(3)
            dq(ii+9) = d(i,5)*pqx(3)+ d(i,6)*pqy(3) + dz(i)*pqz(3)
            dq(ii+10) = dx(i)*pqx(4)
            dq(ii+11) = dy(i)*pqy(4)
            dq(ii+12) = dz(i)*pqz(4)
 4      continue
!
    endif
end subroutine
