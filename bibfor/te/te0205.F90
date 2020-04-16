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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine te0205(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevecd.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
#include "asterfort/evalPressure.h"
#include "asterfort/nmpr3d_vect.h"
#include "asterfort/teattr.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: FLUI_STRU (3D)
!
! Options: CHAR_MECA_PRES_*
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: mxnpg=27
    aster_logical :: l_func, l_time
    integer :: jv_geom, jv_pres, jv_time, jv_vect
    real(kind=8) :: time
    real(kind=8) :: pres
    real(kind=8) :: pres_pg(mxnpg)
    integer :: ipoids, ivf, idfde
    integer :: nno, npg, ndim, ndofbynode
    integer :: ldec, iret
    integer :: i, ipg
    character(len=16) :: fsi_form
!
! --------------------------------------------------------------------------------------------------
!
    l_func = (option .eq. 'CHAR_MECA_PRES_F')
!
! - Input fields: for pressure, no node affected -> 0
!
    call jevech('PGEOMER', 'L', jv_geom)
    if (l_func) then
        call jevech('PPRESSF', 'L', jv_pres)
    else
        call jevecd('PPRESSR', jv_pres, 0.d0)
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
    call teattr('S', 'FORMULATION', fsi_form, iret)
    call elrefe_info(fami='RIGI',&
                     nno=nno, npg=npg, ndim = ndim,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
    ASSERT(mxnpg .le. 27)
!
! - Pressure are on skin elements but DOF are volumic + FSI
!
    ASSERT(ndim .eq. 2)
    if (fsi_form .eq. 'FSI_UPPHI') then
        ndofbynode = 4
    else
        call utmess('F', 'FLUID1_2', sk = fsi_form)
    endif
!
! - Output field
!
    call jevech('PVECTUR', 'E', jv_vect)
!
! - Loop on Gauss points
!
    do ipg = 1, npg
        ldec = (ipg-1)*nno
! ----- Get value of pressure
        call evalPressure(l_func, l_time , time   ,&
                          nno   , ndim   , ipg    ,&
                          ivf   , jv_geom, jv_pres,&
                          pres  )
! ----- Wrong direction of normal !
        pres = -pres
        do i = 1, nno
            pres_pg(ipg) = pres_pg(ipg) + pres * zr(ivf+ldec+i-1)
        end do
    end do
!
! - Second member
!
    call nmpr3d_vect(nno, npg, ndofbynode,&
                     zr(ipoids) , zr(ivf), zr(idfde)  , &
                     zr(jv_geom), pres_pg, zr(jv_vect))
!
end subroutine
