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

subroutine lkcaln(s, b, vecn, retcom)
!
    implicit none
#include "asterc/r8miem.h"
#include "asterfort/lcprsc.h"
#include "asterfort/utmess.h"
    integer :: retcom
    real(kind=8) :: b, s(6), vecn(6)
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
! =================================================================
! --- BUT : CALCUL DE N -------------------------------------------
! =================================================================
! IN  : S      : DEVIATEUR DES CONTRAINTES ------------------------
! --- : B      : PARAMETRE DU CALCUL DE LA NORMALE ----------------
! OUT : VECN   : N = (B*S/SII-I)/SQRT(B**2+3) ---------------------
! =================================================================
    integer :: i, ndt, ndi
    real(kind=8) :: sii, racine, un, trois, kron(6), zero
    real(kind=8) :: ptit
! =================================================================
! --- INITIALISATION DE PARAMETRE ---------------------------------
! =================================================================
    parameter       ( un      =   1.0d0  )
    parameter       ( trois   =   3.0d0  )
    parameter       ( zero    =   0.0d0  )
! =================================================================
    common /tdim/   ndt , ndi
! =================================================================
    data    kron    /un     ,un     ,un     ,zero   ,zero  ,zero/
! --- INITIALISATION ----------------------------------------------
! =================================================================
    retcom = 0
    ptit = r8miem()
    call lcprsc(s, s, sii)
    sii = sqrt (sii)
    if (sii .lt. ptit) then
        call utmess('A', 'COMPOR1_31')
        retcom = 1
        goto 1000
    endif
! =================================================================
! --- CALCUL DE N -------------------------------------------------
! =================================================================
    racine = sqrt(b*b + trois)
    do 10 i = 1, ndt
        vecn(i) = (b*s(i)/sii-kron(i))/racine
10  end do
! =================================================================
1000  continue
end subroutine
