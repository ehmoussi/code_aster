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

subroutine rc32st(sijm, nbinst, sth, sn)
    implicit   none
#include "asterfort/rctres.h"
    integer :: nbinst
    real(kind=8) :: sijm(6), sth(6*nbinst), sn
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3200
!     CALCUL DU SN MAX SUR LES INSTANTS
!
! IN  : SIJM   : CONTRAINTES LINEARISEES OU EN PEAU (CHARGEMENTS MECA)
! IN  : NBINST : NOMBRE D'INTANTS DE CALCUL THERMOMECA
! IN  : STH    : CONTRAINTES LINEARISEES OU EN PEAU ( THERMOMECA)
! OUT : SN     : AMPLITUDE DE VARIATION DES CONTRAINTES DE TRESCA
!     ------------------------------------------------------------------
!
    integer :: i, it1
    real(kind=8) :: sijmt(6), tresca
    real(kind=8) :: e1(2)
! DEB ------------------------------------------------------------------
!
    sn = 0.d0
!
! --- CALCUL MECANIQUE :
!     ----------------
    if (nbinst .eq. 0) then
        call rctres(sijm, tresca)
        sn = tresca
!
! --- CALCUL THERMOMECANIQUE EN TMIN ET TMAX
!     --------------------------------------
    else
        e1(1) = +1.d0
        e1(2) = -1.d0
        do 12 it1 = 1, 2
            do 14 i = 1, 6
                sijmt(i) = sijm(i)*e1(it1) + sth(i)
14          continue
            call rctres(sijmt, tresca)
            sn = max( sn , tresca )
12      continue
    endif
!
end subroutine
