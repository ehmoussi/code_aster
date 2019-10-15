! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine te0475(option, nomte)
!
use THM_type

!
    implicit none
#include "jeveux.h"
#include "asterfort/dimthm.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/assert.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/thmGetElemRefe.h"
#include "asterfort/thmGetElemInfo.h"
!
character(len=16), intent(in) :: option, nomte
!    
! Elementary computation
!
! Elements: THM - 3D 
!
! Options: ECHA_THM_R ECHA_THM_F
!
    aster_logical :: l_axi, l_steady, l_vf
    integer :: nno, nnos,  ndim, nnom, napre1, napre2, ndim2

    integer :: jv_gano, jv_poids, jv_poids2, jv_func, jv_func2, jv_dfunc, jv_dfunc2
    integer :: i, j,l, ires,  itemps, iopt,  ndlnm, iech
    integer :: idfdy, iret, ndlno, igeom, natemp,iechf,ipg, npi
    integer :: idec, jdec, kdec, ldec, ldec2, ino, jno
    real(kind=8) :: nx, ny, nz,valpar(2), deltat
    real(kind=8) :: sx(9, 9), sy(9, 9), sz(9, 9), jac
    real(kind=8) :: flu1, flu2, fluth
    real(kind=8) :: c11,c12,c21,c22,p1ext,p2ext,p1m,p2m
    character(len=8) :: nompar(2), elrefe, elref2   
!
    integer :: idepm
!
!
    type(THM_DS) :: ds_thm
!
    ndim = 2
! Initialisation
    c11 = 0.D0
    c12 = 0.D0
    c21 = 0.D0
    c22 = 0.D0
    p1ext = 0.D0
    p2ext = 0.D0
    nompar(1) = 'PCAP'
    nompar(2) = 'INST'
!
! - Get model of finite element
!
    call thmGetElemModel(ds_thm,l_axi_ = l_axi, l_vf_ = l_vf, l_steady_ = l_steady)
!
! - Get reference elements
!
    call thmGetElemRefe(l_vf, elrefe, elref2)
!
! - Get informations about element
!
    call thmGetElemInfo(l_vf   , elrefe  , elref2   ,&
                        nno    , nnos    , nnom     ,&
                        jv_gano, jv_poids, jv_poids2,&
                        jv_func, jv_func2, jv_dfunc , jv_dfunc2,&
                        npi_ = npi)
!
! - Get number of dof on boundary
!
    ndim2 = 3
    call dimthm(ds_thm,l_vf, ndim2, ndlno, ndlnm)
    !
! - Input/output fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVECTUR', 'E', ires)
!
    if (option .eq. 'CHAR_ECHA_THM_R') then
        iopt = 1
        call jevech('PTEMPSR', 'L', itemps)
        deltat = zr(itemps+1)
        call jevech('PDEPLMR', 'L', idepm)
        p1m = zr(idepm+ndim+1)
        p2m = zr(idepm+ndim+2)
!      
! Recuperation des info sur le flux
        call jevech('PECHTHM', 'L', iech)
        c11 = zr(iech)
        c12 = zr(iech+1)
        c21 = zr(iech+2)
        c22 = zr(iech+3)
        p1ext = zr(iech+4)
        p2ext = zr(iech+5)  
    else if (option .eq. 'CHAR_ECHA_THM_F') then
        iopt = 2
        call jevech('PTEMPSR', 'L', itemps)
        deltat = zr(itemps+1)  
        valpar(2) = zr(itemps)
        call jevech('PDEPLMR', 'L', idepm)
        p1m = zr(idepm+ndim+1)
        p2m = zr(idepm+ndim+2) 
        valpar(1) = p1m
        valpar(2) = zr(itemps)
!
! Recuperation des informations sur le flux
        call jevech('PCHTHMF', 'L', iechf)
        call fointe('FM', zk8(iechf), 1, nompar(1), valpar(1), c11 , iret)
        call fointe('FM', zk8(iechf+1), 1, nompar(1), valpar(1), c12 , iret)
        call fointe('FM', zk8(iechf+2), 1, nompar(1), valpar(1), c21 , iret)
        call fointe('FM', zk8(iechf+3), 1,nompar(1), valpar(1), c22 , iret)
        call fointe('FM', zk8(iechf+4), 1, nompar(2), valpar(2), p1ext , iret)
        call fointe('FM', zk8(iechf+5), 1, nompar(2), valpar(2), p2ext , iret)
    else
        ASSERT(ASTER_FALSE)
    endif

! ======================================================================
!
! ======================================================================
!Specif 3D
! ======================================================================
    jv_dfunc = jv_func + npi * nno
    idfdy = jv_dfunc + 1
!
! --- CALCUL DES PRODUITS VECTORIELS OMI X OMJ ---
!
    do ino = 1, nno
        i = igeom + 3*(ino-1) -1
        do jno = 1, nno
            j = igeom + 3*(jno-1) -1
            sx(ino,jno) = zr(i+2) * zr(j+3) - zr(i+3) * zr(j+2)
            sy(ino,jno) = zr(i+3) * zr(j+1) - zr(i+1) * zr(j+3)
            sz(ino,jno) = zr(i+1) * zr(j+2) - zr(i+2) * zr(j+1)
        end do
    end do
!
! ======================================================================
!     --- BOUCLE SUR LES POINTS DE GAUSS on ouvre une boucle à refermer
! ======================================================================
    do ipg = 1, npi
        kdec = (ipg-1)*nno*ndim
        ldec = (ipg-1)*nno
        ldec2 = (ipg-1)*nnos
!
        nx = 0.d0
        ny = 0.d0
        nz = 0.d0
!
! --- CALCUL DE LA NORMALE AU POINT DE GAUSS IPG ---
!
        do i = 1, nno
            idec = (i-1)*ndim
            do j = 1, nno
                jdec = (j-1)*ndim
                nx = nx + zr(jv_dfunc+kdec+idec)*zr(idfdy+kdec+jdec)*sx( i,j)
                ny = ny + zr(jv_dfunc+kdec+idec)*zr(idfdy+kdec+jdec)*sy( i,j)
                nz = nz + zr(jv_dfunc+kdec+idec)*zr(idfdy+kdec+jdec)*sz( i,j)
            end do
        end do
!
        jac = sqrt(nx*nx+ny*ny+nz*nz)
!
! ======================================================================
! --- OPTION ECHA_THM_R
! ======================================================================
!

        fluth = 0.d0
        flu1 = c11*(p1m-p1ext)+c12*(p2m-p2ext)
        flu2 = c21*(p1m-p1ext)+c22*(p2m-p2ext)
        if (iopt .eq. 1 .or. iopt .eq. 2) then
!
! --------- Temp-Meca-Hydr1(2)-Hydr2(1,2)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 2 .and.&
                ds_thm%ds_elem%l_dof_pre2 .and.&
                ds_thm%ds_elem%l_dof_ther) then
!
! --- NAPRE1,NAPRE2,NATEMP SONT MIS EN PLACE
! --- POUR UNE EVENTUELLE MODIFICATION DE L'ORDRE DES DDL :
!     PRE1, PRE2, TEMP DANS LES CATALOGUES D'ELEMENTS
!
                napre1=0
                napre2=1
                natemp=2
!
                if (ds_thm%ds_elem%l_dof_meca) then
                    do i = 1, nnos
                        l = 6 * (i-1) -1
                        zr(ires+l+4) = zr(ires+l+4) - &
                            zr(jv_poids+ipg-1) * deltat * flu1  * zr(jv_func2+ldec2+i-1) * jac
                        zr(ires+l+5) = zr(ires+l+5) - &
                            zr(jv_poids+ipg-1) * deltat * flu2  * zr(jv_func2+ldec2+i-1) * jac
                        zr(ires+l+6) = zr(ires+l+6) - &
                            zr(jv_poids+ipg-1) * deltat * fluth * zr(jv_func2+ldec2+i-1) * jac
                    end do
                else
                    do i = 1, nnos
                        l = 3 * (i-1) -1
                        zr(ires+l+1) = zr(ires+l+1) - &
                            zr(jv_poids+ipg-1) * deltat * flu1  * zr(jv_func2+ldec2+i-1) * jac
                        zr(ires+l+2) = zr(ires+l+2) - &
                            zr(jv_poids+ipg-1) * deltat * flu2  * zr(jv_func2+ldec2+i-1) * jac
                        zr(ires+l+3) = zr(ires+l+3) - &
                            zr(jv_poids+ipg-1) * deltat * fluth * zr(jv_func2+ldec2+i-1) * jac
                    end do
                endif
            endif
!!
! --------- Hydr1(2)-Hydr2(1,2)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 2 .and.&
                ds_thm%ds_elem%l_dof_pre2 .and.&
                .not. ds_thm%ds_elem%l_dof_ther .and.&
                .not. ds_thm%ds_elem%l_dof_meca) then
!
                do i = 1, nnos
                    l = 2 * (i-1) -1
                    zr(ires+l+1) = zr(ires+l+1) - &
                        zr(jv_poids+ipg-1) * deltat * flu1 * zr(jv_func2+ldec2+i-1) * jac
                    zr(ires+l+2) = zr(ires+l+2) - &
                        zr(jv_poids+ipg-1) * deltat * flu2 * zr(jv_func2+ldec2+i-1) * jac
                end do
            endif
!
! --------- Meca-Hydr1(2)-Hydr2(1,2)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 2 .and.&
                      ds_thm%ds_elem%l_dof_pre2 .and.&
                .not. ds_thm%ds_elem%l_dof_ther .and.&
                      ds_thm%ds_elem%l_dof_meca) then
!
                do i = 1, nnos
                    l = 5 * (i-1) -1
                    zr(ires+l+4) = zr(ires+l+4) -&
                        zr(jv_poids+ipg-1) * deltat * flu1 * zr(jv_func2+ldec2+i-1) * jac
                    zr(ires+l+5) = zr(ires+l+5) -&
                        zr(jv_poids+ipg-1) * deltat * flu2 * zr(jv_func2+ldec2+i-1) * jac
                end do
            endif
        endif
    end do
!
end subroutine
