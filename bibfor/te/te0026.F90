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
!
subroutine te0026(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D
!           3D_SI (HEXA20)
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
    real(kind=8) :: a(3, 3, 27, 27)
    real(kind=8) :: dfdx(27), dfdy(27), dfdz(27), poids
    integer :: ipoids, idfde, igeom
    integer :: nno, kp, npg, i, j, imatuu
    integer :: ic, icontr, ijkl, ik, k, l
!
! --------------------------------------------------------------------------------------------------
!
    a = 0.d0
!
    call elrefe_info(fami='RIGI', nno=nno, npg=npg,&
                     jpoids=ipoids, jdfde=idfde)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCONTRR', 'L', icontr)
    call jevech('PMATUUR', 'E', imatuu)
!
! - Loop on gauss points
!
    do kp = 1, npg
        ic = icontr + (kp-1)*6
        call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids, dfdx, dfdy, dfdz)
        do i = 1, nno
            do j = 1, i
                a(1,1,i,j) = a(1,1,i,j) + poids*(&
                             zr(ic)*dfdx(i)*dfdx(j)+&
                             zr(ic+1)*dfdy(i)*dfdy(j)+&
                             zr(ic+2)*dfdz(i)*dfdz(j)+&
                             zr(ic+3)*(dfdx(i)*dfdy(j)+dfdy(i)*dfdx(j))+&
                             zr(ic+4)*(dfdz(i)*dfdx(j)+dfdx(i)*dfdz(j))+&
                             zr(ic+5)*(dfdy(i)*dfdz(j)+dfdz(i)*dfdy(j)))
            end do
        end do
    end do
!
    do i = 1, nno
        do j = 1, i
            a(2,2,i,j) = a(1,1,i,j)
            a(3,3,i,j) = a(1,1,i,j)
        end do
    end do
!
! - Save matrix (symmetric)
!
    do k = 1, 3
        do l = 1, 3
            do i = 1, nno
                ik = ((3*i+k-4)* (3*i+k-3))/2
                do j = 1, i
                    ijkl = ik + 3* (j-1) + l
                    zr(imatuu+ijkl-1) = a(k,l,i,j)
                end do
            end do
        end do
    end do
!
end subroutine
