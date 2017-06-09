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

subroutine virhol(nbvari, vintm, vintp, advihy, vihrho,&
                  rho110, dp1, dp2, dpad, cliq,&
                  dt, alpliq, signe, rho11, rho11m,&
                  retcom)
    implicit      none
    integer :: nbvari, retcom, advihy, vihrho
    real(kind=8) :: vintm(nbvari), vintp(nbvari), rho110, dp1, dp2, dpad, dt
    real(kind=8) :: cliq, signe, alpliq, rho11, rho11m
! --- CALCUL ET STOCKAGE DE LA VARIABLE INTERNE DE LA MASSE ------------
! --- VOLUMIQUE DE L EAU -----------------------------------------------
! ======================================================================
    real(kind=8) :: varbio, epxmax
    parameter    (epxmax = 5.d0)
! ======================================================================
! --- CALCUL DES ARGUMENTS EN EXPONENTIELS -----------------------------
! --- ET VERIFICATION DE LA COHERENCE ----------------------------------
! ======================================================================
    varbio = (dp2-signe*dp1-dpad)*cliq - 3.d0*alpliq*dt
    if (varbio .gt. epxmax) then
        retcom = 2
        goto 30
    endif
    vintp(advihy+vihrho) =&
     &              - rho110 + (vintm(advihy+vihrho)+rho110)*exp(varbio)
!
    rho11 = vintp(advihy+vihrho) + rho110
    rho11m = vintm(advihy+vihrho) + rho110
! ======================================================================
30  continue
! ======================================================================
! ======================================================================
end subroutine
