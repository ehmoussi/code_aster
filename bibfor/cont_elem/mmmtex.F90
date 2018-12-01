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
subroutine mmmtex(ndexfr, ndim  , nnl   , nne   , nnm   , nbcps,&
                  matrff, matrfe, matrfm, matref, matrmf)
!
implicit none
!
#include "asterfort/isdeco.h"
#include "asterfort/mmmte2.h"
!
integer, intent(in) :: ndexfr, ndim, nne, nnl, nnm, nbcps
real(kind=8), intent(inout) :: matrff(18, 18), matref(27, 18), matrfe(18, 27)
real(kind=8), intent(inout) :: matrmf(27, 18), matrfm(18, 27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Modify matrices for excluded nodes
!
! --------------------------------------------------------------------------------------------------
!
! In  ndexfr           : integer for EXCL_FROT_* keyword
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  nbcps            : number of components by node for Lagrange multiplicators
! IO  matrff           : matrix for DOF [friction x friction]
! IO  matrfe           : matrix for DOF [friction x slave]
! IO  matrfm           : matrix for DOF [friction x master]
! IO  matref           : matrix for DOF [slave x friction]
! IO  matrmf           : matrix for DOF [master x friction]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ndexcl(10), nbcpf
!
! --------------------------------------------------------------------------------------------------
!
    nbcpf = nbcps - 1
!
    if (ndexfr .ne. 0) then
        call isdeco([ndexfr], ndexcl, 10)
        call mmmte2(ndim, nnl, nne, nnm, nbcpf,&
                    ndexcl, matrff, matrfe, matrfm, matref,&
                    matrmf)
    endif
!
end subroutine
