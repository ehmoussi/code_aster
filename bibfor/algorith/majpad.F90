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

subroutine majpad(p2, pvp, r, temp, kh,&
                  dp2, pvpm, dt, padp, padm,&
                  dpad)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/infniv.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
real(kind=8), intent(in) :: temp
!
    real(kind=8) :: p2, pvp, r, kh, dp2, pvpm, dt, padp, padm, dpad
! --- MISE A JOUR DE PRESSION D AIR DISSOUS ----------------------------
! ======================================================================
    integer :: iadzi, iazk24, niv, ifm
    character(len=8) :: nomail
! ======================================================================
! ======================================================================
! --- CALCUL DES ARGUMENTS EN EXPONENTIELS -----------------------------
! --- ET VERIFICATION DE COHERENCES ------------------------------------
! ======================================================================
    padp = (p2 - pvp)*r*temp/kh
    padm = ((p2-dp2) - pvpm)*r*(temp-dt)/kh
    dpad = padp - padm
    if (padp .lt. 0.d0) then
        call infniv(ifm, niv)
        if (niv .eq. 2) then
            call tecael(iadzi, iazk24)
            nomail = zk24(iazk24-1+3) (1:8)
            call utmess('I', 'COMPOR1_65', sk=nomail)
        endif
    endif
end subroutine
