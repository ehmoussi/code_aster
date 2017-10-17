! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
! person_in_charge: sylvie.granet at edf.fr
!
subroutine te0472(option, nomte)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dimthm.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/vff2dn.h"
#include "asterfort/lteatt.h"
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
! Elements: THM - 2D (FE and SUSHI)
!
! Options: CHAR_MECA_FLUX_R, CHAR_MECA_FLUX_F, CHAR_MECA_PRES_R, CHAR_MECA_PRES_F
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_axi, l_steady, l_vf
    integer :: nno, nnos, kp, npg, ndim, nnom, napre1, napre2, ndim2
    integer :: jv_gano, jv_poids, jv_poids2, jv_func, jv_func2, jv_dfunc, jv_dfunc2
    integer :: ipres, k, kk, i, l, ires, iflux, itemps, iopt, ipresf, ndlnm
    integer :: ifluxf, iret, ndlno, igeom, natemp
    real(kind=8) :: poids, r, z, tx, ty, nx, ny, valpar(3), deltat, tplus
    real(kind=8) :: pres, presf, poids2, nx2, ny2, flu1, flu2, fluth
    character(len=8) :: nompar(3), elrefe, elref2
!
! --------------------------------------------------------------------------------------------------
!
    call thmModuleInit()
    ndim = 1
!
! - Get model of finite element
!
    call thmGetElemModel(l_axi_ = l_axi, l_vf_ = l_vf, l_steady_ = l_steady)
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
    call dimthm(l_vf, ndim2, ndlno, ndlnm)
!
! - Input/output fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVECTUR', 'E', ires)
    if (option .eq. 'CHAR_MECA_FLUX_R') then
        iopt = 1
        call jevech('PFLUXR', 'L', iflux)
        call jevech('PTEMPSR', 'L', itemps)
        deltat = zr(itemps+1)
    else if (option.eq.'CHAR_MECA_FLUX_F') then
        iopt = 2
        call jevech('PFLUXF', 'L', ifluxf)
        call jevech('PTEMPSR', 'L', itemps)
        tplus = zr(itemps)
        deltat = zr(itemps+1)
        nompar(1) = 'X'
        nompar(2) = 'Y'
        nompar(3) = 'INST'
        valpar(3) = tplus
! ======================================================================
! --- CAS DES PRESSIONS MECANIQUES -------------------------------------
! ======================================================================
    else if (option.eq.'CHAR_MECA_PRES_R') then
        iopt = 3
        call jevech('PPRESSR', 'L', ipres)
    else if (option.eq.'CHAR_MECA_PRES_F') then
        iopt = 4
        call jevech('PPRESSF', 'L', ipresf)
        call jevech('PTEMPSR', 'L', itemps)
        nompar(1) = 'X'
        nompar(2) = 'Y'
        nompar(3) = 'INST'
        valpar(3) = zr(itemps)
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
! --- OPTION CHAR_MECA_FLUX_R OU CHAR_MECA_FLUX_F ----------------------
! ======================================================================
! --- DANS CES CAS LES INTERPOLATIONS SONT LINEAIRES -------------------
! --- CAR FLUX = GRANDEURS TH (ON UTILISE IVF2 ET nnos) ----------------
! ======================================================================
! --- NAPRE1,NAPRE2,NATEMP SONT MIS EN PLACE ---------------------------
! --- POUR UNE EVENTUELLE MODIFICATION DE L'ORDRE DES DDL --------------
! --- PRE1, PRE2, TEMP DANS LES CATALOGUES D'ELEMENTS ------------------
! ======================================================================
! --- FLUTH REPRESENTE LE FLUX THERMIQUE -------------------------------
! --- FLU1 REPRESENTE LE FLUX ASSOCIE A PRE1 ---------------------------
! --- FLU2 REPRESENTE LE FLUX ASSOCIE A PRE2 ---------------------------
! ======================================================================
        if (iopt .eq. 1 .or. iopt .eq. 2) then
!
! --------- Temp-Meca-Hydr1(2)-Hydr2(1,2)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 2 .and.&
                ds_thm%ds_elem%l_dof_pre2 .and.&
                ds_thm%ds_elem%l_dof_ther) then
                napre1 = 0
                napre2 = 1
                natemp = 2
                if (iopt .eq. 1) then
                    flu1 = zr(iflux+(kp-1)*3+napre1)
                    flu2 = zr(iflux+(kp-1)*3+napre2)
                    fluth = zr(iflux+(kp-1)*3+natemp)
                else if (iopt.eq.2) then
                    r = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        l = (kp-1)*nnos + i
                        r = r + zr(igeom+2*i-2)*zr(jv_func2+l-1)
                        z = z + zr(igeom+2*i-1)*zr(jv_func2+l-1)
                    end do
                    valpar(1) = r
                    valpar(2) = z
                    call fointe('FM', zk8(ifluxf+napre1), 3, nompar, valpar, flu1 , iret)
                    call fointe('FM', zk8(ifluxf+napre2), 3, nompar, valpar, flu2 , iret)
                    call fointe('FM', zk8(ifluxf+natemp), 3, nompar, valpar, fluth, iret)
                endif
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
                napre1 = 0
                napre2 = 1
                if (iopt .eq. 1) then
                    flu1 = zr(iflux+(kp-1)*2+napre1)
                    flu2 = zr(iflux+(kp-1)*2+napre2)
                else if (iopt.eq.2) then
                    r = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        l = (kp-1)*nnos + i
                        r = r + zr(igeom+2*i-2)*zr(jv_func2+l-1)
                        z = z + zr(igeom+2*i-1)*zr(jv_func2+l-1)
                    end do
                    valpar(1) = r
                    valpar(2) = z
                    call fointe('FM', zk8(ifluxf+napre1), 2, nompar, valpar, flu1, iret)
                    call fointe('FM', zk8(ifluxf+napre2), 2, nompar, valpar, flu2, iret)
                endif
!
                if (l_vf) then
                    do i = 1, nnos
                        zr(ires) = zr(ires) - poids*flu1*zr(jv_func2+kk+i- 1)
                        zr(ires+1) = zr(ires+1) - poids*flu2*zr(jv_func2+ kk+i-1)
                    end do
                else
                    do i = 1, nnos
                        l = 2* (i-1) - 1
                        zr(ires+l+1) = zr(ires+l+1) - poids*deltat* flu1*zr(jv_func2+kk+i-1)
                        zr(ires+l+2) = zr(ires+l+2) - poids*deltat* flu2*zr(jv_func2+kk+i-1)
                    end do
                endif
            endif
!
! --------- Temp - Hydr1(2)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 2 .and.&
                .not. ds_thm%ds_elem%l_dof_pre2 .and.&
                      ds_thm%ds_elem%l_dof_ther .and.&
                .not. ds_thm%ds_elem%l_dof_meca) then
                napre1 = 0
                natemp = 1
                if (iopt .eq. 1) then
                    flu1 = zr(iflux+ (kp-1)*2+napre1)
                    fluth = zr(iflux+ (kp-1)*2+natemp)
                else if (iopt.eq.2) then
                    r = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        l = (kp-1)*nnos + i
                        r = r + zr(igeom+2*i-2)*zr(jv_func2+l-1)
                        z = z + zr(igeom+2*i-1)*zr(jv_func2+l-1)
                    end do
                    valpar(1) = r
                    valpar(2) = z
                    call fointe('FM', zk8(ifluxf+napre1), 3, nompar, valpar,&
                                flu1, iret)
                    call fointe('FM', zk8(ifluxf+napre2), 3, nompar, valpar,&
                                flu2, iret)
                    call fointe('FM', zk8(ifluxf+natemp), 3, nompar, valpar,&
                                fluth, iret)
                endif
                do i = 1, nnos
                    l = 2* (i-1) - 1
                    zr(ires+l+1) = zr(ires+l+1) - poids*deltat*flu1* zr(jv_func2+kk+i-1)
                    zr(ires+l+2) = zr(ires+l+2) - poids*deltat*fluth* zr(jv_func2+kk+i-1)
                end do
            endif
!
! --------- Hydr1(1)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 1 .and.&
                .not. ds_thm%ds_elem%l_dof_pre2 .and.&
                .not. ds_thm%ds_elem%l_dof_ther .and.&
                .not. ds_thm%ds_elem%l_dof_meca) then
                napre1 = 0
                if (iopt .eq. 1) then
                    flu1 = zr(iflux+ (kp-1)+napre1)
                else if (iopt.eq.2) then
                    r = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        l = (kp-1)*nnos + i
                        r = r + zr(igeom+2*i-2)*zr(jv_func2+l-1)
                        z = z + zr(igeom+2*i-1)*zr(jv_func2+l-1)
                    end do
                    valpar(1) = r
                    valpar(2) = z
                    call fointe('FM', zk8(ifluxf+napre1), 3, nompar, valpar,&
                                flu1, iret)
                endif
                do i = 1, nnos
                    l = 1* (i-1) - 1
                    zr(ires+l+1) = zr(ires+l+1) - poids*deltat*flu1* zr(jv_func2+kk+i-1)
                end do
            endif
!
! --------- Meca-Hydr1(1)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 1 .and.&
                .not. ds_thm%ds_elem%l_dof_pre2 .and.&
                .not. ds_thm%ds_elem%l_dof_ther .and.&
                      ds_thm%ds_elem%l_dof_meca) then
                napre1 = 0
                if (iopt .eq. 1) then
                    flu1 = zr(iflux+ (kp-1)+napre1)
                else if (iopt.eq.2) then
                    r = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        l = (kp-1)*nnos + i
                        r = r + zr(igeom+2*i-2)*zr(jv_func2+l-1)
                        z = z + zr(igeom+2*i-1)*zr(jv_func2+l-1)
                    end do
                    valpar(1) = r
                    valpar(2) = z
                    call fointe('FM', zk8(ifluxf+napre1), 3, nompar, valpar,&
                                flu1, iret)
                endif
                do i = 1, nnos
                    l = 3* (i-1) - 1
                    if (.not.l_steady) then
                        zr(ires+l+3) = zr(ires+l+3) - poids*deltat* flu1*zr(jv_func2+kk+i-1)
                    else
                        zr(ires+l+3) = zr(ires+l+3) - poids*flu1*zr( jv_func2+kk+i-1)
                    endif
                end do
            endif
!
! --------- Meca-Hydr1(2)-Hydr2(1,2)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 2 .and.&
                      ds_thm%ds_elem%l_dof_pre2 .and.&
                .not. ds_thm%ds_elem%l_dof_ther .and.&
                      ds_thm%ds_elem%l_dof_meca) then
                napre1 = 0
                napre2 = 1
                if (iopt .eq. 1) then
                    flu1 = zr(iflux+ (kp-1)*2+napre1)
                    flu2 = zr(iflux+ (kp-1)*2+napre2)
                else if (iopt.eq.2) then
                    r = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        l = (kp-1)*nnos + i
                        r = r + zr(igeom+2*i-2)*zr(jv_func2+l-1)
                        z = z + zr(igeom+2*i-1)*zr(jv_func2+l-1)
                    end do
                    valpar(1) = r
                    valpar(2) = z
                    call fointe('FM', zk8(ifluxf+napre1), 3, nompar, valpar, flu1, iret)
                    call fointe('FM', zk8(ifluxf+napre2), 3, nompar, valpar, flu2, iret)
                endif
                do i = 1, nnos
                    l = 4* (i-1) - 1
                    zr(ires+l+3) = zr(ires+l+3) - poids*deltat*flu1* zr(jv_func2+kk+i-1)
                    zr(ires+l+4) = zr(ires+l+4) - poids*deltat*flu2* zr(jv_func2+kk+i-1)
                end do
            endif
!
! --------- Meca-Temp-Hydr1(1)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 1 .and.&
                .not. ds_thm%ds_elem%l_dof_pre2 .and.&
                      ds_thm%ds_elem%l_dof_ther .and.&
                      ds_thm%ds_elem%l_dof_meca) then
                napre1 = 0
                natemp = 1
                if (iopt .eq. 1) then
                    flu1 = zr(iflux+ (kp-1)*2+napre1)
                    fluth = zr(iflux+ (kp-1)*2+natemp)
                else if (iopt.eq.2) then
                    r = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        l = (kp-1)*nnos + i
                        r = r + zr(igeom+2*i-2)*zr(jv_func2+l-1)
                        z = z + zr(igeom+2*i-1)*zr(jv_func2+l-1)
                    end do
                    valpar(1) = r
                    valpar(2) = z
                    call fointe('FM', zk8(ifluxf+napre1), 3, nompar, valpar,&
                                flu1, iret)
                    call fointe('FM', zk8(ifluxf+natemp), 3, nompar, valpar,&
                                fluth, iret)
                endif
                do i = 1, nnos
                    l = 4* (i-1) - 1
                    zr(ires+l+3) = zr(ires+l+3) - poids*deltat*flu1* zr(jv_func2+kk+i-1)
                    zr(ires+l+4) = zr(ires+l+4) - poids*deltat*fluth* zr(jv_func2+kk+i-1)
                end do
            endif
! ======================================================================
! --- OPTION CHAR_MECA_PRES_R OU CHAR_MECA_PRES_F ----------------------
! ======================================================================
! --- ICI, LES INTERPOLATIONS SONT QUADRATIQUES ------------------------
! ======================================================================
        else if ((iopt.eq.3) .or. (iopt.eq.4)) then
            if (iopt .eq. 3) then
                pres = 0.d0
                do i = 1, nno
                    l = (kp-1)*nno + i
                    pres = pres + zr(ipres+i-1)*zr(jv_func+l-1)
                end do
            else if (iopt.eq.4) then
                pres = 0.d0
                do i = 1, nno
                    valpar(1) = zr(igeom+2*i-2)
                    valpar(2) = zr(igeom+2*i-1)
                    call fointe('FM', zk8(ipresf), 3, nompar, valpar,&
                                presf, iret)
                    l = (kp-1)*nno + i
                    pres = pres + presf*zr(jv_func+l-1)
                end do
            endif
            tx = -nx*pres
            ty = -ny*pres
            do i = 1, nnos
                l = ndlno* (i-1) - 1
                zr(ires+l+1) = zr(ires+l+1) + tx*zr(jv_func+k+i-1)*poids
                zr(ires+l+2) = zr(ires+l+2) + ty*zr(jv_func+k+i-1)*poids
            end do
            do i = 1, (nno - nnos)
                l = ndlno*nnos+ndlnm* (i-1) -1
                zr(ires+l+1) = zr(ires+l+1) + tx*zr(jv_func+k+i+nnos-1)* poids
                zr(ires+l+2) = zr(ires+l+2) + ty*zr(jv_func+k+i+nnos-1)* poids
            end do
        endif
    end do
!
end subroutine
