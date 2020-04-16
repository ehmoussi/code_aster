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
subroutine te0370(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/teattr.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/getFluidPara.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 2D_FLUI_PESA
!
! Options: RIGI_MECA/FORC_NODA/FULL_MECA/RAPH_MECA/RIGI_MECA_HYST/RIGI_MECA_TANG
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, k, l
    integer :: n1, n2
    integer :: nn, nno2, nt2
    integer :: ldec, kdec
    integer :: ipg, ik, ijkl
    integer :: jv_compo, jv_deplm, jv_deplp
    integer :: jv_geom, jv_mate
    integer :: jv_vect, jv_codret, jv_matr
    character(len=16) :: rela_comp
    real(kind=8) :: a(2, 2, 27, 27)
    real(kind=8) :: b(54, 54), ul(54), c(1485)
    real(kind=8) :: poids, rho, pesa
    integer :: ipoids, ivf, idfde
    real(kind=8) :: jac
    real(kind=8) :: dxde, dxdk, dyde, dydk
    integer :: nno, npg
    integer :: j_mater, iret
    character(len=16) :: fsi_form
!
! --------------------------------------------------------------------------------------------------
!
    a(:,:,:,:) = 0.d0
!
! - Check behaviour
!
    if (option(1:9) .eq. 'FULL_MECA' .or.&
        option .eq. 'RAPH_MECA' .or.&
        option .eq. 'RIGI_MECA_TANG') then
        call jevech('PCOMPOR', 'L', jv_compo)
        rela_comp = zk16(jv_compo)
        if (rela_comp .ne. 'ELAS') then
            call utmess('F', 'FLUID1_1')
        endif
    endif
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
                     nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
!
! - Get material properties for fluid
!
    j_mater = zi(jv_mate)
    call getFluidPara(j_mater, rho, pesa_ = pesa)
!
! - Loop on Gauss points
!
    do ipg = 1, npg
        kdec = (ipg-1)*nno*2
        ldec = (ipg-1)*nno
        dxde = 0.d0
        dxdk = 0.d0
        dyde = 0.d0
        dydk = 0.d0
        do i = 1, nno
            dxde = dxde+zr(jv_geom+3*(i-1))*zr(idfde+kdec+(i-1)*2)
            dxdk = dxdk+zr(jv_geom+3*(i-1))*zr(idfde+kdec+(i-1)*2+1)
            dyde = dyde+zr(jv_geom+3*(i-1)+1)*zr(idfde+kdec+(i-1)*2)
            dydk = dydk+zr(jv_geom+3*(i-1)+1)*zr(idfde+kdec+(i-1)*2+1)
        end do
        jac   = dxde*dydk - dxdk*dyde
        poids = abs(jac)*zr(ipoids+ipg-1)
        if (fsi_form .eq. 'FSI_UPPHI') then
            do i = 1, nno
                do j = 1, i
                    a(2,2,i,j) = a(2,2,i,j) +&
                                 poids*rho*pesa*zr(ivf+ldec+i-1)*zr(ivf+ldec+j-1)
                end do
            end do
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    end do
!
! - Compute result
!
    do k = 1, 2
        do l = 1, 2
            do i = 1, nno
                ik = ((2*i+k-3)*(2*i+k-2))/2
                do j = 1, i
                    ijkl = ik + 2*(j-1) + l
                    c(ijkl) = a(k,l,i,j)
                end do
            end do
        end do
    end do
    nno2 = nno*2
    nt2  = nno*(nno2+1)
!
! - Save matrix
!
    if (option(1:9) .eq. 'FULL_MECA' .or. option(1:9) .eq. 'RIGI_MECA') then
        if (option .eq. 'RIGI_MECA_HYST') then
            call jevech('PMATUUC', 'E', jv_matr)
            do i = 1, nt2
                zc(jv_matr+i-1) = dcmplx(c(i),0.d0)
            end do
        else
            call jevech('PMATUUR', 'E', jv_matr)
            do i = 1, nt2
                zr(jv_matr+i-1) = c(i)
            end do
        endif
    endif
!
! - Save vector
!
    if (option(1:9) .eq. 'FULL_MECA' .or.&
        option .eq. 'RAPH_MECA' .or.&
        option .eq. 'FORC_NODA') then
        call jevech('PVECTUR', 'E', jv_vect)
        call jevech('PDEPLMR', 'L', jv_deplm)
        call jevech('PDEPLPR', 'L', jv_deplp)
        do i = 1, nno2
            zr(jv_vect+i-1) = 0.d0
            ul(i) = zr(jv_deplm+i-1) + zr(jv_deplp+i-1)
        end do
        nn = 0
        do n1 = 1, nno2
            do n2 = 1, n1
                nn = nn + 1
                b(n1,n2) = c(nn)
                b(n2,n1) = c(nn)
            end do
        end do
        do n1 = 1, nno2
            do n2 = 1, nno2
                zr(jv_vect+n1-1) = zr(jv_vect+n1-1) + b(n1,n2)*ul(n2)
            end do
        end do
    endif
!
! - Save return code
!
    if (option(1:9) .eq. 'FULL_MECA' .or. option .eq. 'RAPH_MECA') then
        call jevech('PCODRET', 'E', jv_codret)
        zi(jv_codret) = 0
    endif
!
end subroutine
