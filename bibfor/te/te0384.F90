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
subroutine te0384(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/getFluidPara.h"
#include "asterfort/vff2dn.h"
#include "asterfort/utmess.h"
#include "asterfort/tecach.h"
#include "asterfort/evalNormalSpeed.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 2D_FLUI_STRU, AXIS_FLUI_STRU (boundary)
!
! Options: CHAR_MECA_VNOR
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_func, l_time
    integer :: jv_geom, jv_mate, jv_speed, jv_time, jv_vect
    real(kind=8) :: nx, ny
    real(kind=8) :: rho, poids
    real(kind=8) :: time, vnor
    integer :: ipoids, ivf, idfde
    integer :: nno, npg, ndim
    integer :: ldec
    integer :: i, ii, ipg
    aster_logical :: l_axis
    real(kind=8) :: r
    integer :: j_mater, iret
    character(len=16) :: fsi_form
!
! --------------------------------------------------------------------------------------------------
!
    l_func = (option .eq. 'CHAR_MECA_VNOR_F')
!
! - Input fields
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PMATERC', 'L', jv_mate)
    if (l_func) then
        call jevech('PVITENF', 'L', jv_speed)
    else
        call jevech('PVITENR', 'L', jv_speed)
    endif
!
! - Get time if present
!
    call tecach('NNO', 'PTEMPSR', 'L', iret, iad=jv_time)
    l_time = ASTER_FALSE
    time   = 0.d0
    if (jv_time .ne. 0) then
        l_time = ASTER_TRUE
        time   = zr(jv_time)
    endif
!
! - Get element parameters
!
    l_axis = (lteatt('AXIS','OUI'))
    fsi_form = 'U_P_PHI'
    call elrefe_info(fami='RIGI',&
                     nno=nno, npg=npg, ndim = ndim,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
!
! - Get material properties for fluid
!
    j_mater = zi(jv_mate)
    call getFluidPara(j_mater, rho)
!
! - Output field
!
    call jevech('PVECTUR', 'E', jv_vect)
    do i = 1, 3*nno
        zr(jv_vect+i-1) = 0.d0
    end do
!
! - Loop on Gauss points
!
    do ipg = 1, npg
        ldec = (ipg-1)*nno
! ----- Compute normal
        nx = 0.d0
        ny = 0.d0
        call vff2dn(ndim, nno, ipg, ipoids, idfde,&
                    zr(jv_geom), nx, ny, poids)
        if (l_axis) then
            r = 0.d0
            do i = 1, nno
                r = r + zr(jv_geom+2*(i-1))*zr(ivf+ldec+i-1)
            end do
            poids = poids*r
        endif
! ----- Get value of normal speed
        call evalNormalSpeed(l_func, l_time , time    ,&
                             nno   , ndim   , ipg     ,&
                             ivf   , jv_geom, jv_speed,&
                             vnor)
        if (fsi_form .eq. 'U_P_PHI') then
            do i = 1, nno
                ii = 3*i
                zr(jv_vect+ii-1) = zr(jv_vect+ii-1) -&
                                   poids *&
                                   zr(ivf+ldec+i-1) * vnor * rho
            end do
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    end do
!
end subroutine
