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

subroutine rcmcrt(symax, sigm, stlin, stpar)
    implicit none
#include "asterc/r8vide.h"
#include "asterfort/utmess.h"
    real(kind=8) :: symax, sigm, stlin, stpar
!
!     OPERATEUR POST_RCCM
!     CALCUL DU CRITERE DU ROCHET THERMIQUE
!
! IN  : SYMAX : LIMITE ELASTIQUE
! IN  : SIGM  : MAXIMUM DE LA CONTRAINTE DE MEMBRANE DUE A LA PRESSION
! OUT : STLIN : VALEUR MAXIMALE ADMISSIBLE DE L'AMPLITUDE DE VARIATION
!               D'ORIGINE THERMIQUE (VARIATION DE TEMPERATURE LINEAIRE)
! OUT : STPAR : VALEUR MAXIMALE ADMISSIBLE DE L'AMPLITUDE DE VARIATION
!             D'ORIGINE THERMIQUE (VARIATION DE TEMPERATURE PARABOLIQUE)
!     ------------------------------------------------------------------
!
    real(kind=8) :: x, yprim, valer(3)
!
#define linlin(x,x1,y1,x2,y2) y1+(x-x1)*(y2-y1)/(x2-x1)
! DEB ------------------------------------------------------------------
!
    x = sigm / symax
!
! --- VARIATION DE TEMPERATURE LINEAIRE DANS LA PAROI
!
    if (abs(x) .le. 1.0d-10) then
        yprim = 0.0d0
    else if (abs(x-1.0d0).le.1.0d-10) then
        yprim = 0.0d0
    else if (x.gt.0.0d0 .and. x.le.0.50d0) then
        yprim = 1.0d0 / x
!
    else if (x.gt.0.50d0 .and. x.le.1.0d0) then
        yprim = 4.0d0 * ( 1.0d0 - x )
!
    else
        stlin = r8vide()
        valer(1) = x
        valer(2) = sigm
        valer(3) = symax
        call utmess('I', 'POSTRCCM_5', nr=3, valr=valer)
        goto 9998
    endif
    stlin = yprim * symax
!
9998  continue
!
! --- VARIATION DE TEMPERATURE PARABOLIQUE DANS LA PAROI
!
    if (abs(x) .le. 1.0d-10) then
        yprim = 0.0d0
    else if (abs(x-1.0d0).le.1.0d-10) then
        yprim = 0.0d0
    else if (x.ge.0.615d0 .and. x.lt.1.0d0) then
        yprim = 5.2d0 * ( 1.0d0 - x )
!
    else if (x.ge.0.5d0 .and. x.lt.0.615d0) then
        yprim = linlin( x, 0.5d0,2.7d0, 0.615d0,2.002d0 )
!
    else if (x.ge.0.4d0 .and. x.lt.0.5d0) then
        yprim = linlin( x, 0.4d0,3.55d0, 0.5d0,2.7d0 )
!
    else if (x.ge.0.3d0 .and. x.lt.0.4d0) then
        yprim = linlin( x, 0.3d0,4.65d0, 0.4d0,3.55d0 )
!
    else
        stpar = r8vide()
        valer(1) = x
        valer(2) = sigm
        valer(3) = symax
        call utmess('I', 'POSTRCCM_6', nr=3, valr=valer)
        goto 9999
    endif
    stpar = yprim * symax
!
9999  continue
!
end subroutine
