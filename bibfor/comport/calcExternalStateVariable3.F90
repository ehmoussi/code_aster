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
!
subroutine calcExternalStateVariable3(nno     , npg    , ndim    ,&
                                      jv_poids, jv_func, jv_dfunc,&
                                      geom    , deplm  , ddepl   )
!
use calcul_module, only : ca_vext_gradvelo_
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/matinv.h"
#include "asterfort/nmgeom.h"
#include "asterfort/pmat.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
!
integer, intent(in) :: nno, npg, ndim
integer, intent(in) :: jv_poids, jv_func, jv_dfunc
real(kind=8), intent(in) :: geom(ndim, nno)
real(kind=8), intent(in) :: deplm(ndim, nno), ddepl(ndim, nno)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour - Compute intrinsic external state variables
!
! Case: gradient of velocity (GRADVELO)
!
! --------------------------------------------------------------------------------------------------
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  geom             : initial coordinates of nodes
! In  deplm            : displacements of nodes at beginning of time step
! In  ddepl            : displacements of nodes since beginning of time step
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nddl, kpg, i, j
    real(kind=8) :: l(3, 3), fmm(3, 3), df(3, 3), f(3, 3), r8bid, r
    real(kind=8) :: deplp(3, 27), geomm(3, 27), epsbid(6)
    real(kind=8) :: dfdi(nno, 3)
    real(kind=8) :: id(3, 3)
    data    id/1.d0,0.d0,0.d0, 0.d0,1.d0,0.d0, 0.d0,0.d0,1.d0/
!
! --------------------------------------------------------------------------------------------------
!
    nddl = ndim*nno
    ca_vext_gradvelo_(:) = 0.d0
!
    call dcopy(nddl, geom, 1, geomm, 1)
    call daxpy(nddl, 1.d0, deplm, 1, geomm, 1)
    call dcopy(nddl, deplm, 1, deplp, 1)
    call daxpy(nddl, 1.d0, ddepl, 1, deplp, 1)
    do kpg = 1, npg
        call nmgeom(ndim, nno, .false._1, .true._1, geom,&
                    kpg, jv_poids, jv_func, jv_dfunc, deplp,&
                    .true._1, r8bid, dfdi, f, epsbid,&
                    r)
        call nmgeom(ndim, nno, .false._1, .true._1, geomm,&
                    kpg, jv_poids, jv_func, jv_dfunc, ddepl,&
                    .true._1, r8bid, dfdi, df, epsbid,&
                    r)
        call daxpy(9, -1.d0, id, 1, df, 1)
        call matinv('S', 3, f, fmm, r8bid)
        call pmat(3, df, fmm, l)
        do i = 1, 3
            do j = 1, 3
                ca_vext_gradvelo_(3*(i-1)+j)=l(i,j)
            end do
        end do
    end do
!
end subroutine
