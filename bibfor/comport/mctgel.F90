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

subroutine mctgel(dydx, rprops)
! ----------------------------------------------------------------------
!
! OBJECT: COMPUTE THE ELASTIC HOOK MATRIX
!
! ----------------------------------------------------------------------
!
!     LOI DE COMPORTEMENT DE MOHR-COULOMB
!
! IN  RPROPS  : LISTE DES PROPRIETES MECANIQUES
!
! OUT DYDX    : MATRICE ELASTIQUE DE HOOK
!
! ----------------------------------------------------------------------
    implicit none
! ======================================================================
!
    real(kind=8) :: dydx(6, 6)
    real(kind=8) :: rprops(*)
!
#include "asterfort/matini.h"
!
! Declaration of integer type variables
    integer :: i, j, ndim, mdim
!
    parameter (   ndim=6    ,mdim=3     )
!
    real(kind=8) :: foid(mdim,mdim), young, poiss
    real(kind=8) :: gmodu, bulk, factor
    real(kind=8) :: r0, r1, r2, r3, r4, r2g, r1d3
!
    data  r0    ,r1    ,r2    ,r3    ,r4    /&
     &    0.0d0 ,1.0d0 ,2.0d0 ,3.0d0 ,4.0d0 /
!***********************************************************************
!
! COMPUTATION OF THE TANGENT MODULUS (ELASTICITY MATRIX) FOR THE LINEAR
! ELASTIC MATERIAL MODEL
!
!***********************************************************************
    call matini(mdim, mdim, r0, foid)
    call matini(ndim, ndim, r0, dydx)
    foid(1,1)=r1
    foid(2,2)=r1
    foid(3,3)=r1
!
! Set shear and bulk modulus
! --------------------------
    young=rprops(2)
    poiss=rprops(3)
    gmodu=young/(r2*(r1+poiss))
    bulk =young/(r3*(r1-r2*poiss))
    r1d3=r1/r3
    r2g=r2*gmodu
    factor=bulk-r2g*r1d3
!
! Assemble matrix
!
    do 10 i = 1, mdim
        dydx(mdim+i,mdim+i)=r2g
        do 11 j = 1, mdim
            dydx(i,j)=r2g*foid(i,j)+factor
11      continue
10  continue
!
end subroutine
