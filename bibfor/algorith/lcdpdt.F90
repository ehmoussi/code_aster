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

function lcdpdt(a,b)
    implicit none
#include "asterfort/assert.h"

    real(kind=8),intent(in) :: a(:),b(:)
    real(kind=8)            :: lcdpdt(size(a),size(a))
! --------------------------------------------------------------------------------------------------
!   Calcule l'application lineaire (i.e. la matrice)  X --> A*X*B + B*X*A en notations symétriques
! --------------------------------------------------------------------------------------------------
!   in a: tenseur A (1:4 ou 1:6)
!   in b: tenseur B (1:4 ou 1:6)
!   ret : tenseur resultat d'ordre 4 (1:4,1:4) ou (1:6,1:6)
! --------------------------------------------------------------------------------------------------
    real(kind=8), parameter:: unsrac = 1/sqrt(2.d0)
! --------------------------------------------------------------------------------------------------

    ASSERT(size(a).eq.size(b))
    ASSERT(size(a).eq.4 .or. size(a).eq.6)


    if (size(a).eq.6) then

        lcdpdt(1,1) = a(1)*b(1)*2
        lcdpdt(1,2) = a(4)*b(4)
        lcdpdt(1,3) = a(5)*b(5)

        lcdpdt(2,1) = a(4)*b(4)
        lcdpdt(2,2) = a(2)*b(2)*2
        lcdpdt(2,3) = a(6)*b(6)

        lcdpdt(3,1) = a(5)*b(5)
        lcdpdt(3,2) = a(6)*b(6)
        lcdpdt(3,3) = a(3)*b(3)*2

        lcdpdt(1,4) =  a(1)*b(4) + a(4)*b(1)
        lcdpdt(1,5) =  a(1)*b(5) + a(5)*b(1)
        lcdpdt(1,6) = (a(4)*b(5) + a(5)*b(4))*unsrac

        lcdpdt(2,4) =  a(2)*b(4) + a(4)*b(2)  
        lcdpdt(2,5) = (a(4)*b(6) + a(6)*b(4))*unsrac
        lcdpdt(2,6) =  a(2)*b(6) + a(6)*b(2)

        lcdpdt(3,4) = (a(5)*b(6) + a(6)*b(5))*unsrac
        lcdpdt(3,5) =  a(5)*b(3) + a(3)*b(5)
        lcdpdt(3,6) =  a(6)*b(3) + a(3)*b(6)

        lcdpdt(4,1) =  a(1)*b(4) + a(4)*b(1)
        lcdpdt(4,2) =  a(4)*b(2) + a(2)*b(4)
        lcdpdt(4,3) = (a(5)*b(6) + a(6)*b(5))*unsrac

        lcdpdt(5,1) =  a(1)*b(5) + a(5)*b(1)
        lcdpdt(5,2) = (a(4)*b(6) + a(6)*b(4))*unsrac
        lcdpdt(5,3) =  a(5)*b(3) + a(3)*b(5)

        lcdpdt(6,1) = (a(4)*b(5) + a(5)*b(4))*unsrac
        lcdpdt(6,2) =  a(6)*b(2) + a(2)*b(6)
        lcdpdt(6,3) =  a(6)*b(3) + a(3)*b(6)

        lcdpdt(4,4) = a(1)*b(2) + a(4)*b(4) + a(2)*b(1)
        lcdpdt(4,5) = (a(1)*b(6) + a(6)*b(1))*unsrac + (a(5)*b(4) + a(4)*b(5))*0.5d0
        lcdpdt(4,6) = (a(5)*b(2) + a(2)*b(5))*unsrac + (a(4)*b(6) + a(6)*b(4))*0.5d0 

        lcdpdt(5,4) = (a(1)*b(6) + a(6)*b(1))*unsrac + (a(4)*b(5)+a(5)*b(4))*0.5d0
        lcdpdt(5,5) = a(1)*b(3) + a(3)*b(1) + a(5)*b(5)
        lcdpdt(5,6) = (a(4)*b(3) + a(3)*b(4))*unsrac + (a(5)*b(6) + a(6)*b(5))*0.5d0 

        lcdpdt(6,4) = (a(2)*b(5) + a(5)*b(2))*unsrac + (a(4)*b(6)+a(6)*b(4))*0.5d0
        lcdpdt(6,5) = (a(3)*b(4) + a(4)*b(3))*unsrac + (a(6)*b(5) + a(5)*b(6))*0.5d0
        lcdpdt(6,6) = a(2)*b(3) + a(3)*b(2) + a(6)*b(6) 


    else if (size(a).eq.4) then

        lcdpdt(1,1) = a(1)*b(1)*2
        lcdpdt(1,2) = a(4)*b(4)
        lcdpdt(1,3) = 0

        lcdpdt(2,1) = a(4)*b(4)
        lcdpdt(2,2) = a(2)*b(2)*2
        lcdpdt(2,3) = 0

        lcdpdt(3,1) = 0
        lcdpdt(3,2) = 0
        lcdpdt(3,3) = a(3)*b(3)*2

        lcdpdt(1,4) =  a(1)*b(4) + a(4)*b(1)
        lcdpdt(2,4) =  a(2)*b(4) + a(4)*b(2)  
        lcdpdt(3,4) =  0

        lcdpdt(4,1) =  a(1)*b(4) + a(4)*b(1)
        lcdpdt(4,2) =  a(4)*b(2) + a(2)*b(4)
        lcdpdt(4,3) =  0

        lcdpdt(4,4) = a(1)*b(2) + a(4)*b(4) + a(2)*b(1)

    end if

end function lcdpdt
