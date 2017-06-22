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

subroutine mahsf(ind1, nb1, xi, ksi3s2, intsn,&
                 xr, epais, vectn, vectg, vectt,&
                 hsf)
    implicit none
#include "asterfort/hfmss.h"
#include "asterfort/vectgt.h"
    integer :: nb1, intsn
    real(kind=8) :: xi(3, *), xr(*), vectn(9, 3), ksi3s2
    real(kind=8) :: vectg(2, 3), vectt(3, 3), hsf(3, 9), hss(2, 9)
!
!
!     CONSTRUCTION DU VECTEUR N AUX PTS D'INTEGRATION NORMAL
!     (POUR CHAQUE INTSN, STOCKAGE DANS VECTT)
!
!     ET
!
!     CONSTRUCTION DES VECTEURS GA AUX PTS D'INTEGRATION NORMAL
!     (POUR CHAQUE INTSN, STOCKAGE DANS VECTG)
!
!     ET
!
!     CONSTRUCTION DES VECTEURS TA AUX PTS D'INTEGRATION NORMAL (T3=N)
!     (POUR CHAQUE INTSN, STOCKAGE DANS VECTT)
!
!     IND1= 1      1 : CALCULS AUX PTS D'INTEGRATION NORMAL
!
!-----------------------------------------------------------------------
    integer :: ind1, ind2
    real(kind=8) :: epais
!-----------------------------------------------------------------------
    call vectgt(ind1, nb1, xi, ksi3s2, intsn,&
                xr, epais, vectn, vectg, vectt)
!
!     CONSTRUCTION DE HSM = HFM * S :(3,9) AUX PTS D'INTEGRATION NORMAL
!
!     IND2= 0  --->  PAS DE CALCUL DE HSS
!
    ind2= 0
!
    call hfmss(ind2, vectt, hsf, hss)
!
end subroutine
