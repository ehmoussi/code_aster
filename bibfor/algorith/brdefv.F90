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

subroutine brdefv(e1i, e2i, a, t, b,&
                  k0, k1, eta1, k2, eta2,&
                  pw, e0f, e1f, e2f, e2pc,&
                  e2pt, sige2)
!
!        REPONSE EN RELAXATION
!     A E(T)=A*T+B AVEC E1(0)=E1I ET E2(0)=E2I
!     GESTION DES DEFORMATIONS PLASTIQUES ETAGE 2 (AS SEPTEMBRE 2004)
!     E2P(C OU T)=DEFORMATION PLASTIQUE ETAGE 2 EN +(T) OU -(C)
!
    implicit none
#include "asterf_types.h"
#include "asterfort/bre1bl.h"
#include "asterfort/bre1ec.h"
#include "asterfort/bre2ec.h"
    aster_logical :: h1, h2
!
!     EFLIM=3.0E-2
!-----------------------------------------------------------------------
    real(kind=8) :: k0, k1, k2
    real(kind=8) :: a, b, e0f, e1f, e1i, e2f, e2i
    real(kind=8) :: e2p, e2pc, e2pt, eta1, eta2, pw, sige1
    real(kind=8) :: sige2, t
!-----------------------------------------------------------------------
    h1=.false.
!     ECOULEMENT NIV 2 COMPRESSION
    e2p=e2pt
    call bre2ec(k0, k1, k2, eta1, eta2,&
                e1i, e2i, a, t, b,&
                e2p, pw, e2f)
    if ((e2f-e2p) .lt. 0.d0) then
!      ON EST EN COMP
        if (e2f .le. e2pc) then
!       PRINT *,'HYPOTHESE ECOULEMENT COMP OK'
            h1=.true.
            sige2=k2*(e2f-e2p)
            e2pc=e2f
            call bre1ec(k0, k1, k2, eta1, eta2,&
                        e1i, e2i, a, t, b,&
                        e2p, pw, e1f)
        endif
    endif
!
    if (h1) goto 10
!
    h2=.false.
!     HYPOTHESE  ECOULEMENT NIV 2 TRACTION
    e2p=e2pc
    call bre2ec(k0, k1, k2, eta1, eta2,&
                e1i, e2i, a, t, b,&
                e2p, pw, e2f)
    if ((e2f-e2p) .gt. 0.d0) then
!      ON EST EN TRACTION
        if (e2f .ge. e2pt) then
!       HYPOTHESE ECOULEMENT OK
            h2=.true.
            e2pt=e2f
            sige2=k2*(e2f-e2p)
            call bre1ec(k0, k1, k2, eta1, eta2,&
                        e1i, e2i, a, t, b,&
                        e2p, pw, e1f)
        endif
    endif
!
    if (h2) goto 10
!
!      PRINT*,'HYPOTHESES ECOULEMENT FAUSSES : BLOCAGE NIVEAU 2'
    e2f=e2i
    call bre1bl(k0, k1, k2, eta1, eta2,&
                e1i, e2i, a, t, b,&
                pw, e1f)
    sige1=k1*e1f
    sige2=sige1
!
!     CALCUL DE E0(T)
!
 10 continue
    e0f=a*t+b-e1f-e2f
end subroutine
