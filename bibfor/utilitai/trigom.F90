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

function trigom(fonc, x)
! person_in_charge: jacques.pellet at edf.fr
! aslint: disable=
    implicit none
    real(kind=8) :: trigom
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
    character(len=4) :: fonc
! ----------------------------------------------------------------------
!  BUT : CALCULER ASIN(X) OU ACOS(X) SANS RISQUER DE SE PLANTER SI
!        X SORT LEGEREMENT DE L'INTERVALLE (-1,1) (TOLERANCE 1.D-12)
!
!    IN:
!       FONC    K4 : /'ASIN'   /'ACOS'   : FONCTION A EVALUER
!       X       R8 : NOMBRE DONT ON CHERCHE ARC-SINUS (OU ARC-COSINUS)
!    OUT:
!       TRIGOM  R8 : ARC-SINUS OU (ARC-COSINUS) DE X
!
! ----------------------------------------------------------------------
    real(kind=8) :: x, eps, x2
    eps = 1.d-12
!
    if ((x.gt.1.d0+eps) .or. (x.lt.-1.d0-eps)) then
        call utmess('F', 'UTILITAI5_50')
    endif
!
    x2 = x
    if (x .gt. 1.d0) x2 = 1.d0
    if (x .lt. -1.d0) x2 = -1.d0
!
    ASSERT(fonc.eq.'ASIN' .or. fonc.eq.'ACOS')
    if (fonc .eq. 'ASIN') then
        trigom = asin(x2)
    else
        trigom = acos(x2)
    endif
!
end function
