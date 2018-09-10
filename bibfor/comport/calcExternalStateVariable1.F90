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
subroutine calcExternalStateVariable1(nno     , npg    , ndim    ,&
                                      jv_poids, jv_func, jv_dfunc,&
                                      geom    , typmod)
!
use calcul_module, only : ca_vext_eltsize1_
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: nno, npg, ndim
integer, intent(in) :: jv_poids, jv_func, jv_dfunc
character(len=8), intent(in) :: typmod(2)
real(kind=8), intent(in) :: geom(ndim, nno)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour - Compute intrinsic external state variables
!
! Case: size of element (ELTSIZE1)
!
! --------------------------------------------------------------------------------------------------
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  typmod           : type of modelization (TYPMOD2)
! In  geom             : initial coordinates of nodes
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: laxi
    integer :: kpg, k, i
    real(kind=8) :: rac2, lc, dfdx(27), dfdy(27), dfdz(27), poids, r
    real(kind=8) :: volume, surfac
!
! --------------------------------------------------------------------------------------------------
!
    rac2 = sqrt(2.d0)
    laxi = typmod(1) .eq. 'AXIS'
!
    if (typmod(1)(1:2) .eq. '3D') then
        volume = 0.d0
        do kpg = 1, npg
            call dfdm3d(nno, kpg, jv_poids, jv_dfunc, geom,&
                        poids, dfdx, dfdy, dfdz)
            volume = volume + poids
        end do
        if (npg .ge. 9) then
            lc = volume ** 0.33333333333333d0
        else
            lc = rac2 * volume ** 0.33333333333333d0
        endif
    elseif (typmod(1)(1:6).eq.'D_PLAN' .or. typmod(1)(1:4).eq.'AXIS') then
        surfac = 0.d0
        do kpg = 1, npg
            k = (kpg-1)*nno
            call dfdm2d(nno, kpg, jv_poids, jv_dfunc, geom,&
                        poids, dfdx, dfdy)
            if (laxi) then
                r = 0.d0
                do i = 1, nno
                    r = r + geom(1,i)*zr(jv_func+i+k-1)
                end do
                poids = poids*r
            endif
            surfac = surfac + poids
        end do
!
        if (npg .ge. 5) then
            lc = surfac ** 0.5d0
        else
            lc = rac2 * surfac ** 0.5d0
        endif
!
    elseif (typmod(1)(1:6).eq.'C_PLAN') then
        lc = r8vide()
    else
        ASSERT(.false.)
    endif
!
    ca_vext_eltsize1_ = lc
!
end subroutine
