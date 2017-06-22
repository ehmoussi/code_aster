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

subroutine calapr(nbddl, mu, afmu, ddl, atmu)
!
    implicit none
!
    integer :: nbddl, ddl(nbddl)
    real(kind=8) :: mu, afmu(*), atmu(*)
!
! ----------------------------------------------------------------------
! ROUTINE APPELEE PAR : FROPGD/FROLGD/FROGDP
! ----------------------------------------------------------------------
! CALCUL DE ATMU = AFMU * MU
!
! IN  NBDDL  : NOMBRE DE DDLS IMPLIQUES DANS LA LIAISON UNILATERALE
! IN  MU     : COEFFICIENT DE MULTIPLICATION PAR PENALISATION
! IN  AFMU   : COEFFICIENTS IMPLIQUES DANS LA LIAISON UNILATERALE
! IN  DDL    : NUMEROS DES DDLS IMPLIQUES DANS LA LIAISON UNILATERALE
! IN  ATMU   : VECTEUR AT.MU
!
! ----------------------------------------------------------------------
!
    integer :: j
!
! ----------------------------------------------------------------------
!
    do 10 j = 1, nbddl
        atmu(j) = afmu(ddl(j)) * mu
10  end do
!
! ======================================================================
!
end subroutine
