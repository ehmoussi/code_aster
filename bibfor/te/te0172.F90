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
subroutine te0172(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/teattr.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/utmess.h"
#include "asterfort/getFluidPara.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: FLUI_STRU
!
! Option: MASS_MECA
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: a(4, 4, 27, 27)
    real(kind=8) :: sx(27, 27), sy(27, 27), sz(27, 27), norm(3)
    real(kind=8) :: rho
    integer :: jv_geom, jv_mate, jv_matr
    integer :: ipoids, ivf, idfdx, idfdy
    integer :: ndim, nno, npg
    integer :: ik, ijkl
    integer :: ino1, ino2, k, l, ipg, ino, jno, idim
    integer :: idec, jdec, ldec, kdec
    integer :: j_mater, iret
    character(len=16) :: fsi_form
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
    call elrefe_info(fami='RIGI',&
                     ndim=ndim, nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfdx)
    idfdy = idfdx + 1
    ASSERT(nno .le. 9)
!
! - CALCUL DES PRODUITS VECTORIELS OMI X OMJ POUR LE CALCUL
! - DE L'ELEMENT DE SURFACE AU POINT DE GAUSS
!
    do ino = 1, nno
        ino1 = jv_geom + 3*(ino-1) -1
        do jno = 1, nno
            ino2 = jv_geom + 3*(jno-1) -1
            sx(ino,jno) = zr(ino1+2)*zr(ino2+3) - zr(ino1+3)*zr(ino2+2)
            sy(ino,jno) = zr(ino1+3)*zr(ino2+1) - zr(ino1+1)*zr(ino2+3)
            sz(ino,jno) = zr(ino1+1)*zr(ino2+2) - zr(ino1+2)*zr(ino2+1)
        end do
    end do
!
! - Get material properties for fluid
!
    j_mater = zi(jv_mate)
    call getFluidPara(j_mater, rho)
!
! - Loop on Gauss points
!
    do ipg = 1, npg
        kdec = (ipg-1)*nno*ndim
        ldec = (ipg-1)*nno
! ----- Compute normals
        norm = 0.d0
        do ino1 = 1, nno
            idec = (ino1-1)*ndim
            do ino2 = 1, nno
                jdec =(ino2-1)*ndim
                norm(1) = norm(1) + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sx(ino1,ino2)
                norm(2) = norm(2) + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sy(ino1,ino2)
                norm(3) = norm(3) + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sz(ino1,ino2)
            end do
        end do
        if (fsi_form .eq. 'FSI_UPPHI') then
            do ino1 = 1, nno
                do ino2 = 1, ino1
                    do idim = 1, 3
                        a(idim,4,ino1,ino2) = a(idim,4,ino1,ino2) +&
                                              zr(ipoids+ipg-1) * norm(idim) * rho *&
                                              zr(ivf+ldec+ino1-1) * zr(ivf+ldec+ino2-1)
                    end do
                end do
            end do
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    end do
!
! - Output field
!
    if (fsi_form .eq. 'FSI_UPPHI') then
        call jevech('PMATUUR', 'E', jv_matr)
        do ino1 = 1, nno
            do ino2 = 1, ino1
                do idim = 1, 3
                    a(4,idim,ino1,ino2) = a(idim,4,ino1,ino2)
                end do
            end do
        end do
        do k = 1, 4
            do l = 1, 4
                do ino1 = 1, nno
                    ik = ((4*ino1+k-5)*(4*ino1+k-4))/2
                    do ino2 = 1, ino1
                        ijkl = ik + 4*(ino2-1) + l
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
