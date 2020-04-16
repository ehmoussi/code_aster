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
! aslint: disable=W0413
! => zr(jv_impe) is a real zero from AFFE_CHAR_MECA
!
subroutine te0258(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/teattr.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
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
! Elements: 2D_FLUIDE, AXIS_FLUIDE (boundary)
!           2D_FLUI_ABSO
!
! Options: IMPE_MECA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: nx, ny
    real(kind=8) :: poids
    real(kind=8) :: rho, rho2
    integer :: ipoids, ivf, idfde
    integer :: jv_geom, jv_mate, jv_matr, jv_impe
    integer :: ndim, nno, ndi, ipg, npg
    integer :: ldec
    integer :: i, ii, ij, j, jj
    integer :: j_mater, iret
    character(len=16) :: fsi_form
    aster_logical :: l_axis
    real(kind=8) :: r
!
! --------------------------------------------------------------------------------------------------
!
    call teattr('S', 'FORMULATION', fsi_form, iret)
    l_axis = (lteatt('AXIS','OUI'))
!
! - Get parameters of element
!
    call elrefe_info(fami='RIGI',&
                     ndim=ndim, nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
    ASSERT(nno .le. 3)
    if (fsi_form .eq. 'FSI_UPPHI') then
        ndi = nno*(2*nno+1)
    else
        call utmess('F', 'FLUID1_2', sk = fsi_form)
    endif
!
! - Input fields
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PMATERC', 'L', jv_mate)
    call jevech('PIMPEDR', 'L', jv_impe)
!
! - Get material properties for fluid
!
    j_mater = zi(jv_mate)
    call getFluidPara(j_mater, rho)
    rho2 = -rho*rho
!
! - Output field
!
    call jevech('PMATUUR', 'E', jv_matr)
    do i = 1, ndi
        zr(jv_matr+i-1) = 0.d0
    end do
!
! - Compute
!
    if (zr(jv_impe) .ne. 0.d0) then
        do ipg = 1, npg
            ldec = (ipg-1)*nno
! --------- Compute normal
            nx = 0.0d0
            ny = 0.0d0
            call vff2dn(ndim, nno, ipg, ipoids, idfde,&
                        zr(jv_geom), nx, ny, poids)
! --------- Radius for axisymmetric model
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
                    do j = 1, i
                        ii = 2*i
                        jj = 2*j
                        ij = (ii-1)*ii/2 + jj
                        zr(jv_matr+ij-1) = zr(jv_matr+ij-1) +&
                                           poids *&
                                           rho2 / zr(jv_impe+ipg-1) *&
                                           zr(ivf+ldec+i-1) * zr(ivf+ldec+j-1)
                    end do
                end do
            else
                call utmess('F', 'FLUID1_2', sk = fsi_form)
            endif
        end do
    endif
end subroutine
