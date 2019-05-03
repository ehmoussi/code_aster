! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
!
subroutine nzfpri(deuxmu  , trans, rprim , seuil,&
                  nb_phase, phase, zalpha,&
                  fmel    , eta  , unsurn,&
                  dt      , dp   , &
                  fplas   , fp   , fd    ,&
                  fprim   , fdevi)
!
implicit none
!
real(kind=8), intent(in) :: deuxmu, trans, rprim, seuil
integer, intent(in) :: nb_phase
real(kind=8), intent(in) :: phase(nb_phase), zalpha
real(kind=8), intent(in) :: fmel, eta(nb_phase), unsurn(nb_phase), dt, dp
real(kind=8), intent(out) :: fplas, fp(nb_phase), fd(nb_phase), fprim, fdevi
!
! --------------------------------------------------------------------------------------------------
!
! Comportment - Metallurgy
!
! FONCTION FPRIM(X) POUR LOI VISCOPLASTIQUE AVEC METALLURGIE
!
! --------------------------------------------------------------------------------------------------
!
!  CALCUL DE DP ==> RESOLUTION DE L'EQUATION SCALAIRE NON LINEAIRE
!                   FPRIM = 0
!
! In  deuxmu           : elastic parameter - Lame coefficient
! In  trans            : parameter for transformation plasticity
! In  rprim            : derivative of hardening curve
! In  seuil
! In  nb_phase         : total number of phase (cold and hot)
! In  phase            : phases
! In  zalpha           : sum of cold phases
! In  fmel             : mixing function
! In  eta              : viscosity parameter - eta
! In  unsurn           : viscosity parameter - 1/n
! In  dt               : time increment
! In  dp               : hardening increment
! OUT FPLAS            : VALEUR DE LA COMPOSANTE PLASTIQUE DE FPRIM
! OUT FPRIM            : VALEUR DE FPRIM
! OUT FDEVI            : DERIVEE DE FPRIM PAR RAPPORT A DP (SI DP>0)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_phase
    real(kind=8) :: spetra, r0, fz(5)
!
! --------------------------------------------------------------------------------------------------
!
    spetra = 1.5d0*deuxmu*trans +1.d0
    r0     = 1.5d0*deuxmu + rprim*spetra
    fplas  = seuil - r0*dp
!
    if (zalpha .gt. 0.d0) then
        do i_phase = 1, nb_phase-1
            fz(i_phase) = fmel*phase(i_phase)/zalpha
        end do
    else
        do i_phase = 1, nb_phase-1
            fz(i_phase) = 0.d0
        end do
    endif
    fz(nb_phase) = (1.d0-fmel)
    fprim        = fplas
    do i_phase = 1, nb_phase
        if (phase(i_phase) .gt. 0.d0) then
            fp(i_phase) = fplas-spetra*eta(i_phase)*((dp/dt)**unsurn(i_phase))
        else
            fp(i_phase) = 0.d0
        endif
        fprim = fprim - spetra*fz(i_phase)*eta(i_phase)*((dp/dt)**unsurn(i_phase))
    end do
    if (dp .gt. 0.d0) then
        fdevi = -r0
        do i_phase = 1, nb_phase
            fd(i_phase) = -r0-(eta(i_phase)*spetra/dt**unsurn(i_phase))*&
                          unsurn(i_phase)*dp**(unsurn(i_phase)-1)
            fdevi       = fdevi-&
                          fz(i_phase)*(eta(i_phase)*spetra/dt**unsurn(i_phase))*&
                          unsurn(i_phase)*dp**(unsurn(i_phase)- 1)
        end do
    endif
end subroutine
