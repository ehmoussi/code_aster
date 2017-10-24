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

subroutine ngforc(w, b, ni2ldc, sigmam, fint)
!
    implicit none
!
#include "blas/dgemv.h"

    real(kind=8),intent(in) :: w(:,:), ni2ldc(:,:), b(:,:,:)
    real(kind=8),intent(in) :: sigmam(size(w,1),size(w,2))
    real(kind=8) :: fint(*)
! ----------------------------------------------------------------------
! OPTION FORC_NODA - FORMULATION GENERIQUE
! ----------------------------------------------------------------------
! IN  W       : POIDS DES POINTS DE GAUSS (POUR CHAQUE COMPOSANTE)
! IN  B       : MATRICE CINEMATIQUE : DEFORMATION = B.DDL
! IN  LI2LDC  : CONVERSION CONTRAINTE STOCKEE -> CONTRAINTE LDC (RAC2)
! IN  SIGMAM  : CONTRAINTES A L'INSTANT PRECEDENT
! OUT FINT    : FORCES INTERIEURES
! ----------------------------------------------------------------------
    integer :: nepg, nddl
    real(kind=8) :: sigm(size(w,1),size(w,2))
! ----------------------------------------------------------------------
!
!    INITIALISATION
    nepg = size(w)
    nddl = size(b)/nepg
!
!    CONTRAINTE AVEC RAC2 ET POIDS DU POINT DE GAUSS
    sigm = sigmam*ni2ldc*w
    
!    FINT = SOMME(G) WG.BT.SIGMA
    call dgemv('T', nepg, nddl, 1.d0, b,&
               nepg, sigm, 1, 0.d0, fint,&
               1)
!
end subroutine
