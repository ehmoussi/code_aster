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

subroutine caladu(neq, nbddl, coef, ddl, depl,&
                  val)
!
    implicit none
!
    integer :: neq
    integer :: nbddl
    integer :: ddl(nbddl)
    real(kind=8) :: coef(nbddl)
    real(kind=8) :: depl(neq)
    real(kind=8) :: val
!
! ----------------------------------------------------------------------
! ROUTINE APPELEE PAR : ALGOCL/ALGOCO/ALGOCP/CFACA2/CFADU/FRO2GD
!                       FROGDP/FROLGD/FROPGD/REAJEU/RESUCO
! ----------------------------------------------------------------------
!
! CALCUL DU TERME II DE (A.DEPL) OU A EST LA MATRICE DE CONTACT ET
! DEPL UN VECTEUR QUELCONQUE.
!
! IN  NEQ    : NOMBRE D'EQUATIONS
! IN  NBDDL  : NOMBRE DE DDLS IMPLIQUES DANS LA LIAISON UNILATERALE
! IN  COEF   : COEFFICIENTS IMPLIQUES DANS LA LIAISON UNILATERALE
! IN  DDL    : NUMEROS DES DDLS IMPLIQUES DANS LA LIAISON UNILATERALE
! IN  DEPL   : VECTEUR A MULTIPLIER PAR LA MATRICE A
! OUT VAL    : VALEUR DU TERME OBTENU
!
! ----------------------------------------------------------------------
!
    integer :: j
!
! ----------------------------------------------------------------------
!
    val = 0.d0
    do 10 j = 1, nbddl
        val = val + coef(j) * depl(ddl(j))
10  end do
!
! ======================================================================
!
end subroutine
