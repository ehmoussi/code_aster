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

subroutine ssdmge(geo1, geo2, para, dimgeo)
    implicit none
!     ARGUMENTS:
!     ----------
#include "asterfort/matrot.h"
    integer :: dimgeo
    real(kind=8) :: geo1(*), geo2(*), para(*)
! ----------------------------------------------------------------------
!     BUT:
!        - TRANSFORMER LA GEOMETRIE D'UN NOEUD PAR ROTATION/TRANSLATION
!
!     IN:
!        GEO1  : X1,Y1,Z1
!        PARA  : TX,TY,TZ,ALPHA,BETA,GAMMA,PX,PY,PZ
!                TX,TY,TZ: TRANSLATIONS SUIVANT X,Y,Z
!                ALPHA,BETA,GAMMA: ANGLES NAUTIQUES (EN RADIANS)
!                                  DE LA ROTATION
!                EN 2D:
!                      ALPHA= ANGLE DE ROTATION DANS LE PLAN XOY
!                      BETA=GAMMA=0
!                PX,PY,PZ: COORDONNEES DU POINT AUTOUR DUQUEL ON TOURNE
!        DIMGEO:  2   OU  3
!     OUT:
!        GEO2 : X2,Y2,Z2
!
! ======================================================================
!     CONVENTION IMPORTANTE : ON FAIT LA ROTATION AVANT LA TRANSLATION
! ======================================================================
    real(kind=8) :: geop(3), lambda(3, 3)
    integer :: i, j
!-----------------------------------------------------------------------
!
!     -- ROTATION:
!     ------------
!
!     -- ON RETRANCHE LE VECTEUR OP (CENTRE DE LA ROTATION):
    do 1, i=1,dimgeo
    geo2(i)=geo1(i)-para(6+i)
    1 end do
!
!     -- ON TOURNE LE VECTEUR PM AUTOUR DE P :
    call matrot(para(4), lambda)
    do 2, i=1,dimgeo
    geop(i)=0.0d0
    do 3, j=1,dimgeo
    geop(i)=geop(i)+lambda(j,i)*geo2(j)
 3  continue
    2 end do
!
!
!     -- TRANSLATION PAR LE VECTEUR T (ET LE VECTEUR OP QUE L'ON A OTE):
!     -----------------------------------------------------------------
    do 5, i=1,dimgeo
    geo2(i)=geop(i)+para(i)+para(6+i)
    5 end do
!
end subroutine
