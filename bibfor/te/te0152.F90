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
subroutine te0152(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/getFluidPara.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D_FLUIDE
!
! Options: MASS_INER
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jv_geom, jv_mate, jv_mass
    integer :: npg, nno
    integer :: i, j, l, ipg
    real(kind=8) :: xxi, yyi, zzi
    real(kind=8) :: poids, volume, rho
    real(kind=8) :: x(27), y(27), z(27), xg, yg, zg
    real(kind=8) :: matine(6)
    integer :: ipoids, ivf, idfde
    integer :: j_mater
!
! --------------------------------------------------------------------------------------------------
!
    matine = 0.d0
!
! - Input fields
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PMATERC', 'L', jv_mate)
!
! - Get element parameters
!
    call elrefe_info(fami='RIGI',&
                     nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
!
! - Get material properties for fluid
!
    j_mater = zi(jv_mate)
    call getFluidPara(j_mater, rho)
!
! - Output field
!
    call jevech('PMASSINE', 'E', jv_mass)
    do i = 0, 3
        zr(jv_mass+i) = 0.d0
    end do
!
! - Get geometry
!
    do i = 1, nno
        x(i) = zr(jv_geom+3* (i-1))
        y(i) = zr(jv_geom+3*i-2)
        z(i) = zr(jv_geom+3*i-1)
    end do
!
! - Loop on Gauss points
!
    volume = 0.d0
    do ipg = 1, npg
        l = (ipg-1)*nno
        call dfdm3d(nno, ipg, ipoids, idfde, zr(jv_geom),&
                    poids)
        volume = volume + poids
        do i = 1, nno
            zr(jv_mass+1) = zr(jv_mass+1) + poids*x(i)*zr(ivf+l+i-1)
            zr(jv_mass+2) = zr(jv_mass+2) + poids*y(i)*zr(ivf+l+i-1)
            zr(jv_mass+3) = zr(jv_mass+3) + poids*z(i)*zr(ivf+l+i-1)
            xxi = 0.d0
            yyi = 0.d0
            zzi = 0.d0
            do j = 1, nno
                xxi = xxi + x(i)*zr(ivf+l+i-1)*x(j)*zr(ivf+l+j-1)
                yyi = yyi + y(i)*zr(ivf+l+i-1)*y(j)*zr(ivf+l+j-1)
                zzi = zzi + z(i)*zr(ivf+l+i-1)*z(j)*zr(ivf+l+j-1)
                matine(2) = matine(2) + poids*x(i)*zr(ivf+l+i-1)*y(j)*zr(ivf+l+j-1)
                matine(4) = matine(4) + poids*x(i)*zr(ivf+l+i-1)*z(j)*zr(ivf+l+j-1)
                matine(5) = matine(5) + poids*y(i)*zr(ivf+l+i-1)*z(j)*zr(ivf+l+j-1)
            end do
            matine(1) = matine(1) + poids* (yyi+zzi)
            matine(3) = matine(3) + poids* (xxi+zzi)
            matine(6) = matine(6) + poids* (xxi+yyi)
        end do
    end do
!
    xg = zr(jv_mass+1)/volume
    yg = zr(jv_mass+2)/volume
    zg = zr(jv_mass+3)/volume
!
! - Save results
!
    zr(jv_mass) = volume*rho
    zr(jv_mass+1) = xg
    zr(jv_mass+2) = yg
    zr(jv_mass+3) = zg
    zr(jv_mass+4) = matine(1)*rho - zr(jv_mass)*(yg*yg+zg*zg)
    zr(jv_mass+5) = matine(3)*rho - zr(jv_mass)*(xg*xg+zg*zg)
    zr(jv_mass+6) = matine(6)*rho - zr(jv_mass)*(xg*xg+yg*yg)
    zr(jv_mass+7) = matine(2)*rho - zr(jv_mass)*(xg*yg)
    zr(jv_mass+8) = matine(4)*rho - zr(jv_mass)*(xg*zg)
    zr(jv_mass+9) = matine(5)*rho - zr(jv_mass)*(yg*zg)
!
end subroutine
