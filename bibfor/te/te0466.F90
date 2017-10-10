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
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/utmess.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/lteatt.h"
#include "asterfort/teattr.h"
!
character(len=16) :: option, nomte
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
    integer :: ipoids, ivf, idfdx, idfdy, igeom, i, j, l, ifluxf
    integer :: ndim, nno, ipg, npi, ires, iflux, itemps, jgano
    integer :: idec, jdec, kdec, ldec, ldec2, ino, jno
    integer :: iopt, iret, iforc
    integer :: nno2, nnos2, ipoid2, idfdx2, ivf2
    real(kind=8) :: nx, ny, nz, sx(9, 9), sy(9, 9), sz(9, 9), jac, valpar(4)
    real(kind=8) :: deltat, flu1, flu2, fluth, x, y, z, fx, fy, fz
    integer :: napre1, napre2, natemp, ndim2
    character(len=8) :: nompar(4), elrefe, mthm
    character(len=24) :: elref2
    integer :: ndlno, ndlnm, ipres, ipresf
    real(kind=8) :: pres, presf
    integer :: nnos, npi2
    integer :: nflux
!
! --------------------------------------------------------------------------------------------------
!
    call thmModuleInit()
!
! - Get model of finite element
!
    call thmGetElemModel(l_axi_ = l_axi, l_vf_ = l_vf, ndim_ = ndim, l_steady_ = l_steady)

    ndim2 = 3
    call elref1(elrefe)
    if (elrefe .eq. 'TR6') then
        elref2 = 'TR3'
    else if (elrefe.eq.'QU8') then
        elref2 = 'QU4'
    else if (elrefe.eq.'QU9') then
        elref2 = 'QU4'
    else
        call utmess('F', 'DVP_4', sk=elrefe)
    endif
! FONCTIONS DE FORMES QUADRATIQUES
    call elrefe_info(elrefe=elrefe,fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npi,jpoids=ipoids,jvf=ivf,jdfde=idfdx,jgano=jgano)
! FONCTIONS DE FORMES LINEAIRES
    call elrefe_info(elrefe=elref2,fami='RIGI',ndim=ndim,nno=nno2,nnos=nnos2,&
  npg=npi2,jpoids=ipoid2,jvf=ivf2,jdfde=idfdx2)
!
! NB DE DDL A CHAQUE NOEUD
    call dimthm(ndlno, ndlnm, ndim2)
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
    idfdx = ivf + npi * nno
    idfdy = idfdx + 1
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
        ldec2 = (ipg-1)*nno2
!
        nx = 0.0d0
        ny = 0.0d0
        nz = 0.0d0
!
! --- CALCUL DE LA NORMALE AU POINT DE GAUSS IPG ---
!
        do i = 1, nno
            idec = (i-1)*ndim
            do j = 1, nno
                jdec = (j-1)*ndim
                nx = nx + zr(idfdx+kdec+idec)*zr(idfdy+kdec+jdec)*sx( i,j)
                ny = ny + zr(idfdx+kdec+idec)*zr(idfdy+kdec+jdec)*sy( i,j)
                nz = nz + zr(idfdx+kdec+idec)*zr(idfdy+kdec+jdec)*sz( i,j)
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
            if (lteatt('TYPMOD3','SUSHI').and.lteatt('TYPMA','QU9')) then
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
                    do i = 1, nno2
                        x = x + zr(igeom+3*i-3) * zr(ivf2+ldec+i-1)
                        y = y + zr(igeom+3*i-2) * zr(ivf2+ldec+i-1)
                        z = z + zr(igeom+3*i-1) * zr(ivf2+ldec+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1, iret)
                    call fointe('FM', zk8(ifluxf+napre2), 4, nompar, valpar, flu2, iret)
                endif
!
                do i = 1, nno2
                    zr(ires) = zr(ires) - zr(ipoids+ipg-1) * flu1 * zr(ivf2+ldec2+i-1) * jac
                    zr(ires+1) = zr(ires+1) - zr(ipoids+ipg-1) * flu2 * zr(ivf2+ldec2+i-1) * jac
                end do
                goto 99
            endif
!
! --------- Temp-Meca-Hydr1-Hydr2
!
            if (lteatt('HYDR1','2')  .and. .not.lteatt('HYDR2','0') .and.&
                lteatt('THER','OUI')) then
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
                    do i = 1, nno2
                        x = x + zr(igeom+3*i-3) * zr(ivf2+ldec+i-1)
                        y = y + zr(igeom+3*i-2) * zr(ivf2+ldec+i-1)
                        z = z + zr(igeom+3*i-1) * zr(ivf2+ldec+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1 , iret)
                    call fointe('FM', zk8(ifluxf+napre2), 4, nompar, valpar, flu2 , iret)
                    call fointe('FM', zk8(ifluxf+natemp), 4, nompar, valpar, fluth, iret)
                endif
                if (lteatt('MECA','OUI')) then
! ----------------- Temp-Meca-Hydr1-Hydr2
                    do i = 1, nno2
                        l = 6 * (i-1) -1
                        zr(ires+l+4) = zr(ires+l+4) - &
                            zr(ipoids+ipg-1) * deltat * flu1  * zr(ivf2+ldec2+i-1) * jac
                        zr(ires+l+5) = zr(ires+l+5) - &
                            zr(ipoids+ipg-1) * deltat * flu2  * zr(ivf2+ldec2+i-1) * jac
                        zr(ires+l+6) = zr(ires+l+6) - &
                            zr(ipoids+ipg-1) * deltat * fluth * zr(ivf2+ldec2+i-1) * jac
                    end do
                else
! ----------------- Temp-Hydr1-Hydr2
                    do i = 1, nno2
                        l = 3 * (i-1) -1
                        zr(ires+l+1) = zr(ires+l+1) - &
                            zr(ipoids+ipg-1) * deltat * flu1  * zr(ivf2+ldec2+i-1) * jac
                        zr(ires+l+2) = zr(ires+l+2) - &
                            zr(ipoids+ipg-1) * deltat * flu2  * zr(ivf2+ldec2+i-1) * jac
                        zr(ires+l+3) = zr(ires+l+3) - &
                            zr(ipoids+ipg-1) * deltat * fluth * zr(ivf2+ldec2+i-1) * jac
                    end do
                endif
!
            endif
!
! --------- Hydr1-Hydr2
!
            if (lteatt('HYDR1','2')  .and. .not.lteatt('HYDR2','0') .and.&
                lteatt('THER','NON') .and.      lteatt('MECA','NON')) then
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
                    do i = 1, nno2
                        x = x + zr(igeom+3*i-3) * zr(ivf2+ldec+i-1)
                        y = y + zr(igeom+3*i-2) * zr(ivf2+ldec+i-1)
                        z = z + zr(igeom+3*i-1) * zr(ivf2+ldec+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1, iret)
                    call fointe('FM', zk8(ifluxf+napre2), 4, nompar, valpar, flu2, iret)
                endif
                do i = 1, nno2
                    l = 2 * (i-1) -1
                    zr(ires+l+1) = zr(ires+l+1) - &
                        zr(ipoids+ipg-1) * deltat * flu1 * zr(ivf2+ldec2+i-1) * jac
                    zr(ires+l+2) = zr(ires+l+2) - &
                        zr(ipoids+ipg-1) * deltat * flu2 * zr(ivf2+ldec2+i-1) * jac
                end do
            endif
!
! --------- Temp-Hydr1
!
            if (lteatt('MECA','NON') .and. lteatt('THER','OUI') .and.&
                lteatt('HYDR1','2')  .and. lteatt('HYDR2','0')) then
!
! --- NAPRE1,NATEMP SONT MIS EN PLACE
! --- POUR UNE EVENTUELLE MODIFICATION DE L'ORDRE DES DDL :
!     PRE1, PRE2, TEMP DANS LES CATALOGUES D'ELEMENTS
!
                napre1=0
                natemp=1
!
                if (iopt .eq. 1) then
                    flu1 = zr((iflux)+(ipg-1)*2+napre1 )
                    fluth = zr((iflux)+(ipg-1)*2+natemp )
                else if (iopt.eq.2) then
                    x = 0.d0
                    y = 0.d0
                    z = 0.d0
                    do i = 1, nno2
                        x = x + zr(igeom+3*i-3) * zr(ivf2+ldec2+i-1)
                        y = y + zr(igeom+3*i-2) * zr(ivf2+ldec2+i-1)
                        z = z + zr(igeom+3*i-1) * zr(ivf2+ldec2+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1 , iret)
                    call fointe('FM', zk8(ifluxf+napre2), 4, nompar, valpar, flu2 , iret)
                    call fointe('FM', zk8(ifluxf+natemp), 4, nompar, valpar, fluth, iret)
                endif
                do i = 1, nno2
                    l = 2 * (i-1) -1
                    zr(ires+l+1) = zr(ires+l+1) -&
                        zr(ipoids+ipg-1) * deltat * flu1  * zr(ivf2+ldec2+i-1) * jac
                    zr(ires+l+2) = zr(ires+l+2) -&
                        zr(ipoids+ipg-1) * deltat * fluth * zr(ivf2+ldec2+i-1) * jac
                end do
            endif
!
! --------- Meca-Hydr1
!
            if (lteatt('MECA','OUI') .and. lteatt('THER','NON') .and.&
                lteatt('HYDR1','1')  .and. lteatt('HYDR2','0')) then
!
                napre1=0
!
                if (iopt .eq. 1) then
                    flu1 = zr((iflux)+(ipg-1)+napre1 )
                else if (iopt.eq.2) then
                    x = 0.d0
                    y = 0.d0
                    z = 0.d0
                    do i = 1, nno2
                        x = x + zr(igeom+3*i-3) * zr(ivf2+ldec2+i-1)
                        y = y + zr(igeom+3*i-2) * zr(ivf2+ldec2+i-1)
                        z = z + zr(igeom+3*i-1) * zr(ivf2+ldec2+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1, iret)
                endif
                do i = 1, nno2
                    l = 4 * (i-1) -1
                    zr(ires+l+4) = zr(ires+l+4) -&
                        zr(ipoids+ipg-1) * deltat * flu1 * zr(ivf2+ldec2+i-1) * jac
                end do
            endif
!
! --------- Meca-Hydr1-Hydr2
!
            if (     lteatt('MECA','OUI') .and. lteatt('THER','NON') .and.&
                     lteatt('HYDR1','2')  .and. .not. lteatt('HYDR2','0')) then
!
                napre1=0
                napre2=1
!
                if (iopt .eq. 1) then
!
! ---    FLU1 REPRESENTE LE FLUX ASSOCIE A PRE1
! ---    FLU2 REPRESENTE LE FLUX ASSOCIE A PRE2
!
                    flu1 = zr((iflux)+(ipg-1)*2+napre1 )
                    flu2 = zr((iflux)+(ipg-1)*2+napre2 )
!
                else if (iopt.eq.2) then
                    x = 0.d0
                    y = 0.d0
                    z = 0.d0
                    do i = 1, nno2
                        x = x + zr(igeom+3*i-3) * zr(ivf2+ldec2+i-1)
                        y = y + zr(igeom+3*i-2) * zr(ivf2+ldec2+i-1)
                        z = z + zr(igeom+3*i-1) * zr(ivf2+ldec2+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1, iret)
                    call fointe('FM', zk8(ifluxf+napre2), 4, nompar, valpar, flu2, iret)
                endif
                do i = 1, nno2
                    l = 5 * (i-1) -1
                    zr(ires+l+4) = zr(ires+l+4) -&
                        zr(ipoids+ipg-1) * deltat * flu1 * zr(ivf2+ldec2+i-1) * jac
                    zr(ires+l+5) = zr(ires+l+5) -&
                        zr(ipoids+ipg-1) * deltat * flu2 * zr(ivf2+ldec2+i-1) * jac
                end do
            endif
!
! --------- Meca-Temp-Hydr1
!
            if ( lteatt('MECA','OUI') .and. lteatt('THER','OUI') .and.&
                 lteatt('HYDR1','1')  .and. lteatt('HYDR2','0')) then
!
                napre1=0
                natemp=1
!
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
                    do i = 1, nno2
                        x = x + zr(igeom+3*i-3) * zr(ivf2+ldec2+i-1)
                        y = y + zr(igeom+3*i-2) * zr(ivf2+ldec2+i-1)
                        z = z + zr(igeom+3*i-1) * zr(ivf2+ldec2+i-1)
                    end do
                    valpar(1) = x
                    valpar(2) = y
                    valpar(3) = z
                    call fointe('FM', zk8(ifluxf+napre1), 4, nompar, valpar, flu1 , iret)
                    call fointe('FM', zk8(ifluxf+natemp), 4, nompar, valpar, fluth, iret)
                endif
                do i = 1, nno2
                    l = 5 * (i-1) -1
                    zr(ires+l+4) = zr(ires+l+4) -&
                        zr(ipoids+ipg-1) * deltat * flu1  * zr(ivf2+ldec2+i-1) * jac
                    zr(ires+l+5) = zr(ires+l+5) -&
                        zr(ipoids+ipg-1) * deltat * fluth * zr(ivf2+ldec2+i-1) * jac
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
                    pres = pres + zr(ipres+i-1)*zr(ivf+ldec+i-1)
                end do
            else if (iopt.eq.4) then
                pres = 0.d0
                do i = 1, nno
                    valpar(1) = zr(igeom+3*i-3)
                    valpar(2) = zr(igeom+3*i-2)
                    valpar(3) = zr(igeom+3*i-1)
                    call fointe('FM', zk8(ipresf), 4, nompar, valpar,&
                                presf, iret)
                    pres = pres + presf*zr(ivf+ldec+i-1)
                end do
            endif
!
            do i = 1, nnos
                l = ndlno * (i-1) -1
                zr(ires+l+1) = zr(ires+l+1) - zr(ipoids+ipg-1) * pres * zr(ivf+ldec+i-1) * nx
                zr(ires+l+2) = zr(ires+l+2) - zr(ipoids+ipg-1) * pres * zr(ivf+ldec+i-1) * ny
                zr(ires+l+3) = zr(ires+l+3) - zr(ipoids+ipg-1) * pres * zr(ivf+ldec+i-1) * nz
            end do
            do i = 1, (nno-nnos)
                l = ndlno*nnos + ndlnm*(i-1) -1
                zr(ires+l+1) = zr(ires+l+1) - zr(ipoids+ipg-1) * pres * zr(ivf+ldec+i+nnos-1) * nx
                zr(ires+l+2) = zr(ires+l+2) - zr(ipoids+ipg-1) * pres * zr(ivf+ldec+i+nnos-1) * ny
                zr(ires+l+3) = zr(ires+l+3) - zr(ipoids+ipg-1) * pres * zr(ivf+ldec+i+nnos-1) * nz
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
                fx = fx + zr(iforc-1+3*(i-1)+1)*zr(ivf+ldec+i-1)
                fy = fy + zr(iforc-1+3*(i-1)+2)*zr(ivf+ldec+i-1)
                fz = fz + zr(iforc-1+3*(i-1)+3)*zr(ivf+ldec+i-1)
            end do
            do i = 1, nno
                l = ndlno * (i-1) -1
                zr(ires+l+1) = zr(ires+l+1) + zr(ipoids+ipg-1)*fx*zr( ivf+ldec+i-1)*jac
                zr(ires+l+2) = zr(ires+l+2) + zr(ipoids+ipg-1)*fy*zr( ivf+ldec+i-1)*jac
                zr(ires+l+3) = zr(ires+l+3) + zr(ipoids+ipg-1)*fz*zr( ivf+ldec+i-1)*jac
            end do
            do i = 1, nno
                l = ndlno*nnos+ndlnm * (i-1) -1
                zr(ires+l+1) = zr(ires+l+1) + zr(ipoids+ipg-1)*fx*zr( ivf+ldec+i+nnos-1)*jac
                zr(ires+l+2) = zr(ires+l+2) + zr(ipoids+ipg-1)*fy*zr( ivf+ldec+i+nnos-1)*jac
                zr(ires+l+3) = zr(ires+l+3) + zr(ipoids+ipg-1)*fz*zr( ivf+ldec+i+nnos-1)*jac
            end do
        endif
99      continue
    end do
!
end subroutine
