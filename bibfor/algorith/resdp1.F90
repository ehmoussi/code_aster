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

subroutine resdp1(materf, seq, i1e, pmoins, dp,&
                  plas)
    implicit none
#include "asterfort/schdp1.h"
#include "asterfort/utmess.h"
    real(kind=8) :: materf(5, 2), pmoins, dp, seq, i1e, plas, pptest, fcrit0
! =====================================================================
! --- RESOLUTION NUMERIQUE --------------------------------------------
! =====================================================================
    integer :: ndt, ndi
    real(kind=8) :: young, nu, troisk, deuxmu, sy, h, pult
    real(kind=8) :: trois, deux, un, fcrit, valpro
    real(kind=8) :: a1, valcoe, b2, a
! =====================================================================
    parameter ( trois  =  3.0d0 )
    parameter ( deux   =  2.0d0 )
    parameter ( un     =  1.0d0 )
! =====================================================================
    common /tdim/   ndt, ndi
! =====================================================================
! --- AFFECTATION DES VARIABLES ---------------------------------------
! =====================================================================
    young = materf(1,1)
    nu = materf(2,1)
    troisk = young / (un-deux*nu)
    deuxmu = young / (un+nu)
    sy = materf(1,2)
    h = materf(2,2)
    a = materf(3,2)
    pult = materf(4,2)
! =====================================================================
! --- CALCUL ELASTIQUE ------------------------------------------------
! =====================================================================
    fcrit = schdp1(seq, i1e, sy, h, a, pult, pmoins)
! =====================================================================
! --- CALCUL PLASTIQUE ------------------------------------------------
! =====================================================================
    if (fcrit .gt. 0.0d0) then
        plas = 1.0d0
        if (pmoins .lt. pult) then
            a1 = trois * deuxmu / deux + trois * troisk * a * a + h
            if (a1 .eq. 0.0d0) then
                call utmess('F', 'ALGORITH10_41')
            endif
            dp = fcrit / a1
            valcoe = pult - pmoins
            if (dp .gt. valcoe) then
                fcrit = schdp1(seq, i1e, sy, h, a, pult, pult)
                b2 = trois * deuxmu / deux + trois * troisk * a * a
                if (b2 .eq. 0.0d0) then
                    call utmess('F', 'ALGORITH10_42')
                endif
                dp = fcrit / b2
            endif
        else
            b2 = trois * deuxmu / deux + trois * troisk * a * a
            if (b2 .eq. 0.0d0) then
                call utmess('F', 'ALGORITH10_42')
            endif
            dp = fcrit / b2
        endif
    else
        plas = 0.0d0
        dp = 0.0d0
    endif
!
! =====================================================================
! --- PROJECTION AU SOMMET --------------------------------------------
! =====================================================================
    pptest = pmoins + dp
    b2 = trois * troisk * a * a
    fcrit0 = schdp1(0.0d0, i1e, sy, h, a, pult, pptest)
    valpro = fcrit0 / b2
!
    if ((plas.eq.1) .and. (dp.le.valpro)) then
        plas = 2.0d0
        fcrit = schdp1(0.0d0, i1e, sy, h, a, pult, pmoins)
        if (pmoins .lt. pult) then
            a1 = trois * troisk * a * a + h
            if (a1 .eq. 0.0d0) then
                call utmess('F', 'ALGORITH10_41')
            endif
            dp = fcrit / a1
            valcoe = pult - pmoins
            if (dp .gt. valcoe) then
                fcrit = schdp1(0.0d0, i1e, sy, h, a, pult, pult)
                dp = fcrit / b2
            endif
        else
            dp = fcrit / b2
        endif
    endif
! =====================================================================
end subroutine
