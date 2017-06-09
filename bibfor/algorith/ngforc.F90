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

subroutine ngforc(nddl, neps, npg, w, b,&
                  ni2ldc, sigmam, fint)
!
    implicit none
!
#include "blas/dgemv.h"
    integer :: nddl, neps, npg
    real(kind=8) :: w(0:npg-1), ni2ldc(0:neps-1), b(neps*npg*nddl)
    real(kind=8) :: sigmam(0:neps*npg-1), fint(nddl)
! ----------------------------------------------------------------------
! OPTION FORC_NODA - FORMULATION GENERIQUE
! ----------------------------------------------------------------------
! IN  NDDL    : NOMBRE DE DEGRES DE LIBERTE
! IN  NEPS    : NOMBRE DE COMPOSANTES DE DEFORMATION ET CONTRAINTE
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  W       : POIDS DES POINTS DE GAUSS
! IN  B       : MATRICE CINEMATIQUE : DEFORMATION = B.DDL
! IN  LI2LDC  : CONVERSION CONTRAINTE STOCKEE -> CONTRAINTE LDC (RAC2)
! IN  SIGMAM  : CONTRAINTES A L'INSTANT PRECEDENT
! OUT FINT    : FORCES INTERIEURES
! ----------------------------------------------------------------------
    integer :: npgmax, epsmax
    parameter (npgmax=27,epsmax=20)
! ----------------------------------------------------------------------
    integer :: nepg, ieg
    real(kind=8) :: sigm(0:epsmax*npgmax-1)
! ----------------------------------------------------------------------
!
!    INITIALISATION
    nepg = neps*npg
!
!    CONTRAINTE AVEC RAC2 ET POIDS DU POINT DE GAUSS
    do 10 ieg = 0, nepg-1
        sigm(ieg) = sigmam(ieg)*ni2ldc(mod(ieg,neps))*w(ieg/neps)
10  end do
!
!    FINT = SOMME(G) WG.BT.SIGMA
    call dgemv('T', nepg, nddl, 1.d0, b,&
               nepg, sigm, 1, 0.d0, fint,&
               1)
!
end subroutine
