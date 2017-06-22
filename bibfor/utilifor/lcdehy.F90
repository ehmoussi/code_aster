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

subroutine lcdehy(fami, kpg, ksp, nmat, materd,&
                  materf, depsm, epsdm)
    implicit none
!       RETRAIT DE DEFORMATION DUE AU RETRAIT ENDOGENE ET AU RETRAIT
!       DE DESSICCATION
!       POUR TENIR COMPTE DES CONTRAINTES DE RETRAIT :
!
!       ON RETIRE       - A DEPSM, L INCREMENT DE DEFORMATION DUE
!                         AU RETRAIT
!                       - ET A EPSDM , LE RETRAIT A T
!
!       POUR OBTENIR    - L'INCREMENT DE DEFORMATION MECANIQUE DEPSM
!                       - ET LA DEFORMATION MECANIQUE A T      EPSDM
!
!       ON A SIG = HOOK EPSE  = HOOK ( EPST - EPSP - EPSRET )
!                             = HOOK ( EPST - EPSP ) - HOOK EPSRET
!       DONC            SIG   = SIGM                 + SIGRET
!       AVEC            SIGRET= + HOOK (KAPPA*(SREF-SECH) + BETA*HYDR) I
!                       DE SIGNE OPPOSE A LA DEFORMATION THERMIQUE
!       OU   EN PRENANT EPS   = EPST - EPSRET
!                       SIG   = HOOK ( EPS - EPSP )
!
!       ON PEUT DONC - SOIT TRAVAILLER AVEC EPST ET AJOUTER SIGRET APRES
!                    - SOIT TRAVAILLER AVEC EPS = EPST - EPSRET
!                      CE QUI EST FAIT ICI
!       ----------------------------------------------------------------
!       IN      NMAT    DIMENSION  DE MATER
!               MATERD  COEFFICIENTS MATERIAU A T
!               MATERF  COEFFICIENTS MATERIAU A T+DT
!       VAR     DEPSM   INCREMENT DE DEFORMATION MECANIQUE
!               EPSDM   DEFORMATION MECANIQUE A T
!       ----------------------------------------------------------------
#include "asterfort/rcvarc.h"
    integer :: ndt, ndi, nmat, k, iret, kpg, ksp
    character(len=*) :: fami
    real(kind=8) :: hd, hf, sd, sf, sref
    real(kind=8) :: epsdm(6), depsm(6)
    real(kind=8) :: bendod, bendof, kdessd, kdessf
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2)
!       ----------------------------------------------------------------
    common /tdim/   ndt  , ndi
!       ----------------------------------------------------------------
!
    bendod = materd(4,1)
    bendof = materf(4,1)
    kdessd = materd(5,1)
    kdessf = materf(5,1)
    call rcvarc(' ', 'HYDR', '-', fami, kpg,&
                ksp, hd, iret)
    if (iret .ne. 0) hd=0.d0
    call rcvarc(' ', 'HYDR', '+', fami, kpg,&
                ksp, hf, iret)
    if (iret .ne. 0) hf=0.d0
    call rcvarc(' ', 'SECH', '-', fami, kpg,&
                ksp, sd, iret)
    if (iret .ne. 0) sd=0.d0
    call rcvarc(' ', 'SECH', '+', fami, kpg,&
                ksp, sf, iret)
    if (iret .ne. 0) sf=0.d0
    call rcvarc(' ', 'SECH', 'REF', fami, kpg,&
                ksp, sref, iret)
    if (iret .ne. 0) sref=0.d0
!
    do 110 k = 1, ndi
        depsm(k) = depsm(k) + ( bendof*hf - bendod*hd) + ( kdessf*( sref-sf) - kdessd*(sref-sd))
        epsdm(k) = epsdm(k) + bendod*hd + kdessd*(sref-sd)
110  continue
!
end subroutine
