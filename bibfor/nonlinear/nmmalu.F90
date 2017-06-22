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

subroutine nmmalu(nno, axi, r, vff, dfdi,&
                  lij)
!
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/r8inir.h"
#include "blas/dcopy.h"
#include "blas/dscal.h"
    aster_logical :: axi
    integer :: nno, lij(3, 3)
    real(kind=8) :: dfdi(nno, 4), vff(nno), r
!
! ----------------------------------------------------------------------
!                     CALCUL DE LA MATRICE L :  GRAD(U) = L.U
!
! IN  NNO     : NOMBRE DE NOEUDS
! IN  AXI     : .TRUE. SI AXISYMETRIQUE
! IN  R       : RAYON AU POINT DE GAUSS CONSIDERE (UTILE EN AXI)
! IN  VFF     : FONCTIONS DE FORME AU POINT DE GAUSS CONSIDERE
! VAR DFDI    : IN  : DERIVEE DES FONCTIONS DE FORME
!               OUT : MATRICE L (AVEC LIJ)
!                --> DDL (N,I) ET VAR J  -> DFDI(N,LIJ(I,J))
! OUT LIJ     : INDIRECTION POUR ACCEDER A L
! ----------------------------------------------------------------------
!
!
!    CAS 2D OU 3D STANDARD
    if (.not. axi) then
        lij(1,1) = 1
        lij(1,2) = 2
        lij(1,3) = 3
        lij(2,1) = 1
        lij(2,2) = 2
        lij(2,3) = 3
        lij(3,1) = 1
        lij(3,2) = 2
        lij(3,3) = 3
        goto 9999
    endif
!
! CAS AXISYMETRIQUE
    lij(1,1) = 1
    lij(1,2) = 2
    lij(1,3) = 4
    lij(2,1) = 1
    lij(2,2) = 2
    lij(2,3) = 4
    lij(3,1) = 4
    lij(3,2) = 4
    lij(3,3) = 3
!
!    TERME EN N/R : DERIVATION 3,3
    call dcopy(nno, vff, 1, dfdi(1, 3), 1)
    call dscal(nno, 1/r, dfdi(1, 3), 1)
!
!    TERME NUL : DERIVATION 1,3  2,3  3,1  3,2
    call r8inir(nno, 0.d0, dfdi(1, 4), 1)
!
9999 continue
end subroutine
