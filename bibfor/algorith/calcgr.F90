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

subroutine calcgr(igau, nbsig, nbvari, vip, nu,&
                  epsfl)
    implicit   none
    integer :: nbsig, igau, nbvari
    real(kind=8) :: nu, epsfl(nbsig), vip(*)
!
! ======================================================================
!   BUT : CALCUL DES DEFORMATIONS DE FLUAGE DE GRANGER EN
!         UN POINT DE GAUSS
!         ROUTINE APPELEE POUR LE POST-TRAITEMENT
!----------------------------------------------------------------------
    integer :: i, k
    real(kind=8) :: epstmp(6)
!
!
    do 100 k = 1, nbsig
        epstmp(k) = vip((igau-1)*nbvari + 8*nbsig+k)
        do 90 i = 1, 8
            epstmp(k) = epstmp(k) - vip((igau-1)*nbvari+ (i-1)*nbsig+ k)
90      continue
100  continue
!
!
    epsfl(1) = epstmp(1) - nu* (epstmp(2) + epstmp( 3))
    epsfl(2) = epstmp(2) - nu* (epstmp(1) + epstmp( 3))
    epsfl(3) = epstmp(3) - nu* (epstmp(1) + epstmp( 2))
    do 110 i = 4, nbsig
        epsfl(i) = (1.d0 + nu) *epstmp(i)
110  continue
!
!
end subroutine
