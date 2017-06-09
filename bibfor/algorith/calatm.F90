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

subroutine calatm(neq, nbddl, mu, coef, ddl,&
                  atmu)
!
    implicit none
!
    integer :: neq
    integer :: nbddl
    integer :: ddl(nbddl)
    real(kind=8) :: mu
    real(kind=8) :: coef(nbddl)
    real(kind=8) :: atmu(neq)
!
! ----------------------------------------------------------------------
! ROUTINE APPELEE PAR : ALGOCL/ALGOCO/ALGOCP/CFACA1/CFATMU
!                       FRO2GD/FROGDP/FROLGD/FROPGD
! ----------------------------------------------------------------------
!
! CALCUL DE LA CONTRIBUTION D'UNE LIAISON DE CONTACT AU VECTEUR AT.MU.
!
! IN  NEQ    : NOMBRE D'EQUATIONS
! IN  NBDDL  : NOMBRE DE DDLS IMPLIQUES DANS LA LIAISON UNILATERALE
! IN  MU     : MULTIPLICATEUR DE LAGRANGE ASSOCIE AU CONTACT POUR
!              LA LIAISON ETUDIEE
! IN  COEF   : COEFFICIENTS IMPLIQUES DANS LA LIAISON UNILATERALE
! IN  DDL    : NUMEROS DES DDLS IMPLIQUES DANS LA LIAISON UNILATERALE
! I/O ATMU   : VECTEUR AT.MU
!
! ----------------------------------------------------------------------
!
    integer :: j
!
! ----------------------------------------------------------------------
!
    do 10 j = 1, nbddl
        atmu(ddl(j)) = atmu(ddl(j)) + coef(j) * mu
10  end do
!
! ======================================================================
!
end subroutine
