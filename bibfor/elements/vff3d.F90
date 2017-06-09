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

subroutine vff3d(nno, poids, dfde, coor, jac)
    implicit none
    integer :: nno
    real(kind=8) :: poids, dfde(nno), coor(3*nno), jac
! ......................................................................
!    - FONCTION REALISEE:  VALEUR DU POIDS D'INTEGRATION POUR UN SEGMENT
!                          A 2 OU 3 NOEUDS
!    - ARGUMENTS:
!        DONNEES:          NNO      -->  NOMBRE DE NOEUDS
!                          KP       -->  NUMERO DU POINTS DE GAUSS
!                          COOR     -->  COORDONNEES DES NOEUDS
!
!      RESULTATS:          JAC      <--  JACOBIEN ASSOCIE
! ......................................................................
!
    real(kind=8) :: dxds, dyds, dzds
    integer :: i
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    dxds = 0.d0
    dyds = 0.d0
    dzds = 0.d0
    do 1 i = 1, nno
        dxds = dxds + dfde(i) * coor(3*i-2)
        dyds = dyds + dfde(i) * coor(3*i-1)
        dzds = dzds + dfde(i) * coor(3*i)
 1  end do
    jac = poids * sqrt(dxds**2 + dyds**2 + dzds**2)
end subroutine
