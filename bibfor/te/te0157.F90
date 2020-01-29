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
subroutine te0157(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterc/r8depi.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/getFluidPara.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 2D_FLUIDE, AXIS_FLUIDE
!
! Options: MASS_INER
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jv_geom, jv_mate, jv_mass
    integer :: npg, nno
    integer :: i, j, k, ipg
    real(kind=8) :: xxi, yyi, xyi
    real(kind=8) :: poids, volume, rho
    real(kind=8) :: xg, yg, depi
    real(kind=8) :: r, x(9), y(9)
    real(kind=8) :: matine(6)
    integer :: ipoids, ivf, idfde
    integer :: j_mater
    aster_logical :: l_axis
!
! --------------------------------------------------------------------------------------------------
!
    depi   = r8depi()
    matine = 0.d0
!
! - Input fields
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PMATERC', 'L', jv_mate)
!
! - Get element parameters
!
    l_axis = (lteatt('AXIS','OUI'))
    call elrefe_info(fami='RIGI',&
                     nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
!
! - Get material properties for fluid
!
    j_mater = zi(jv_mate)
    call getFluidPara(j_mater, rho)
!
! - Get geometry
!
    do i = 1, nno
        x(i) = zr(jv_geom-2+2*i)
        y(i) = zr(jv_geom-1+2*i)
    end do
!
! - Output field
!
    call jevech('PMASSINE', 'E', jv_mass)
    do i = 0, 3
        zr(jv_mass+i) = 0.d0
    end do
!
! - Loop on Gauss points
!
    volume = 0.d0
    do ipg = 1, npg
        k = (ipg-1) * nno
        call dfdm2d(nno, ipg, ipoids, idfde, zr(jv_geom),&
                    poids)
        if (l_axis) then
            r = 0.d0
            do i = 1, nno
                r = r + zr(jv_geom-2+2*i)*zr(ivf+k+i-1)
            end do
            poids = poids*r
        endif
        volume = volume + poids
        do i = 1, nno
            zr(jv_mass+1) = zr(jv_mass+1)+poids*x(i)*zr(ivf+k+i-1)
            zr(jv_mass+2) = zr(jv_mass+2)+poids*y(i)*zr(ivf+k+i-1)
            xxi = 0.d0
            xyi = 0.d0
            yyi = 0.d0
            do j = 1, nno
                xxi = xxi + x(i)*zr(ivf+k+i-1)*x(j)*zr(ivf+k+j-1)
                xyi = xyi + x(i)*zr(ivf+k+i-1)*y(j)*zr(ivf+k+j-1)
                yyi = yyi + y(i)*zr(ivf+k+i-1)*y(j)*zr(ivf+k+j-1)
            end do
            matine(1) = matine(1) + poids*yyi
            matine(2) = matine(2) + poids*xyi
            matine(3) = matine(3) + poids*xxi
        end do
    end do
!
    if (l_axis) then
        yg = zr(jv_mass+2) / volume
        zr(jv_mass) = depi * volume * rho
        zr(jv_mass+3) = yg
        zr(jv_mass+1) = 0.d0
        zr(jv_mass+2) = 0.d0
        matine(6) = matine(3) * rho * depi
        matine(1) = matine(1) * rho * depi + matine(6)/2.d0 - zr(jv_mass)*yg*yg
        matine(2) = 0.d0
        matine(3) = matine(1)
    else
        zr(jv_mass) = volume * rho
        zr(jv_mass+1) = zr(jv_mass+1) / volume
        zr(jv_mass+2) = zr(jv_mass+2) / volume
        zr(jv_mass+3) = 0.d0
        xg = zr(jv_mass+1)
        yg = zr(jv_mass+2)
        matine(1) = matine(1)*rho - zr(jv_mass)*yg*yg
        matine(2) = matine(2)*rho - zr(jv_mass)*xg*yg
        matine(3) = matine(3)*rho - zr(jv_mass)*xg*xg
        matine(6) = matine(1) + matine(3)
    endif
!
! - Save results
!
    zr(jv_mass+4) = matine(1)
    zr(jv_mass+5) = matine(3)
    zr(jv_mass+6) = matine(6)
    zr(jv_mass+7) = matine(2)
    zr(jv_mass+8) = matine(4)
    zr(jv_mass+9) = matine(5)
!
end subroutine
