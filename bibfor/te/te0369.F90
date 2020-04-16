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
subroutine te0369(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/getFluidPara.h"
#include "asterfort/teattr.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D_FLUIDE (boundary)
!
! Options: ONDE_FLUI
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jv_geom, jv_mate, jv_onde, jv_vect
    real(kind=8) :: nx, ny, nz, sx(9, 9), sy(9, 9), sz(9, 9)
    real(kind=8) :: jac, celer
    integer :: ipoids, ivf, idfdx, idfdy
    integer :: nno, npg, ndim, ndofbynode
    integer :: idec, jdec, kdec, ldec
    integer :: i, ii, ino, j, jno, ipg
    integer :: j_mater, iret
    character(len=16) :: fsi_form
!
! --------------------------------------------------------------------------------------------------
!

!
! - Input fields
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PMATERC', 'L', jv_mate)
    call jevech('PONDECR', 'L', jv_onde)
!
! - Get element parameters
!
    call teattr('S', 'FORMULATION', fsi_form, iret)
    call elrefe_info(fami='RIGI',&
                     nno=nno, npg=npg, ndim=ndim,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfdx)
    ASSERT(nno .le. 9)
    idfdy = idfdx + 1
    if (fsi_form .eq. 'FSI_UPPHI') then
        ndofbynode = 2
    else
        call utmess('F', 'FLUID1_2', sk = fsi_form)
    endif
!
! - Get material properties for fluid
!
    j_mater = zi(jv_mate)
    call getFluidPara(j_mater, cele_r_ = celer)
!
! - Output field
!
    call jevech('PVECTUR', 'E', jv_vect)
    do i = 1, ndofbynode*nno
        zr(jv_vect+i-1) = 0.d0
    end do
!
! - CALCUL DES PRODUITS VECTORIELS OMI X OMJ
!
    do ino = 1, nno
        i = jv_geom + 3*(ino-1) -1
        do jno = 1, nno
            j = jv_geom + 3*(jno-1) -1
            sx(ino,jno) = zr(i+2) * zr(j+3) - zr(i+3) * zr(j+2)
            sy(ino,jno) = zr(i+3) * zr(j+1) - zr(i+1) * zr(j+3)
            sz(ino,jno) = zr(i+1) * zr(j+2) - zr(i+2) * zr(j+1)
        end do
    end do
!
! - Loop on Gauss points
!
    do ipg = 1, npg
        kdec = (ipg-1)*nno*ndim
        ldec = (ipg-1)*nno
! ----- Compute normal
        nx = 0.d0
        ny = 0.d0
        nz = 0.d0
        do i = 1, nno
            idec = (i-1)*ndim
            do j = 1, nno
                jdec = (j-1)*ndim
                nx = nx + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sx(i,j)
                ny = ny + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sy(i,j)
                nz = nz + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sz(i,j)
            end do
        end do
! ----- Compute jacobian
        jac = sqrt (nx*nx + ny*ny + nz*nz)
        if (fsi_form .eq. 'FSI_UPPHI') then
            do i = 1, nno
                ii = ndofbynode*i
                zr(jv_vect+ii-1) = zr(jv_vect+ii-1) +&
                                   jac*zr(ipoids+ipg-1) *&
                                   zr(ivf+ldec+i-1) * zr(jv_onde+ipg-1) / celer
            end do
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    end do
!
end subroutine
