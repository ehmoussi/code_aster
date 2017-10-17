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
subroutine te0466(option, nomte)
!
use THM_type
use THM_module
!
implicit none
!
#include "jeveux.h"
#include "asterfort/dimthm.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/utmess.h"
#include "asterfort/elrefe_info.h"
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
! Elements: THM - 3D (FE and SUSHI)
!
! Options: CHAR_MECA_FLUX_R, CHAR_MECA_FLUX_F, CHAR_MECA_PRES_R, CHAR_MECA_PRES_F, CHAR_MECA_FR2D3D
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_axi, l_steady, l_vf
    integer :: jv_poids, jv_func, jv_dfunc, jv_gano, jv_poids2, jv_dfunc2, jv_func2
    integer :: idfdy, igeom, i, j, l, ifluxf
    integer :: ndim, nno, ipg, npi, ires, iflux, itemps, ipres, ipresf
    integer :: idec, jdec, kdec, ldec, ldec2, ino, jno
    integer :: iopt, iret, iforc
    integer :: nnos, nnom, nflux
    real(kind=8) :: nx, ny, nz, sx(9, 9), sy(9, 9), sz(9, 9), jac, valpar(4)
    real(kind=8) :: deltat, flu1, flu2, fluth, x, y, z, fx, fy, fz
    integer :: napre1, napre2, natemp
    character(len=8) :: nompar(4), elrefe, elref2
    integer :: ndlno, ndlnm, ndim2
    real(kind=8) :: pres, presf
!
! --------------------------------------------------------------------------------------------------
!
    call thmModuleInit()
    ndim = 2
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
                        npi_ = npi)
!
! - Get number of dof on boundary
!
    ndim2 = 3
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
        deltat = zr(itemps+1)
        nompar(1) = 'X'
        nompar(2) = 'Y'
        nompar(3) = 'Z'
        nompar(4) = 'INST'
        valpar(4) = zr(itemps)
    else if (option.eq.'CHAR_MECA_PRES_R') then
        iopt = 3
        call jevech('PPRESSR', 'L', ipres)
    else if (option.eq.'CHAR_MECA_PRES_F') then
        iopt = 4
        call jevech('PPRESSF', 'L', ipresf)
        call jevech('PTEMPSR', 'L', itemps)
        nompar(1) = 'X'
        nompar(2) = 'Y'
        nompar(3) = 'Z'
        nompar(4) = 'INST'
        valpar(4) = zr(itemps)
    else if (option.eq.'CHAR_MECA_FR2D3D') then
        iopt = 5
        call jevech('PFR2D3D', 'L', iforc)
    endif
!
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
!     --- BOUCLE SUR LES POINTS DE GAUSS ---
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
! OPTIONS CHAR_MECA_FLUX_R ET CHAR_MECA_FLUX_F (INTERPOLATION LINEAIRE)
! ======================================================================
!
        if (iopt .eq. 1 .or. iopt .eq. 2) then
!
! ======================================================================
! --- SI MODELISATION = SUSHI HH2 AVEC OU SANS VOISINAGE
!
            if (l_vf) then
!
!
! --- NAPRE1,NAPRE2,NATEMP SONT MIS EN PLACE
! --- POUR UNE EVENTUELLE MODIFICATION DE L'ORDRE DES DDL :
!     PRE1, PRE2, TEMP DANS LES CATALOGUES D'ELEMENTS
!
                napre1=0
                napre2=1
                nflux =2
!
                if (iopt .eq. 1) then
!
! ---   FLU1 REPRESENTE LE FLUX ASSOCIE A PRE1
! ---   FLU2 REPRESENTE LE FLUX ASSOCIE A PRE2
! ---   ET FLUTH LE FLUX THERMIQUE
!
                    flu1 = zr((iflux)+(ipg-1)*nflux+napre1 )
                    flu2 = zr((iflux)+(ipg-1)*nflux+napre2 )
!
                else if (iopt.eq.2) then
                    x = 0.d0
                    y = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        x = x + zr(igeom+3*i-3) * zr(jv_func2+ldec+i-1)
                        y = y + zr(igeom+3*i-2) * zr(jv_func2+ldec+i-1)
                        z = z + zr(igeom+3*i-1) * zr(jv_func2+ldec+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1, iret)
                    call fointe('FM', zk8(ifluxf+napre2), 4, nompar, valpar, flu2, iret)
                endif
!
                do i = 1, nnos
                    zr(ires) = zr(ires) - zr(jv_poids+ipg-1) * flu1 * zr(jv_func2+ldec2+i-1) * jac
                    zr(ires+1) = zr(ires+1) - zr(jv_poids+ipg-1)*flu2*zr(jv_func2+ldec2+i-1) * jac
                end do
                goto 99
            endif
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
                if (iopt .eq. 1) then
!
! ---   FLU1 REPRESENTE LE FLUX ASSOCIE A PRE1
! ---   FLU2 REPRESENTE LE FLUX ASSOCIE A PRE2
! ---   ET FLUTH LE FLUX THERMIQUE
!
                    flu1 = zr((iflux)+(ipg-1)*3+napre1 )
                    flu2 = zr((iflux)+(ipg-1)*3+napre2 )
                    fluth = zr((iflux)+(ipg-1)*3+natemp )
!
                else if (iopt.eq.2) then
                    x = 0.d0
                    y = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        x = x + zr(igeom+3*i-3) * zr(jv_func2+ldec+i-1)
                        y = y + zr(igeom+3*i-2) * zr(jv_func2+ldec+i-1)
                        z = z + zr(igeom+3*i-1) * zr(jv_func2+ldec+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1 , iret)
                    call fointe('FM', zk8(ifluxf+napre2), 4, nompar, valpar, flu2 , iret)
                    call fointe('FM', zk8(ifluxf+natemp), 4, nompar, valpar, fluth, iret)
                endif
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
!
! --------- Hydr1(2)-Hydr2(1,2)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 2 .and.&
                ds_thm%ds_elem%l_dof_pre2 .and.&
                .not. ds_thm%ds_elem%l_dof_ther .and.&
                .not. ds_thm%ds_elem%l_dof_meca) then
!
! --- NAPRE1,NAPRE2,NATEMP SONT MIS EN PLACE
! --- POUR UNE EVENTUELLE MODIFICATION DE L'ORDRE DES DDL :
!     PRE1, PRE2, TEMP DANS LES CATALOGUES D'ELEMENTS
!
                napre1=0
                napre2=1
!
                if (iopt .eq. 1) then
                    flu1 = zr((iflux)+(ipg-1)*2+napre1 )
                    flu2 = zr((iflux)+(ipg-1)*2+napre2 )
                else if (iopt.eq.2) then
                    x = 0.d0
                    y = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        x = x + zr(igeom+3*i-3) * zr(jv_func2+ldec+i-1)
                        y = y + zr(igeom+3*i-2) * zr(jv_func2+ldec+i-1)
                        z = z + zr(igeom+3*i-1) * zr(jv_func2+ldec+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1, iret)
                    call fointe('FM', zk8(ifluxf+napre2), 4, nompar, valpar, flu2, iret)
                endif
                do i = 1, nnos
                    l = 2 * (i-1) -1
                    zr(ires+l+1) = zr(ires+l+1) - &
                        zr(jv_poids+ipg-1) * deltat * flu1 * zr(jv_func2+ldec2+i-1) * jac
                    zr(ires+l+2) = zr(ires+l+2) - &
                        zr(jv_poids+ipg-1) * deltat * flu2 * zr(jv_func2+ldec2+i-1) * jac
                end do
            endif
!
! --------- Temp - Hydr1(2)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 2 .and.&
                .not. ds_thm%ds_elem%l_dof_pre2 .and.&
                      ds_thm%ds_elem%l_dof_ther .and.&
                .not. ds_thm%ds_elem%l_dof_meca) then
!
! --- NAPRE1,NATEMP SONT MIS EN PLACE
! --- POUR UNE EVENTUELLE MODIFICATION DE L'ORDRE DES DDL :
!     PRE1, PRE2, TEMP DANS LES CATALOGUES D'ELEMENTS
!
                napre1=0
                natemp=1
                if (iopt .eq. 1) then
                    flu1 = zr((iflux)+(ipg-1)*2+napre1 )
                    fluth = zr((iflux)+(ipg-1)*2+natemp )
                else if (iopt.eq.2) then
                    x = 0.d0
                    y = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        x = x + zr(igeom+3*i-3) * zr(jv_func2+ldec2+i-1)
                        y = y + zr(igeom+3*i-2) * zr(jv_func2+ldec2+i-1)
                        z = z + zr(igeom+3*i-1) * zr(jv_func2+ldec2+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1 , iret)
                    call fointe('FM', zk8(ifluxf+napre2), 4, nompar, valpar, flu2 , iret)
                    call fointe('FM', zk8(ifluxf+natemp), 4, nompar, valpar, fluth, iret)
                endif
                do i = 1, nnos
                    l = 2 * (i-1) -1
                    zr(ires+l+1) = zr(ires+l+1) -&
                        zr(jv_poids+ipg-1) * deltat * flu1  * zr(jv_func2+ldec2+i-1) * jac
                    zr(ires+l+2) = zr(ires+l+2) -&
                        zr(jv_poids+ipg-1) * deltat * fluth * zr(jv_func2+ldec2+i-1) * jac
                end do
            endif
!
! --------- Meca-Hydr1(1)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 1 .and.&
                .not. ds_thm%ds_elem%l_dof_pre2 .and.&
                .not. ds_thm%ds_elem%l_dof_ther .and.&
                      ds_thm%ds_elem%l_dof_meca) then

                napre1=0
                if (iopt .eq. 1) then
                    flu1 = zr((iflux)+(ipg-1)+napre1 )
                else if (iopt.eq.2) then
                    x = 0.d0
                    y = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        x = x + zr(igeom+3*i-3) * zr(jv_func2+ldec2+i-1)
                        y = y + zr(igeom+3*i-2) * zr(jv_func2+ldec2+i-1)
                        z = z + zr(igeom+3*i-1) * zr(jv_func2+ldec2+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1, iret)
                endif
                do i = 1, nnos
                    l = 4 * (i-1) -1
                    zr(ires+l+4) = zr(ires+l+4) -&
                        zr(jv_poids+ipg-1) * deltat * flu1 * zr(jv_func2+ldec2+i-1) * jac
                end do
            endif
!
! --------- Meca-Hydr1(2)-Hydr2(1,2)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 2 .and.&
                      ds_thm%ds_elem%l_dof_pre2 .and.&
                .not. ds_thm%ds_elem%l_dof_ther .and.&
                      ds_thm%ds_elem%l_dof_meca) then
                napre1=0
                napre2=1
                if (iopt .eq. 1) then
!
! ---    FLU1 REPRESENTE LE FLUX ASSOCIE A PRE1
! ---    FLU2 REPRESENTE LE FLUX ASSOCIE A PRE2
!
                    flu1 = zr((iflux)+(ipg-1)*2+napre1 )
                    flu2 = zr((iflux)+(ipg-1)*2+napre2 )
                else if (iopt.eq.2) then
                    x = 0.d0
                    y = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        x = x + zr(igeom+3*i-3) * zr(jv_func2+ldec2+i-1)
                        y = y + zr(igeom+3*i-2) * zr(jv_func2+ldec2+i-1)
                        z = z + zr(igeom+3*i-1) * zr(jv_func2+ldec2+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1, iret)
                    call fointe('FM', zk8(ifluxf+napre2), 4, nompar, valpar, flu2, iret)
                endif
                do i = 1, nnos
                    l = 5 * (i-1) -1
                    zr(ires+l+4) = zr(ires+l+4) -&
                        zr(jv_poids+ipg-1) * deltat * flu1 * zr(jv_func2+ldec2+i-1) * jac
                    zr(ires+l+5) = zr(ires+l+5) -&
                        zr(jv_poids+ipg-1) * deltat * flu2 * zr(jv_func2+ldec2+i-1) * jac
                end do
            endif
!
! --------- Meca-Temp-Hydr1(1)
!
            if (ds_thm%ds_elem%nb_phase(1) .eq. 1 .and.&
                .not. ds_thm%ds_elem%l_dof_pre2 .and.&
                      ds_thm%ds_elem%l_dof_ther .and.&
                      ds_thm%ds_elem%l_dof_meca) then
                napre1=0
                natemp=1
                if (iopt .eq. 1) then
!
! ---    FLU1 REPRESENTE LE FLUX ASSOCIE A PRE1
! ---    ET FLUTH LA THERMIQUE
!
                    flu1 = zr((iflux)+(ipg-1)*2+napre1 )
                    fluth = zr((iflux)+(ipg-1)*2+natemp )
!
                else if (iopt.eq.2) then
                    x = 0.d0
                    y = 0.d0
                    z = 0.d0
                    do i = 1, nnos
                        x = x + zr(igeom+3*i-3) * zr(jv_func2+ldec2+i-1)
                        y = y + zr(igeom+3*i-2) * zr(jv_func2+ldec2+i-1)
                        z = z + zr(igeom+3*i-1) * zr(jv_func2+ldec2+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1 , iret)
                    call fointe('FM', zk8(ifluxf+natemp), 4, nompar, valpar, fluth, iret)
                endif
                do i = 1, nnos
                    l = 5 * (i-1) -1
                    zr(ires+l+4) = zr(ires+l+4) -&
                        zr(jv_poids+ipg-1) * deltat * flu1  * zr(jv_func2+ldec2+i-1) * jac
                    zr(ires+l+5) = zr(ires+l+5) -&
                        zr(jv_poids+ipg-1) * deltat * fluth * zr(jv_func2+ldec2+i-1) * jac
                end do
            endif
!
! ======================================================================
!        --- OPTION CHAR_MECA_PRES_R OU CHAR_MECA_PRES_F ---
! INTERPOLATION QUADRATIQUE
! ======================================================================
        else if ((iopt.eq.3) .or. (iopt.eq.4)) then
            if (iopt .eq. 3) then
                pres = 0.d0
                do i = 1, nno
                    pres = pres + zr(ipres+i-1)*zr(jv_func+ldec+i-1)
                end do
            else if (iopt.eq.4) then
                pres = 0.d0
                do i = 1, nno
                    valpar(1) = zr(igeom+3*i-3)
                    valpar(2) = zr(igeom+3*i-2)
                    valpar(3) = zr(igeom+3*i-1)
                    call fointe('FM', zk8(ipresf), 4, nompar, valpar,&
                                presf, iret)
                    pres = pres + presf*zr(jv_func+ldec+i-1)
                end do
            endif
!
            do i = 1, nnos
                l = ndlno * (i-1) -1
                zr(ires+l+1) = zr(ires+l+1) - zr(jv_poids+ipg-1) * pres * zr(jv_func+ldec+i-1) * nx
                zr(ires+l+2) = zr(ires+l+2) - zr(jv_poids+ipg-1) * pres * zr(jv_func+ldec+i-1) * ny
                zr(ires+l+3) = zr(ires+l+3) - zr(jv_poids+ipg-1) * pres * zr(jv_func+ldec+i-1) * nz
            end do
            do i = 1, (nno-nnos)
                l = ndlno*nnos + ndlnm*(i-1) -1
                zr(ires+l+1) = zr(ires+l+1) - zr(jv_poids+ipg-1)*pres*zr(jv_func+ldec+i+nnos-1) * nx
                zr(ires+l+2) = zr(ires+l+2) - zr(jv_poids+ipg-1)*pres*zr(jv_func+ldec+i+nnos-1) * ny
                zr(ires+l+3) = zr(ires+l+3) - zr(jv_poids+ipg-1)*pres*zr(jv_func+ldec+i+nnos-1) * nz
            end do
!
! ======================================================================
!        --- OPTION CHAR_MECA_FR2D3D : FORCE_FACE ---
! ======================================================================
!
        else if (iopt.eq.5) then
            fx = 0.0d0
            fy = 0.0d0
            fz = 0.0d0
            do i = 1, nno
                fx = fx + zr(iforc-1+3*(i-1)+1)*zr(jv_func+ldec+i-1)
                fy = fy + zr(iforc-1+3*(i-1)+2)*zr(jv_func+ldec+i-1)
                fz = fz + zr(iforc-1+3*(i-1)+3)*zr(jv_func+ldec+i-1)
            end do
            do i = 1, nno
                l = ndlno * (i-1) -1
                zr(ires+l+1) = zr(ires+l+1) + zr(jv_poids+ipg-1)*fx*zr( jv_func+ldec+i-1)*jac
                zr(ires+l+2) = zr(ires+l+2) + zr(jv_poids+ipg-1)*fy*zr( jv_func+ldec+i-1)*jac
                zr(ires+l+3) = zr(ires+l+3) + zr(jv_poids+ipg-1)*fz*zr( jv_func+ldec+i-1)*jac
            end do
            do i = 1, nno
                l = ndlno*nnos+ndlnm * (i-1) -1
                zr(ires+l+1) = zr(ires+l+1) + zr(jv_poids+ipg-1)*fx*zr( jv_func+ldec+i+nnos-1)*jac
                zr(ires+l+2) = zr(ires+l+2) + zr(jv_poids+ipg-1)*fy*zr( jv_func+ldec+i+nnos-1)*jac
                zr(ires+l+3) = zr(ires+l+3) + zr(jv_poids+ipg-1)*fz*zr( jv_func+ldec+i+nnos-1)*jac
            end do
        endif
99      continue
    end do
!
end subroutine
