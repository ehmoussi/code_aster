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

subroutine epsett(applic, nbrddl, depl, btild, sgmtd,&
                  epsi, wgt, effint)
    implicit none
!
    integer :: nbrddl, i, k
    character(len=6) :: applic
    real(kind=8) :: btild(4, *), depl(*), epsi(*), sgmtd(*), effinb
    real(kind=8) :: wgt, effint(*)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (applic .eq. 'DEFORM') then
!
!     CALCULS DES COMPOSANTES DE DEFORMATIONS TRIDIMENSIONNELLES :
!     EPSXX, EPSYY, EPSXY, EPSXZ (CE SONT LES COMPOSANTES TILDE)
!
        do 10 i = 1, 4
            epsi(i)=0.d0
            do 20 k = 1, nbrddl
                epsi(i)=epsi(i)+btild(i,k)*depl(k)
20          end do
10      end do
!
    else if (applic .eq. 'EFFORI') then
!
!     CALCULS DES EFFORTS INTERIEURS
!
        do 30 i = 1, nbrddl
            effinb=0.d0
            do 40 k = 1, 4
                effinb=effinb+btild(k,i)*sgmtd(k)
40          continue
            effint(i)=effint(i)+wgt*effinb
30      end do
!
    endif
end subroutine
