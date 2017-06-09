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

subroutine lcmfga(mode, eps, gameps, dgamde, itemax, precvg, iret)
    implicit none
#include "asterfort/lcmfdr.h"
#include "asterfort/lcmfra.h"
#include "asterfort/lcvalp.h"
    integer,intent(in) :: mode, itemax
    real(kind=8),intent(in) :: eps(6), precvg
    integer,intent(out):: iret
    real(kind=8),intent(out):: gameps, dgamde(6)
! --------------------------------------------------------------------------------------------------
!  CALCUL DE GAMMA(EPS) POUR LA LOI ENDO_SCALAIRE AVEC GRAD_VARI
! --------------------------------------------------------------------------------------------------
!  MODE    FONCTION RECHERCHEE (0=VALEUR, 1=VAL ET DER)
!  EPS     VALEUR DE L'ARGUMENT EPS(1:NDIMSI)
!  GAMEPS  FONCTION GAMMA(EPS) - SI MODE=1 OU MODE=0
!  DGAMDE  DERIVEE DE GAMMA    - SI MODE=1
!  PRECVG  PRECISION POUR CALCUL DE GAMMA: DGAM < PRECVG
!  IRET    0 SI OK, 1 SI PB POUR CALCULER LE RAYON
! --------------------------------------------------------------------------------------------------
    real(kind=8),parameter,dimension(6):: kr=(/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/)
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: treps, sig(6), sigvp(3), chi, dchids(6), coef, trchid, precx1
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: lambda, deuxmu, troisk, gamma, rigmin, pc, pr, epsth
    common /lcee/ lambda,deuxmu,troisk,gamma,rigmin,pc,pr,epsth
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: pk, pm, pp
    common /lces/ pk,pm,pp
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: pct, pch, pcs
    common /lcmqu/ pch,pct,pcs
! --------------------------------------------------------------------------------------------------
!
!  INITIALISATION: PRECISION RECHERCHEE SUR CHI * DCHI
    precx1 = 0.5d0*pm/pk*precvg         
!
!
!  CALCUL DE LA VALEUR
!
    treps = eps(1)+eps(2)+eps(3)
    sig = lambda*treps*kr + deuxmu*eps
    call lcvalp(sig, sigvp)
    call lcmfra(sigvp, itemax, precx1, chi, iret)
    if (iret .eq. 1) goto 999
    gameps = pk/pm*chi**2
!
!
!  CALCUL DE LA DERIVEE
!
    if (mode .eq. 1) then
!
        if (chi .ne. 0) then
            call lcmfdr(sig, sigvp, chi, precvg, dchids)
            coef = 2*pk/pm*chi
            trchid = dchids(1)+dchids(2)+dchids(3)
            dgamde = coef*(lambda*trchid*kr+deuxmu*dchids)
        else
            dgamde = 0
        endif
    endif
!
!
999 continue
end subroutine
