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

subroutine zzpoly(nno, ino, xino, yino, sig,&
                  b)
    implicit none
#include "asterfort/utmess.h"
!
!    ESTIMATEUR ZZ2 (VERSION 92)
!
!  CETTE ROUTINE CALCULE LA VALEUR DES CONTRAINTES LISSEES AU NOEUD INO
!
!  ENTREE :
!       NNO   :  NOMBRE DE NOEUDS DE L'ELEMENT
!       INO   :  NUMERO GLOBAL DU NOEUD OU ON CALCULE LES CONTRAINTES
!  XINO, YINO :  COORDONNEES DU NOEUD INO
!       B     :  COEFFICIENTS DES MONOMES DU POLYNOME DE BASE
!
!  SORTIE :
!       SIG   :  CONTRAINTES LISSEES
!
    real(kind=8) :: xino, yino, sig(1), b(9, 4)
!-----------------------------------------------------------------------
    integer :: ic, ino, nno
!-----------------------------------------------------------------------
    if (nno .eq. 3) then
        do 3 ic = 1, 4
            sig(4*(ino-1)+ic) = sig( 4*(ino-1)+ic) + b(1,ic)+b(2,ic)* xino+b(3,ic )*yino
 3      continue
    else if (nno.eq.6) then
        do 4 ic = 1, 4
            sig(4*(ino-1)+ic) = sig(&
                                4*(ino-1)+ic) + b(1, ic)+b(2, ic)* xino+b(3, ic)*yino + b(4,&
                                ic)*xino*yino + b(5, ic)*xino*xino + b(6, ic&
                                )*yino*yino
 4      continue
    else if (nno.eq.4) then
        do 5 ic = 1, 4
            sig(4*(ino-1)+ic) = sig(&
                                4*(ino-1)+ic) + b(1, ic)+b(2, ic)* xino+b(3, ic)*yino + b(4, ic&
                                )*xino*yino
 5      continue
    else if (nno.eq.8) then
        do 6 ic = 1, 4
            sig(4*(ino-1)+ic) = sig(&
                                4*(ino-1)+ic) + b(1, ic)+b(2, ic)* xino+b(3, ic)*yino + b(4,&
                                ic)*xino*yino + b(5, ic)*xino*xino + b(6, ic)*yino*yino + b(7,&
                                ic)*xino*xino*yino + b(8, ic&
                                )* xino*yino*yino
 6      continue
    else if (nno.eq.9) then
        do 7 ic = 1, 4
            sig(4*(ino-1)+ic) = sig(&
                                4*(ino-1)+ic) + b(1, ic)+b(2, ic)* xino+b(3, ic)*yino + b(4,&
                                ic)*xino*yino + b(5, ic)*xino*xino + b(6, ic)*yino*yino + b(7,&
                                ic)*xino*xino*yino + b(8, ic)* xino*yino*yino + b(9, ic&
                                )*xino*xino*yino*yino
 7      continue
    else
        call utmess('F', 'ELEMENTS4_62')
    endif
end subroutine
