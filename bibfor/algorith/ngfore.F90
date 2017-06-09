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

subroutine ngfore(nddl, neps, npg, w, b,&
                  ni2ldc, sigref, fref)
!
    implicit none
!
    integer :: nddl, neps, npg
    real(kind=8) :: w(0:npg-1), ni2ldc(0:neps-1), b(0:neps*npg-1, nddl)
    real(kind=8) :: sigref(0:neps-1), fref(nddl)
! ----------------------------------------------------------------------
!     REFE_FORC_NODA - FORMULATION GENERIQUE
! ----------------------------------------------------------------------
! IN  NDDL    : NOMBRE DE DEGRES DE LIBERTE
! IN  NEPS    : NOMBRE DE COMPOSANTES DE DEFORMATION ET CONTRAINTE
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  W       : POIDS DES POINTS DE GAUSS
! IN  B       : MATRICE CINEMATIQUE : DEFORMATION = B.DDL
! IN  LI2LDC  : CONVERSION CONTRAINTE STOCKEE -> CONTRAINTE LDC (RAC2)
! IN  SIGREF  : CONTRAINTES DE REFERENCE (PAR COMPOSANTE)
! OUT FREF    : FORCES DE REFERENCE
! ----------------------------------------------------------------------
    integer :: npgmax, epsmax
    parameter (npgmax=27,epsmax=20)
! ----------------------------------------------------------------------
    integer :: nepg, ieg, i
    real(kind=8) :: sigpds(0:epsmax*npgmax-1)
! ----------------------------------------------------------------------
!
!    INITIALISATION
    nepg = neps*npg
!
!    CONTRAINTE AVEC RAC2 ET POIDS DU POINT DE GAUSS
    do 10 ieg = 0, nepg-1
        sigpds(ieg) = sigref(mod(ieg,neps))*ni2ldc(mod(ieg,neps)) * w(ieg/neps)
10  end do
!
!    FINT = SOMME(G) W(G).ABS(BT).SIGREF
    do 20 i = 1, nddl
        fref(i)=0
        do 30 ieg = 0, nepg-1
            fref(i) = fref(i) + abs(b(ieg,i))*sigpds(ieg)
30      continue
20  end do
!
end subroutine
