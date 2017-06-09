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

subroutine lglord(sig1, sig2, sig3)
!
    implicit    none
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    real(kind=8) :: sig1, sig2, sig3
! --- BUT : ORDONNER LES CONTRAINTES PRINCIPALES ------------------
! ------- : TEL QUE |SIG1| > |SIG2| > |SIG3| ----------------------
! =================================================================
! IN/OUT : SIG1 :  CONTRAINTE MAXIMALE ----------------------------
! ------ : SIG2 :  CONTRAINTE INTERMEDIAIRE -----------------------
! ------ : SIG3 :  CONTRAINTE MINIMALE ----------------------------
! =================================================================
    real(kind=8) :: tmp
! =================================================================
    call jemarq()
! =================================================================
    if (abs(sig3) .gt. abs(sig1)) then
        tmp = sig1
        sig1 = sig3
        sig3 = tmp
    endif
    if (abs(sig2) .gt. abs(sig1)) then
        tmp = sig1
        sig1 = sig2
        sig2 = tmp
    endif
    if (abs(sig3) .gt. abs(sig2)) then
        tmp = sig2
        sig2 = sig3
        sig3 = tmp
    endif
! =================================================================
    call jedema()
! =================================================================
end subroutine
