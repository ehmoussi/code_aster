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
subroutine te0573(option, nomte)
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
#include "asterfort/nmpr2d.h"
#include "asterfort/tecach.h"
#include "asterfort/lteatt.h"
#include "blas/dcopy.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 2D (skin elements)
!
! Options: RIGI_MECA_PRSU_*
!          CHAR_MECA_PRSU_*
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: mxnoeu=3, mxnpg=4, mxvect=2*3, mxmatr=2*3*2*3
    aster_logical :: l_func, l_time
    aster_logical :: l_axis
    integer :: jv_geom, jv_time, jv_pres
    integer :: jv_depm, jv_depp
    integer :: jv_vect, jv_matr
    real(kind=8) :: time
    integer :: ipoids, ivf, idfde
    integer :: nno, npg, ndim, ndofbynode, ndof
    integer :: iret, kpg, idof, i, j, k
    real(kind=8) :: vect(mxvect), matr(mxmatr), geom_reac(mxvect)
    real(kind=8) :: pres, pres_pg(mxnpg)
    real(kind=8) :: cisa, cisa_pg(mxnpg)
!
! --------------------------------------------------------------------------------------------------
!
    pres_pg = 0.d0
    cisa_pg = 0.d0
    l_func = (option .eq. 'CHAR_MECA_PRSU_F') .or. (option .eq. 'RIGI_MECA_PRSU_F')
!
! - Input fields: for pressure, no node affected -> 0
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PDEPLMR', 'L', jv_depm)
    call jevech('PDEPLPR', 'L', jv_depp)
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
! - Total number of dof
!
    ndof = ndofbynode*nno
!
! - Update geometry
!
    do idof = 1, ndof
        geom_reac(idof) = zr(jv_geom+idof-1) + zr(jv_depm+idof-1) + zr(jv_depp+idof-1)
    end do
!
! - Evaluation of pressure (and shear) at Gauss points (from nodes)
!
    do kpg = 1, npg
        call evalPressure(l_func, l_time , time     ,&
                          nno   , ndim   , kpg      ,&
                          ivf   , jv_geom, jv_pres  ,&
                          pres  , cisa   , geom_reac)
        pres_pg(kpg) = pres
        cisa_pg(kpg) = cisa
    end do
!
! - Output
!
    if (option(1:9) .eq. 'CHAR_MECA') then
        call jevech('PVECTUR', 'E', jv_vect)
        call nmpr2d(l_axis    , nno    , npg      ,&
                    zr(ipoids), zr(ivf), zr(idfde),&
                    geom_reac , pres_pg, cisa_pg  ,&
                    vect)
        call dcopy(ndof, vect, 1, zr(jv_vect), 1)
    else if (option(1:9) .eq. 'RIGI_MECA') then
        call jevech('PMATUNS', 'E', jv_matr)
        call nmpr2d(l_axis    , nno    , npg      ,&
                    zr(ipoids), zr(ivf), zr(idfde),&
                    geom_reac , pres_pg, cisa_pg  ,&
                    matr_ = matr)
        k = 0
        do i = 1, ndof
            do j = 1, ndof
                k = k + 1
                zr(jv_matr-1+k) = matr((j-1)*ndof+i)
            end do
        end do
        ASSERT(k .eq. ndof*ndof)
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
