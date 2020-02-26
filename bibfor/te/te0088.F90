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
subroutine te0088(option, nomte)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevecd.h"
#include "asterfort/jevech.h"
#include "asterfort/evalPressure.h"
#include "asterfort/nmpr2d_vect.h"
#include "asterfort/tecach.h"
#include "asterfort/lteatt.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 2D (skin elements)
!
! Options: CHAR_MECA_PRES_*
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: mxnoeu=9, mxnpg=27
    aster_logical :: l_func, l_time, l_axis
    integer :: jv_geom, jv_time, jv_pres
    integer :: jv_vect
    real(kind=8) :: time
    integer :: ipoids, ivf, idfde
    integer :: nno, npg, ndim, ndofbynode
    integer :: iret, kpg
    real(kind=8) :: pres, pres_pg(mxnpg)
    real(kind=8) :: cisa, cisa_pg(mxnpg)
!
! --------------------------------------------------------------------------------------------------
!
    pres_pg = 0.d0
    cisa_pg = 0.d0
    l_func = (option .eq. 'CHAR_MECA_PRES_F')
!
! - Input fields: for pressure, no node affected -> 0
!
    call jevech('PGEOMER', 'L', jv_geom)
    if (l_func) then
        call jevecd('PPRESSF', jv_pres, 0.d0)
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
! - Output fields
!
    call jevech('PVECTUR', 'E', jv_vect)
!
! - Get element parameters
!
    call elrefe_info(fami='RIGI',&
                     nno=nno, npg=npg, ndim=ndim,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
    l_axis = lteatt('AXIS','OUI')
    ASSERT(nno .le. mxnoeu)
    ASSERT(npg .le. mxnpg)
!
! - Pressure are on skin elements but DOF are volumic
!
    ASSERT(ndim .eq. 1)
    ndofbynode = ndim + 1
!
! - Evaluation of pressure (and shear) at Gauss points (from nodes)
!
    do kpg = 1, npg
        call evalPressure(l_func, l_time , time   ,&
                          nno   , ndim   , kpg    ,&
                          ivf   , jv_geom, jv_pres,&
                          pres  , cisa)
        pres_pg(kpg) = pres
        cisa_pg(kpg) = cisa
    end do
!
! - Second member
!
    call nmpr2d_vect(l_axis,&
                     nno        , npg    , ndofbynode,&
                     ipoids     , ivf    , idfde     ,&
                     zr(jv_geom), pres_pg, cisa_pg   ,&
                     zr(jv_vect))
!
end subroutine
