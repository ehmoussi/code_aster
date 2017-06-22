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

subroutine calcfp(mutrbe, rprim, seuil, dt, dp,&
                  sigm0, epsi0, coefm, fplas, fprim,&
                  dfprim)
    implicit none
    real(kind=8) :: mutrbe, rprim, seuil, dt, dp, sigm0, epsi0, coefm
    real(kind=8) :: fplas, fprim, dfprim
!
!-------------------------------------------------------------------
!  FONCTION FPRIM(X) POUR LOI VISCOPLASTIQUE EN SINH
!  CALCUL DE DP ==> RESOLUTION DE L'EQUATION SCALAIRE NON LINEAIRE
!                   FPRIM + FPLAS + SIGM0* ARGSH((DP/DT/EPSI0)^(1/M))
!  IN MUTRBE : MU * TR(Bel)
!  IN RPRIM  : ECROUISSAGE
!  IN SEUIL  : VALEUR DE F=SIGEQ-SIGY - R
!  IN DT     : PAS DE TEMPS
!  IN  DP    : DP RECHERCHE LORS DE LA RESOLUTION SCALAIRE
!  IN SIGM0,EPSI0, COEFM : PARAMETRE LOI VISQUEUSE
!  OUT FPLAS : VALEUR DE LA COMPOSANTE PLASTIQUE DE FPRIM
!  OUT FPRIM : VALEUR DE FPRIM
!  OUT DFPRIM : DERIVEE DE FPRIM PAR RAPPORT A DP (SI DP>0)
!--------------------------------------------------------------------
!
    real(kind=8) :: r0, arg, asinh
!
!
    r0 = mutrbe + rprim
    fplas = seuil - r0*dp
    arg = (dp/dt/epsi0)**(1.d0/coefm)
    asinh = log(arg+sqrt(arg**2+1))
    fprim = fplas - sigm0 * asinh
!
!    CALCUL DE LA DERIVEE DE FPRIM
!
    if (dp .gt. 0.d0) then
        dfprim = - r0 + sigm0 / sqrt(arg**2+1.d0) / coefm / (dt*epsi0) **(1.d0/coefm) * dp**(1.d0&
                 &/coefm - 1)
    endif
!
end subroutine
