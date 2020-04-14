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
subroutine te0550(option, nomte)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/teattr.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/rcvalb.h"
#include "asterfort/vff2dn.h"
#include "asterfort/utmess.h"
#include "asterfort/getFluidPara.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 2D_FLUI_ABSO
!
! Options: IMPE_ABSO
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: nx, ny
    real(kind=8) :: celer, poids
    real(kind=8) :: a(6, 6), vites(6)
    integer :: ipoids, ivf, idfde
    integer :: jv_geom, jv_mate, jv_vitplu, jv_vitent, jv_vect
    integer :: ndim, nno, ndi, ipg, npg
    integer :: ldec
    integer :: i, ii, j, jj
    integer :: j_mater, iret
    character(len=16) :: fsi_form
    aster_logical :: l_axis
    real(kind=8) :: r
!
! --------------------------------------------------------------------------------------------------
!
    a = 0.d0
!
! - Get parameters of element
!
    call teattr('S', 'FORMULATION', fsi_form, iret)
    l_axis = (lteatt('AXIS','OUI'))
    call elrefe_info(fami='RIGI',&
                     ndim=ndim, nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
    ndi   = 2*nno
!
! - Input fields
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PMATERC', 'L', jv_mate)
    call jevech('PVITPLU', 'L', jv_vitplu)
    call jevech('PVITENT', 'L', jv_vitent)
!
! - Get material properties for fluid
!
    j_mater = zi(jv_mate)
    call getFluidPara(j_mater, cele_r_ = celer)
!
! - Output field
!
    call jevech('PVECTUR', 'E', jv_vect)
    do i = 1, ndi
        zr(jv_vect+i-1) = 0.d0
    end do
!
! - Compute
!
    if (celer .ge. 1.d-1) then
! ----- Loop on Gauss points
        do ipg = 1, npg
            ldec = (ipg-1)*nno
! --------- Compute normal and geometric quantities
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
! --------- Compute matrix
            if (fsi_form .eq. 'FSI_UPPHI') then
                do i = 1, nno
                    do j = 1, nno
                        ii = 2*i
                        jj = 2*j-1
                        a(ii,jj) = a(ii,jj) -&
                                   poids / celer *&
                                   zr(ivf+ldec+i-1)*zr(ivf+ldec+j-1)
                    end do
                end do
! ------------- Compute speed
                do i = 1, ndi
                    vites(i) = zr(jv_vitplu+i-1) + zr(jv_vitent+i-1)
                end do
! ------------- Save vector
                do i = 1, ndi
                    do j = 1, ndi
                        zr(jv_vect+i-1) = zr(jv_vect+i-1) - a(i,j)*vites(j)
                    end do
                end do
            else
                call utmess('F', 'FLUID1_2', sk = fsi_form)
            endif
        end do
    endif
!
end subroutine
