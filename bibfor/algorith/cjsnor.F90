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

subroutine cjsnor(mater, sig, x, nor, devnul,&
                  trac)
!
!
!   CALCUL  UNE ESTIMATION UN VECTEUR PARALLELE A DF/DQ
!           OU DF EST LE SEUIL DEVIATOIRE ET Q LE TENSEUR Q
!                     Q = S-X*I1
!   IN :
!       MATER : MATERIAU
!       SIG   : CONTRAINTES
!       X     : VARIABLES INTERNES CINEMATIQUES
!   OUT :
!       NOR   : ESTIMATION DE LA DITRECTION DE LA NORMALE
!               A LA SURFACE DEVIATOIRE DANS LE PLAN DEVIATOIRE
!               PERPENDICULAIRE A LA TRISECTRICE
!               LE VECTEUR NOR(1:NDT) N EST PAS NORME
!               SA NORME EST NOR(NDT+1)
!    DEVNUL   : VRAI SI DEVIATEUR DE Q NUL
!    TRAC     : VRAI SI I1  NUL
!
    implicit none
!
!
#include "asterf_types.h"
#include "asterfort/cjsc3q.h"
#include "asterfort/cjst.h"
    real(kind=8) :: mater(14, 2), sig(6), x(6), nor(7)
    aster_logical :: devnul, trac
    real(kind=8) :: zero, deux, six
    parameter     ( zero   = 0.d0   )
    parameter     ( deux   = 2.d0   )
    parameter     ( six    = 6.d0   )
!
    real(kind=8) :: g, pa, qinit, q(6), tq(6), coef, qii, cos3tq, trav, trav2
    integer :: i
    integer :: ndt, ndi
    common /tdim/   ndt, ndi
!
!
!
!
!-----------------------------------------------------------------------
!->     PROPRIETES CJS MATERIAU
!------------------------------
    g = mater(9,2)
    pa = mater(12,2)
    qinit = mater(13,2)
!-----------------------------------------------------------------------
!->    Q QII ET COS3TQ
!-----------------------------------------------------------------------
!
    call cjsc3q(sig, x, pa, qinit, q,&
                qii, cos3tq, devnul, trac)
!-----------------------------------------------------------------------
!->    TQ = DET(Q)*INV(Q)
!-----------------------------------------------------------------------
    call cjst(q, tq)
!
!
    coef = sqrt(six)*g/qii
    trav2 = zero
    do 10 i = 1, ndt
        trav = (deux+g*cos3tq)*q(i)+coef*tq(i)
        trav2 = trav2+trav*trav
        nor(i) = trav
 10 continue
    nor(ndt+1) = sqrt(trav2)
end subroutine
