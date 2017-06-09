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

subroutine brvp33(x33, x3, v33)
!
!        DIAGONALISAGION 33 A PARTIR DE JACOBI + QUELQUES CONTROLES
!
    implicit none
#include "asterfort/jacobi.h"
#include "asterfort/matini.h"
#include "asterfort/utbtab.h"
    real(kind=8) :: x33(3, 3), x3(3), v33(3, 3)
    real(kind=8) :: epsv, y33(3, 3), trav(3, 3)
    real(kind=8) :: xv(6), xid(6), valaux(3)
    integer :: niter
    real(kind=8) :: xmax, zz
!-----------------------------------------------------------------------
    zz = 0.d0
!     EPSV*D(1) VALEUR EN DESSOUS LAQUELLE UN TERME HORS DIAGONALE
!       EST NEGLIGE
!     LORS DU CALCUL DES VECTEURS PROPRES
    epsv=1.d-7
!      ON VERIFIE SI X33 N EST PAS DEJA DIAGONALE ( A EPSV*XMAX PRES)
    xmax=max(abs(x33(1,1)),abs(x33(2,2)),abs(x33(3,3)))
    if ((abs(x33(1,2)).le.(epsv*xmax)) .and. (abs(x33(1,3)).le.(epsv*xmax)) .and.&
        (abs(x33(1,2)).le.(epsv*xmax))) then
        call matini(3, 3, zz, v33)
!          PRINT*,'MATRICE DEJA DIAGONALE'
        x3(1)=x33(1,1)
        v33(1,1)=1.d0
        x3(2)=x33(2,2)
        v33(2,2)=1.d0
        x3(3)=x33(3,3)
        v33(3,3)=1.d0
    else
!       ON VERIFIE SI ELLE N EST PAS CISAILLEMENT PUR+SPHERIQUE PUR
        if ((abs(x33(1,2)-x33(1,3)).le.(epsv*xmax)) .and.&
            (abs(x33(1,2)- x33(2,3)).le.(epsv*xmax)) .and.&
            (abs(x33(1,1)-x33(2,2)).le.( epsv*xmax)) .and.&
            (abs(x33(1,1)-x33(3,3)).le.(epsv*xmax))) then
            v33(1,1) = -sqrt(3.d0)*sqrt(2.d0)/6.d0
            v33(1,2) = sqrt(3.d0)/3.d0
            v33(1,3) = sqrt(2.d0)/2.d0
            v33(2,1) = -sqrt(3.d0)*sqrt(2.d0)/6.d0
            v33(2,2) = sqrt(3.d0)/3.d0
            v33(2,3) = -sqrt(2.d0)/2.d0
            v33(3,1) = sqrt(3.d0)*sqrt(2.d0)/3.d0
            v33(3,2) = sqrt(3.d0)/3.d0
            v33(3,3) = 0.d0
            call utbtab('ZERO', 3, 3, x33, v33,&
                        trav, y33)
            x3(1)=y33(1,1)
            x3(2)=y33(2,2)
            x3(3)=y33(3,3)
        else
!         LA MATRICE X33 PARAIT DIAGONALISABLE PAR JACOBI
            xid(1) = 1.d0
            xid(2) = 0.d0
            xid(3) = 0.d0
            xid(4) = 1.d0
            xid(5) = 0.d0
            xid(6) = 1.d0
            xv(1) = x33(1,1)
            xv(2) = x33(1,2)
            xv(3) = x33(1,3)
            xv(4) = x33(2,2)
            xv(5) = x33(2,3)
            xv(6) = x33(3,3)
            call jacobi(3, 50, 0.000001d0, 0.000001d0, xv,&
                        xid, v33, x3, valaux, niter,&
                        0, 1)
        endif
    endif
!
end subroutine
