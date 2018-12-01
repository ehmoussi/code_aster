! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmmtcc(nnl, wpg, ffl, jacobi, coefac, matrcc)
!
implicit none
!
integer, intent(in) :: nnl
real(kind=8), intent(in) :: wpg, ffl(9), jacobi
real(kind=8), intent(in) :: coefac
real(kind=8), intent(out) :: matrcc(9, 9)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF [contact x contact]
!
! --------------------------------------------------------------------------------------------------
!
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  wpg              : weight for current Gauss point
! In  ffl              : shape function for Lagrange dof
! In  jacobi           : jacobian at integration point
! In  coefac           : coefficient for updated Lagrangian method (contact)
! Out matrcc           : matrix for DOF [contact x contact]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: inoc1, inoc2
!
! --------------------------------------------------------------------------------------------------
!
    do inoc1 = 1, nnl
        do inoc2 = 1, nnl
            matrcc(inoc1,inoc2) = matrcc(inoc1,inoc2)-&
                                  wpg*jacobi/coefac*ffl(inoc2)*ffl(inoc1)
        end do
    end do
!
end subroutine
