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
subroutine mmmtcu(ndim  , nnl   , nne   , nnm,&
                  ffl   , ffe   , ffm   ,&
                  norm  , wpg   , jacobi,&
                  matrce, matrcm)
!
implicit none
!
integer, intent(in) :: ndim, nne, nnl, nnm
real(kind=8), intent(in) :: ffe(9), ffl(9), ffm(9)
real(kind=8), intent(in) :: norm(3), wpg, jacobi
real(kind=8), intent(out) :: matrce(9, 27), matrcm(9, 27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF [contact x disp]
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  ffl              : shape function for Lagrange dof
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! In  norm             : normal at current contact point
! In  wpg              : weight for current Gauss point
! In  jacobi           : jacobian at integration point
! Out matrce           : matrix for DOF [contact x slave]
! Out matrcm           : matrix for DOF [contact x master]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: inoc, inom, idim, inoe, jj
!
! --------------------------------------------------------------------------------------------------
!
    do inoc = 1, nnl
        do inoe = 1, nne
            do idim = 1, ndim
                jj = ndim*(inoe-1)+idim
                matrce(inoc,jj) = matrce(inoc,jj) -&
                                  wpg*ffl(inoc)*ffe(inoe)*jacobi*norm(idim)
            end do
        end do
    end do
    do inoc = 1, nnl
        do inom = 1, nnm
            do idim = 1, ndim
                jj = ndim*(inom-1)+idim
                matrcm(inoc,jj) = matrcm(inoc,jj) +&
                                  wpg*ffl(inoc)*ffm(inom)*jacobi*norm(idim)
            end do
        end do
    end do
!
end subroutine
