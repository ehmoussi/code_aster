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

subroutine nmepsi(ndim, nno, axi, grand, vff,&
                  r, dfdi, depl, f, eps)
!
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/r8inir.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/ddot.h"
    aster_logical :: axi, grand
    integer :: ndim, nno
    real(kind=8) :: vff(nno), r, dfdi(nno, ndim), depl(ndim, nno), f(3, 3)
    real(kind=8) :: eps(6)
! ----------------------------------------------------------------------
!                     CALCUL DES DEFORMATIONS
!
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  NNO     : NOMBRE DE NOEUDS
! IN  AXI     : .TRUE. SI AXISYMETRIQUE
! IN  GRAND   : .TRUE.  --> CALCUL DE F(3,3)
!               .FALSE. --> CALCUL DE EPS(6)
! IN  VFF     : VALEURS DES FONCTIONS DE FORME (POINT DE GAUSS COURANT)
! IN  R       : RAYON DU POINT COURANT (EN AXI)
! IN  DFDI    : DERIVEE DES FONCTIONS DE FORME (POINT DE GAUSS COURANT)
! IN  DEPL    : DEPLACEMENTS NODAUX
! OUT F       : GRADIENT DE LA TRANSFORMATION F(3,3) : SI GRAND=.TRUE.
! OUT EPS     : DEFORMATIONS LINEARISEES EPS(6)      : SI GRAND=.FALSE.
! ----------------------------------------------------------------------
!
    integer :: i, j
    real(kind=8) :: grad(3, 3), ur, r2, kron(3, 3)
    data kron/1.d0,0.d0,0.d0, 0.d0,1.d0,0.d0, 0.d0,0.d0,1.d0/
! ----------------------------------------------------------------------
!
! - INITIALISATION
!
    r2 = sqrt(2.d0)/2.d0
    call r8inir(9, 0.d0, grad, 1)
!
!
! - CALCUL DES GRADIENT : GRAD(U)
!
    do 10 i = 1, ndim
        do 20 j = 1, ndim
            grad(i,j) = ddot(nno,dfdi(1,j),1,depl(i,1),ndim)
 20     continue
 10 end do
!
!
! - CALCUL DU DEPLACEMENT RADIAL
    if (axi) ur=ddot(nno,vff,1,depl,ndim)
!
!
! - CALCUL DU GRADIENT DE LA TRANSFORMATION F
!
    call dcopy(9, kron, 1, f, 1)
    if (grand) then
        call daxpy(9, 1.d0, grad, 1, f,&
                   1)
        if (axi) f(3,3) = f(3,3) + ur/r
    endif
!
!
! - CALCUL DES DEFORMATIONS LINEARISEES EPS
!
    if (.not. grand) then
        eps(1) = grad(1,1)
        eps(2) = grad(2,2)
        eps(3) = 0.d0
        eps(4) = r2*(grad(1,2)+grad(2,1))
!
        if (axi) eps(3) = ur/r
!
        if (ndim .eq. 3) then
            eps(3) = grad(3,3)
            eps(5) = r2*(grad(1,3)+grad(3,1))
            eps(6) = r2*(grad(2,3)+grad(3,2))
        endif
    endif
!
end subroutine
