! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine te0092(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: D_PLAN, C_PLAN, AXIS
!           D_PLAN_SI, C_PLAN_SI, AXIS_SI
!
! Options: RIGI_GEOM
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_axis
    real(kind=8) :: dfdx(9), dfdy(9), poids, r
    real(kind=8) :: sxx, sxy, syy
    integer :: nno, kp, k, npg, ii, jj, i, j, imatuu, kd1, kd2, ij1, ij2
    integer :: ipoids, ivf, idfde, igeom, icontr, kc
!
! --------------------------------------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
    l_axis = (lteatt('AXIS','OUI'))
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCONTRR', 'L', icontr)
    call jevech('PMATUUR', 'E', imatuu)
!
! - Loop on gauss points
!
    do kp = 1, npg
        k=(kp-1)*nno
        kc=icontr+4*(kp-1)
        sxx=zr(kc )
        syy=zr(kc+1)
        sxy=zr(kc+3)
        call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids, dfdx, dfdy)
        if (l_axis) then
            r = 0.d0
            do i = 1, nno
                r = r + zr(igeom+2*(i-1))*zr(ivf+k+i-1)
            end do
            do i = 1, nno
                dfdx(i)=dfdx(i)+zr(ivf+k+i-1)/r
            end do
            poids=poids*r
        endif
!
        kd1=2
        kd2=1
        do i = 1, 2*nno, 2
            kd1=kd1+2*i-3
            kd2=kd2+2*i-1
            ii = (i+1)/2
            do j = 1, i, 2
                jj = (j+1)/2
                ij1=imatuu+kd1+j-2
                ij2=imatuu+kd2+j-1
                zr(ij2) = zr(ij2) +poids*( dfdx(ii)*(dfdx(jj)*sxx+ dfdy(jj)*sxy)+ dfdy(ii)*(dfdx(&
                          &jj)*sxy+dfdy(jj)*syy))
                zr(ij1) = zr(ij2)
            end do
        end do
    end do
end subroutine
