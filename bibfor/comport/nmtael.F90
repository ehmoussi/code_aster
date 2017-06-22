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

subroutine nmtael(fami, kpg, ksp, imate, ndimsi,&
                  matm, mat, sigm, epsm, deps,&
                  epm, sigdv, sigp)
!
    implicit none
!
#include "asterfort/verift.h"
    integer :: kpg, ksp, ndimsi, imate
    character(len=*) :: fami
    real(kind=8) :: matm(3), mat(3)
    real(kind=8) :: sigm(ndimsi), epsm(ndimsi), deps(ndimsi)
    real(kind=8) :: sigdv(ndimsi), epm(ndimsi), sigp(ndimsi)
!
! ----------------------------------------------------------------------
! TAHERI :  CALCUL DES CONTRAINTES ELASTIQUES ET DEFORMATIONS PLASTIQUES
! ----------------------------------------------------------------------
! IN  NDIMSI DIMENSION DES TENSEURS
! IN  MATM   CARACTERISTIQUES ELASTIQUES EN T-
! IN  MAT    CARACTERISTIQUES ELASTIQUES EN T+
! IN  SIGM   CONTRAINTES EN T-
! IN  DEPS   INCREMENT DE DEFORMATION
! OUT EPM    DEFORMATIONS PLASTIQUES EN T-
! OUT SIGDV  DEVIATEUR DES CONTRAINTES ELASTIQUES
! OUT SIGP   TENSEUR DES CONTRAINTES ELASTIQUES
! ----------------------------------------------------------------------
!
    integer :: k
    real(kind=8) :: troikm, deumum
    real(kind=8) :: troisk, deuxmu
    real(kind=8) :: epmmo
    real(kind=8) :: depsth, depsme(6), depsmo, depsdv(6)
    real(kind=8) :: sigmom, sigdvm(6), sigmo
    real(kind=8) :: kron(6)
    data    kron /1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/
!
    call verift(fami, kpg, ksp, 'T', imate,&
                epsth_=depsth)
!
    troikm = matm(1)
    deumum = matm(2)
    troisk = mat(1)
    deuxmu = mat(2)
!
!    CALCUL DES DEFORMATIONS PLASTIQUES AU TEMPS -
    do k = 1, ndimsi
        epm(k) = epsm(k) - sigm(k)/deumum
    end do
    epmmo = (epm(1)+epm(2)+epm(3)) / 3.d0
    do k = 1, 3
        epm(k) = epm(k) - epmmo
    end do
!
!    PARTS HYDROSTATIQUES ET DEVIATORIQUES DE L'INCR. DEFO. MECANIQUE
    do k = 1, ndimsi
        depsme(k) = deps(k) - depsth*kron(k)
    end do
    depsmo = (depsme(1)+depsme(2)+depsme(3))/3.d0
    do k = 1, ndimsi
        depsdv(k) = depsme(k) - depsmo * kron(k)
    end do
!
!
!    PART HYDROSTATIQUE DES CONTRAINTES
    sigmom = (sigm(1)+sigm(2)+sigm(3))/3.d0
    sigmo = troisk/troikm*sigmom + troisk*depsmo
!
!
!    PART DEVIATORIQUE DES CONTRAINTES ELASTIQUES
    do k = 1, ndimsi
        sigdvm(k) = sigm(k) - sigmom*kron(k)
        sigdv(k) = deuxmu/deumum*sigdvm(k) + deuxmu*depsdv(k)
    end do
!
!
!    CONTRAINTES ELASTIQUES
    do k = 1, ndimsi
        sigp(k) = sigmo*kron(k) + sigdv(k)
    end do
!
end subroutine
