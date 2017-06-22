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

subroutine te0084(option, nomte)
!
    implicit none
!
#include "jeveux.h"
#include "asterc/r8miem.h"
#include "asterfort/assert.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(in) :: option
    character(len=16), intent(in) :: nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: AXIS, D_PLAN, C_PLAN
! Option: CHAR_MECA_ROTA_R
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: phenom
    integer :: icodre(1)
    real(kind=8) :: poids, rx, ry
    integer :: nno, kp, k, npg1, i, jgano, ndim, nnos
    integer :: ipoids, ivf, idfde
    real(kind=8) :: rho(1)
    integer :: j_geom, j_rota, j_vect, j_mate
    real(kind=8) :: rota_speed, rota_axis(3), rota_cent(3)
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(option.eq.'CHAR_MECA_ROTA_R')
!
! - Finite element parameters
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg1,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
! - IN fields
!
    call jevech('PGEOMER', 'L', j_geom)
    call jevech('PMATERC', 'L', j_mate)
    call jevech('PROTATR', 'L', j_rota)
    rota_speed = zr(j_rota-1+1)
    rota_axis(1) = zr(j_rota-1+2)
    rota_axis(2) = zr(j_rota-1+3)
    rota_axis(3) = zr(j_rota-1+4)
    rota_cent(1) = zr(j_rota-1+5)
    rota_cent(2) = zr(j_rota-1+6)
    rota_cent(3) = zr(j_rota-1+7)
!
! - OUT fields
!
    call jevech('PVECTUR', 'E', j_vect)
!
! - Checking
!
    if (lteatt('C_PLAN','OUI').or.lteatt('C_PLAN','OUI')) then
! AXE=direction Oz
        if (abs(rota_axis(3)) .le. r8miem()) then
            call utmess('F', 'CHARGES2_67')
        endif
        if (abs(rota_axis(1)) .gt. r8miem() .or. abs(rota_axis(2)) .gt. r8miem()) then
            call utmess('F', 'CHARGES2_67')
        endif
    else if (lteatt('AXIS','OUI')) then
! AXE=Oy et CENTRE=ORIGINE
        if (abs(rota_axis(1)) .gt. r8miem() .or. abs(rota_axis(3)) .gt. r8miem()) then
            call utmess('F', 'CHARGES2_65')
        endif
        if (abs(rota_axis(2)) .le. r8miem()) then
            call utmess('F', 'CHARGES2_65')
        endif
        if (abs(rota_cent(1)) .gt. r8miem() .or. abs(rota_cent(2)) .gt. r8miem() .or.&
            abs(rota_cent(3)) .gt. r8miem()) then
            call utmess('F', 'CHARGES2_66')
        endif
    endif
!
! - Material
!
    call rccoma(zi(j_mate), 'ELAS', 1, phenom, icodre(1))
    call rcvalb('FPG1', 1, 1, '+', zi(j_mate),&
                ' ', phenom, 0, ' ', [0.d0],&
                1, 'RHO', rho, icodre(1), 1)
!
! - Computation
!
    do kp = 1, npg1
        k=(kp-1)*nno
        call dfdm2d(nno, kp, ipoids, idfde, zr(j_geom),&
                    poids)
        poids = poids * rho(1) * rota_speed**2
        rx= 0.d0
        ry= 0.d0
        do i = 1, nno
            rx= rx+ zr(j_geom+2*i-2)*zr(ivf+k+i-1)
            ry= ry+ zr(j_geom+2*i-1)*zr(ivf+k+i-1)
        end do
        if (lteatt('AXIS','OUI')) then
            poids = poids*rx
            do i = 1, nno
                k=(kp-1)*nno
                zr(j_vect+2*i-2) = zr(j_vect+2*i-2) + poids*rota_axis(2)**2*rx*zr(ivf+k+i-1)
            end do
        else
            rx = rx - rota_cent(1)
            ry = ry - rota_cent(2)
            do i = 1, nno
                k=(kp-1)*nno
                zr(j_vect+2*i-2) = zr(j_vect+2*i-2) + poids*rota_axis(3)**2*rx*zr(ivf+k+i-1)
                zr(j_vect+2*i-1) = zr(j_vect+2*i-1) + poids*rota_axis(3)**2*ry*zr(ivf+k+i-1)
            end do
        endif
    end do
end subroutine
