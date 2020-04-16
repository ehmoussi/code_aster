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
! => celer/rho are real zero from DEFI_MATERIAU
!
subroutine te0253(option, nomte)
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
#include "asterfort/getFluidPara.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: AXIS_FLUIDE, 2D_FLUIDE
!
! Options: RIGI_MECA/FORC_NODA/FULL_MECA/RAPH_MECA/RIGI_MECA_HYST/RIGI_MECA_TANG
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, k, l
    integer :: n1, n2
    integer :: nn, nno2, nt2
    integer :: ipg, ik, ijkl
    integer :: jv_compo, jv_deplm, jv_deplp
    integer :: jv_geom, jv_mate
    integer :: jv_vect, jv_codret, jv_matr
    character(len=16) :: rela_comp
    real(kind=8) :: a(2, 2, 9, 9)
    real(kind=8) :: b(18, 18), ul(18), c(171)
    real(kind=8) :: poids, rho, celer
    integer :: ipoids, ivf, idfde
    integer :: nno, npg
    integer :: j_mater, iret
    character(len=16) :: fsi_form
    aster_logical :: l_axis
    real(kind=8) :: r
!
! --------------------------------------------------------------------------------------------------
!
    a    = 0.d0
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
    l_axis = (lteatt('AXIS','OUI'))
    call elrefe_info(fami='RIGI',&
                     nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
    ASSERT(nno .le. 9)
    nno2 = nno*2
    nt2  = nno*(nno2+1)
!
! - Get material properties for fluid
!
    j_mater = zi(jv_mate)
    call getFluidPara(j_mater, rho, celer)
!
! - Loop on Gauss points
!
    do ipg = 1, npg
        k = (ipg-1)*nno
        call dfdm2d(nno  , ipg , ipoids, idfde, zr(jv_geom),&
                    poids)
        if (l_axis) then
            r = 0.d0
            do i = 1, nno
                r = r + zr(jv_geom+2*(i-1))*zr(ivf+k+i-1)
            end do
            poids = poids*r
        endif
        if (fsi_form .eq. 'FSI_UPPHI') then
            do i = 1, nno
                do j = 1, i
                    if (celer .eq. 0.d0 .or. rho .eq. 0.d0) then
                        a(1,1,i,j) = 0.d0
                    else
                        a(1,1,i,j) = a(1,1,i,j) +&
                                     poids*zr(ivf+k+i-1)*zr(ivf+k+j-1)/rho/celer/celer
                    endif
                end do
            end do
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    end do
!
! - Compute result
!
    if (fsi_form .eq. 'FSI_UPPHI') then
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
    endif
!
! - Save matrix
!
    if (option .eq. 'RIGI_MECA_HYST') then
        call jevech('PMATUUC', 'E', jv_matr)
        if (fsi_form .eq. 'FSI_UPPHI') then
            do i = 1, nt2
                zc(jv_matr+i-1) = dcmplx(c(i),0.d0)
            end do
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    elseif (option(1:9) .eq. 'FULL_MECA' ) then
        call jevech('PMATUUR', 'E', jv_matr)
        if (fsi_form .eq. 'FSI_UPPHI') then
            do i = 1, nt2
                zr(jv_matr+i-1) = c(i)
            end do
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    elseif (option(1:9) .eq. 'RIGI_MECA') then
        call jevech('PMATUUR', 'E', jv_matr)
        if (fsi_form .eq. 'FSI_UPPHI') then
            do i = 1, nt2
                zr(jv_matr+i-1) = c(i)
            end do
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    endif
!
! - Save vector
!
    if (option(1:9) .eq. 'FULL_MECA' .or.&
        option .eq. 'RAPH_MECA' .or.&
        option .eq. 'FORC_NODA') then
        if (fsi_form .eq. 'FSI_UPPHI') then
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
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    endif
!
! - Save return code
!
    if (option(1:9) .eq. 'FULL_MECA' .or. option .eq. 'RAPH_MECA') then
        if (fsi_form .eq. 'FSI_UPPHI') then
            call jevech('PCODRET', 'E', jv_codret)
            zi(jv_codret) = 0
        else
            call utmess('F', 'FLUID1_2', sk = fsi_form)
        endif
    endif
!
end subroutine
