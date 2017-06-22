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

subroutine nzfpri(deuxmu, trans, rprim, seuil, phasp,&
                  nz, fmel, eta, unsurn, dt,&
                  dp, fplas, fp, fd, fprim,&
                  fdevi)
    implicit none
!-------------------------------------------------------------------
!  FONCTION FPRIM(X) POUR LOI VISCOPLASTIQUE AVEC METALLURGIE
!
!  CALCUL DE DP ==> RESOLUTION DE L'EQUATION SCALAIRE NON LINEAIRE
!                   FPRIM = 0
!
!  IN  DP    : DP RECHERCHE LORS DE LA RESOLUTION SCALAIRE
!  OUT FPLAS : VALEUR DE LA COMPOSANTE PLASTIQUE DE FPRIM
!  OUT FPRIM : VALEUR DE FPRIM
!  OUT FDEVI : DERIVEE DE FPRIM PAR RAPPORT A DP (SI DP>0)
!--------------------------------------------------------------------
!
    integer :: nz, k
    real(kind=8) :: dp, fprim, fplas, fdevi
    real(kind=8) :: deuxmu, trans, rprim, seuil, eta(nz), unsurn(nz), dt
    real(kind=8) :: phasp(5), fp(nz), fd(5), fmel
!
    real(kind=8) :: spetra, r0, zalpha, fz(5)
!
    spetra = 1.5d0*deuxmu*trans +1.d0
    r0 = 1.5d0*deuxmu + rprim*spetra
    fplas = seuil - r0*dp
    zalpha =0.d0
    do 10 k = 1, nz-1
        zalpha=zalpha+phasp(k)
10  end do
    if (zalpha .gt. 0.d0) then
        do 20 k = 1, nz-1
            fz(k)=fmel*phasp(k)/zalpha
20      continue
    else
        do 21 k = 1, nz-1
            fz(k)=0.d0
21      continue
    endif
    fz(nz)=(1-fmel)
    fprim=fplas
    do 100 k = 1, nz
        if (phasp(k) .gt. 0.d0) then
            fp(k)=fplas-spetra*eta(k)*((dp/dt)**unsurn(k))
        else
            fp (k)=0.d0
        endif
        fprim = fprim - spetra*fz(k)*eta(k)*((dp/dt)**unsurn(k))
100  end do
    if (dp .gt. 0.d0) then
        fdevi=-r0
        do 200 k = 1, nz
            fd(k)=-r0-(eta(k)*spetra/dt**unsurn(k))*unsurn(k) *dp**(&
            unsurn(k)-1)
            fdevi = fdevi-fz(k)*(eta(k)*spetra/dt**unsurn(k)) *unsurn( k)*dp**(unsurn(k)- 1)
200      continue
!
    endif
end subroutine
