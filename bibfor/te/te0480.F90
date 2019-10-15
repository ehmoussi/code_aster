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

subroutine te0480(option, nomte)
!
use THM_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dimthm.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/vff2dn.h"
#include "asterfort/assert.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/thmGetElemRefe.h"
#include "asterfort/thmGetElemInfo.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: THM - 2D (FE)
!
! Options: ECHA_THM_R ECHA_THM_F
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_axi, l_steady, l_vf
    integer :: nno, nnos, kp, npg, ndim, nnom,  ndim2
    integer :: jv_gano, jv_poids, jv_poids2, jv_func, jv_func2, jv_dfunc, jv_dfunc2
    integer :: k, kk, i, l, ires, itemps, iopt, ndlnm, iech
    integer :: iret, ndlno, igeom,iechf
    real(kind=8) :: poids, r, z, nx, ny, valpar(2), deltat
    real(kind=8) :: poids2, nx2, ny2, flu1, flu2, fluth
    real(kind=8) :: c11,c12,c21,c22,p1ext,p2ext,p1m,p2m
    character(len=8) :: nompar(2), elrefe, elref2
    integer :: idepm
!
!
    type(THM_DS) :: ds_thm
!
! --------------------------------------------------------------------------------------------------
!
    ndim = 1
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
                        npg_ = npg)
!
! - Get number of dof on boundary
!
    ndim2 = 2
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
!        tm = zr(idepm+ndim+3)
!      
! Recuperation des informations sur le flux
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
        call jevech('PDEPLMR', 'L', idepm)
        p1m = zr(idepm+ndim+1)
        p2m = zr(idepm+ndim+2)   
        valpar(1) = p1m
        valpar(2) = zr(itemps)
! Recuperation des informations sur le flux 
        call jevech('PCHTHMF', 'L', iechf)
        call fointe('FM', zk8(iechf), 1, nompar(1), valpar(1), c11 , iret)
        call fointe('FM', zk8(iechf+1), 1, nompar(1), valpar(1), c12 , iret)
        call fointe('FM', zk8(iechf+2), 1, nompar(1), valpar(1), c21 , iret)
        call fointe('FM', zk8(iechf+3), 1,nompar(1), valpar(1), c22 , iret)
        call fointe('FM', zk8(iechf+4), 1, nompar(2), valpar(2), p1ext , iret)
        call fointe('FM', zk8(iechf+5), 1, nompar(2), valpar(2), p2ext , iret)
!
     else
        ASSERT(ASTER_FALSE)
    endif
! ======================================================================
! --- CAS DU PERMANENT POUR LA PARTIE H OU T : LE SYSTEME A ETE --------
! --- CONSTRUIT EN SIMPLIFIANT PAR LE PAS DE TEMPS. ON DOIT DONC -------
! --- LE PRENDRE EGAL A 1 DANS LE CALCUL DU SECOND MEMBRE --------------
! ======================================================================
! ======================================================================
! --- BOUCLE SUR LES POINTS DE GAUSS DE L'ELEMENT DE BORD --------------
! ======================================================================
    do kp = 1, npg
        k = (kp-1)*nno
        kk = (kp-1)*nnos
! ======================================================================
! --- RECUPERATION DES DERIVEES DES FONCTONS DE FORMES -----------------
! ======================================================================
        call vff2dn(ndim, nno, kp, jv_poids, jv_dfunc,&
                    zr(igeom), nx, ny, poids)
        call vff2dn(ndim, nnos, kp, jv_poids2, jv_dfunc2,&
                    zr(igeom), nx2, ny2, poids2)
! ======================================================================
! --- MODIFICATION DU POIDS POUR LES CAS AXI ---------------------------
! ======================================================================
        if (l_axi) then
            r = 0.d0
            z = 0.d0
            do i = 1, nno
                l = (kp-1)*nno + i
                r = r + zr(igeom+2*i-2)*zr(jv_func+l-1)
            end do
            poids = poids*r
        endif
! ======================================================================
! --- OPTION ECHA_THM_R 
! ======================================================================

! ======================================================================
! --- FLUTH REPRESENTE LE FLUX THERMIQUE -------------------------------
! --- FLU1 REPRESENTE LE FLUX ASSOCIE A PRE1 ---------------------------
! --- FLU2 REPRESENTE LE FLUX ASSOCIE A PRE2 ---------------------------
! ======================================================================
        fluth = 0.
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
                if (ds_thm%ds_elem%l_dof_meca) then
                    do i = 1, nnos
                        l = 5* (i-1) - 1
                        zr(ires+l+3) = zr(ires+l+3) - poids*deltat* flu1*zr(jv_func2+kk+i-1)
                        zr(ires+l+4) = zr(ires+l+4) - poids*deltat* flu2*zr(jv_func2+kk+i-1)
                        zr(ires+l+5) = zr(ires+l+5) - poids*deltat* fluth*zr(jv_func2+kk+i-1)
                    end do
                else
                    do i = 1, nnos
                        l = 3* (i-1) - 1
                        zr(ires+l+1) = zr(ires+l+1) - poids*deltat* flu1*zr(jv_func2+kk+i-1)
                        zr(ires+l+2) = zr(ires+l+2) - poids*deltat* flu2*zr(jv_func2+kk+i-1)
                        zr(ires+l+3) = zr(ires+l+3) - poids*deltat* fluth*zr(jv_func2+kk+i-1)
                    end do
                endif
            endif
!
! --------- Hydr1(2)-Hydr2(1,2)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 2 .and.&
                ds_thm%ds_elem%l_dof_pre2 .and.&
                .not. ds_thm%ds_elem%l_dof_ther .and.&
                .not. ds_thm%ds_elem%l_dof_meca) then
!
                do i = 1, nnos
                     l = 2* (i-1) - 1
                     zr(ires+l+1) = zr(ires+l+1) - poids*deltat* flu1*zr(jv_func2+kk+i-1)
                     zr(ires+l+2) = zr(ires+l+2) - poids*deltat* flu2*zr(jv_func2+kk+i-1)
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
                    l = 4* (i-1) - 1
                    zr(ires+l+3) = zr(ires+l+3) - poids*deltat*flu1* zr(jv_func2+kk+i-1)
                    zr(ires+l+4) = zr(ires+l+4) - poids*deltat*flu2* zr(jv_func2+kk+i-1)
                end do                                  
            endif
!
        endif
    end do
!
end subroutine
