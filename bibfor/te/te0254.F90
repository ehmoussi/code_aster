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
! => celer is a real zero from DEFI_MATERIAU
!
subroutine te0254(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/teattr.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/getFluidPara.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: AXIS_FLUIDE, 2D_FLUIDE
!
! Option: MASS_MECA
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: a(2, 2, 9, 9)
    real(kind=8) :: dfdx(9), dfdy(9)
    real(kind=8) :: poids, rho, celer
    integer :: jv_geom, jv_mate, jv_matr
    integer :: ipoids, ivf, idfde
    integer :: nno, npg
    integer :: ik, ijkl
    integer :: ipg, ino1, ino2, k, l
    integer :: ldec
    integer :: j_mater, iret
    character(len=16) :: fsi_form
    aster_logical :: l_axis
    real(kind=8) :: r
!
! --------------------------------------------------------------------------------------------------
!
    a    = 0.d0
!
! - Input fields
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PMATERC', 'L', jv_mate)
!
! - Get element parameters
!
    call teattr('S', 'FORMULATION', fsi_form, iret)
    l_axis = (lteatt('AXIS','OUI'))
    call elrefe_info(fami='RIGI',&
                     nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
    ASSERT(nno .le. 9)
!
! - Get material properties for fluid
!
    j_mater = zi(jv_mate)
    call getFluidPara(j_mater, rho, celer)
!
! - Loop on Gauss points
!
    do ipg = 1, npg
        ldec = (ipg-1)*nno
        call dfdm2d(nno, ipg, ipoids, idfde, zr(jv_geom),&
                    poids, dfdx, dfdy)
        if (l_axis) then
            r = 0.d0
            do ino1 = 1, nno
                r = r + zr(jv_geom+2*(ino1-1))*zr(ivf+ldec+ino1-1)
            end do
            poids = poids*r
        endif
        if (fsi_form .eq. 'FSI_UPPHI') then
            do ino1 = 1, nno
                do ino2 = 1, ino1
! ----------------- Compute -RHO*(GRAD(PHI)**2)
                    a(2,2,ino1,ino2) = a(2,2,ino1,ino2) -&
                                       poids*rho*&
                                      (dfdx(ino1)*dfdx(ino2)+&
                                       dfdy(ino1)*dfdy(ino2))
! ----------------- Compute (P*PHI)/(CEL**2)
                    if (celer .eq. 0.d0) then
                        a(1,2,ino1,ino2) = 0.d0
                    else
                        a(1,2,ino1,ino2) = a(1,2,ino1,ino2) +&
                                           poids*zr(ivf+ldec+ino1-1)*zr(ivf+ldec+ino2-1)/celer/celer
                    endif
                end do
            end do
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    end do
!
! - Output field
!
    call jevech('PMATUUR', 'E', jv_matr)
    if (fsi_form .eq. 'FSI_UPPHI') then
        do ino1 = 1, nno
            do ino2 = 1, ino1
                a(2,1,ino1,ino2) = a(1,2,ino1,ino2)
            end do
        end do
        do k = 1, 2
            do l = 1, 2
                do ino1 = 1, nno
                    ik = ((2*ino1+k-3)*(2*ino1+k-2))/2
                    do ino2 = 1, ino1
                        ijkl = ik + 2*(ino2-1) + l
                        zr(jv_matr+ijkl-1) = a(k,l,ino1,ino2)
                    end do
                end do
            end do
        end do
    else
        call utmess('F', 'FLUID1_2', sk = fsi_form)
    endif
!
end subroutine
