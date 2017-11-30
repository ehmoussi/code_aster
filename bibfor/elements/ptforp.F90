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

subroutine ptforp(itype, option, nomte, a, a2, xl, ist, nno, nc, pgl, fer, fei)
!
!
!
! --------------------------------------------------------------------------------------------------
!
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
!
    integer :: itype, ist, nno, nc
    real(kind=8) :: a, a2, xl
    real(kind=8) :: pgl(3, 3), fer(*), fei(*)
    character(len=*) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8miem.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/normev.h"
#include "asterfort/pmfitx.h"
#include "asterfort/porea2.h"
#include "asterfort/provec.h"
#include "asterfort/pscvec.h"
#include "asterfort/ptfop1.h"
#include "asterfort/rcvala.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/utpvgl.h"
#include "blas/ddot.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: icodre(1)
    integer :: ifcx, i, j, nnoc, ncc, lx, iorien, idepla, ideplp, lmate, lpesa
    integer :: lforc, itemps, nbpar, ier, iret, icoer, icoec, iretr, iretc, ivite
    integer :: lrota, istrxm, k
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: global, normal, okvent
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: rho(1), coef1, coef2, s, s2, s4, s3, s5
    real(kind=8) :: xxx, r8min, r8bid, pesan
    real(kind=8) :: u(3), v(3), w(8), w2(3), dw(12)
    real(kind=8) :: q(18), qq(18), qqr(18), qqi(18), pta(3), dir(3)
    real(kind=8) :: dir1(3), dir2(3), d1, d2, omeg2, x1(3), x2(3), v1(3), v2(3)
    real(kind=8) :: valpav(1), fcx, vite2, vp(3), casect(6), gamma
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: nompav(1)
    character(len=8) :: nompar(10)
    character(len=16) :: ch16, messk(2)
    real(kind=8) :: valpar(10)
!
! --------------------------------------------------------------------------------------------------
!
    data nompar /'X','Y','Z','DX','DY','DZ',&
     &                  'VITE_X','VITE_Y','VITE_Z','INST'/
    data nompav /'VITE'/
!
! --------------------------------------------------------------------------------------------------
!
    r8min = r8miem()
!
    fer(1:12) = 0.0d0
    fei(1:12) = 0.0d0
!
    q(:)  = 0.0d0
    qq(:) = 0.0d0
    vp(:) = 0.0d0
!
    nnoc = 1
    ncc  = 6
    global = .false.
!
! --------------------------------------------------------------------------------------------------
    call jevech('PGEOMER', 'L', lx)
    lx = lx-1
    call jevech('PCAORIE', 'L', iorien)
!
    if (option.eq.'CHAR_MECA_SR1D1D' .or. option.eq.'CHAR_MECA_SF1D1D') then
        call jevech('PDEPLMR', 'L', idepla)
        call jevech('PDEPLPR', 'L', ideplp)
!
        call tecach('NNO', 'PVITPLU', 'L', iret, iad=ivite)
        call tecach('NNO', 'PSTRXMR', 'L', iret, iad=istrxm)
        if (iret .ne. 0) then
            messk(1) = option
            messk(2) = nomte
            call utmess('F', 'ELEMENTS2_2', nk=2, valk = messk)
        endif
        if (nomte.eq.'MECA_POU_D_EM' .or. nomte.eq.'MECA_POU_D_TGM') then
            gamma = zr(istrxm+18-1)
        else
            gamma = zr(istrxm+3-1)
        endif
        call porea2(nno, nc, zr(lx+1), gamma, pgl, xl)
        do i = 1, 12
            dw(i) = zr(idepla-1+i) + zr(ideplp-1+i)
        enddo
        do i = 1, 3
            w(i) = zr(lx+i) + dw(i)
            w(i+4) = zr(lx+i+3) + dw(i+6)
            w2(i) = w(i+4) - w(i)
        enddo
    else
        do i = 1, 3
            w(i) = zr(lx+i)
            w(i+4) = zr(lx+i+3)
            w2(i) = w(i+4) - w(i)
        enddo
    endif
!
    if (option.eq.'CHAR_MECA_PESA_R' .or. option.eq.'CHAR_MECA_ROTA_R') then
        pesan=0.0d0; omeg2=0.0d0
        if (option.eq.'CHAR_MECA_PESA_R') then
            call jevech('PPESANR', 'L', lpesa)
            pesan=zr(lpesa-1+1)
!           dir est normé
            dir(1)=zr(lpesa-1+2)
            dir(2)=zr(lpesa-1+3)
            dir(3)=zr(lpesa-1+4)
        else if (option.eq.'CHAR_MECA_ROTA_R') then
            call jevech('PROTATR', 'L', lrota)
            omeg2=zr(lrota-1+1)**2
            do k = 1, 3
                dir(k)=zr(lrota-1+1+k)
                pta(k)=zr(lrota-1+4+k)
                x1(k)=zr(lx+k) - pta(k)
                x2(k)=zr(lx+3+k) - pta(k)
            enddo
            call provec(dir, x1, v1)
            call provec(dir, x2, v2)
            call normev(v1, d1)
            call normev(v2, d2)
            call provec(v1, dir, dir1)
            call provec(v2, dir, dir2)
        endif
!
        call jevech('PMATERC', 'L', lmate)
        if (nomte.eq.'MECA_POU_D_EM' .or. nomte.eq.'MECA_POU_D_TGM'.or. &
            nomte.eq.'MECA_POU_D_SQUE') then
            if (ist.eq.1) then
                call pmfitx(zi(lmate), 2, casect, r8bid)
            else
                call pmfitx(zi(lmate), 3, casect, r8bid)
            endif
            rho(1)=casect(1)
            coef1 = 1.d0
            coef2 = 1.d0
        else
            if (ist.eq.1) then
                call rcvala(zi(lmate),' ','ELAS',0,' ',[r8bid],1,'RHO',rho(1),icodre,1)
            else
                call rcvala(zi(lmate),' ','ELAS',0,' ',[r8bid],1,'RHO',rho(1),icodre,0)
                if (icodre(1) .ne. 0) rho(1) = 0.0d0
            endif
!           a cause des chargements variable
            coef1 = a
            coef2 = a2
        endif
        do i = 1, 3
            if (option.eq.'CHAR_MECA_PESA_R') then
                q(i)   = rho(1) * pesan * dir(i)
                q(i+nc) = rho(1) * pesan * dir(i)
            else if (option.eq.'CHAR_MECA_ROTA_R') then
                q(i)   = rho(1) * omeg2 * d1 * dir1(i)
                q(i+6) = rho(1) * omeg2 * d2 * dir2(i)
            endif
        enddo
!
!       Charge de pesanteuren repere global : passage repere local du vecteur force
        call utpvgl(nno, nc, pgl, q(1), qq(1))
        global = .true.
        goto 777
    endif
!
    okvent = .false.
    normal = .false.
    global = .false.
    if (option.eq.'CHAR_MECA_FR1D1D' .or. option.eq.'CHAR_MECA_SR1D1D') then
!       forces reparties par valeurs reelles pour le cas du vent
        call tecach('NNO', 'PVITER', 'L', iret, iad=lforc)
        if (iret.eq.0) then
            okvent = .true.
            normal = .false.
            global = .false.
            do i = 1, 3
                q(i)   = zr(lforc-1+i)
                q(i+6) = zr(lforc+2+i)
            enddo
        else
            call jevech('PFR1D1D', 'L', lforc)
            xxx = abs(zr(lforc+6))
            global = xxx .lt. 1.d-3
            normal = xxx .gt. 1.001d0
            do i = 1, 6
                q(i)   = zr(lforc-1+i)
                q(i+nc) = q(i)
            enddo
            do i = 7, nc
                q(i)   = zr(lforc+i)
                q(i+nc) = q(i)
            enddo        
        endif
!
    else if ( (option.eq.'CHAR_MECA_FF1D1D') .or. (option.eq.'CHAR_MECA_SF1D1D') ) then
!       forces reparties par fonctions
        call tecach('NNO', 'PTEMPSR', 'L', iret, iad=itemps)
        if (iret.eq.0) then
            w(4) = zr(itemps)
            w(8) = zr(itemps)
            nbpar = 10
        else
            nbpar = 9
        endif
        call jevech('PFF1D1D', 'L', lforc)
        normal = zk8(lforc+6).eq.'VENT'
        global = zk8(lforc+6).eq.'GLOBAL'
!CCP    Deplacements
        call tecach('NNO', 'PDEPLPR', 'L', iret, iad=ideplp)
        if (iret .eq. 2) then
            call jevech('PDEPLAR', 'L', ideplp)
        endif

!CCP    Vitesses
        call tecach('NNO', 'PVITPLU', 'L', iret, iad=ivite)
! Noeud 1
        valpar(1)  = w(1)
        valpar(2)  = w(2)
        valpar(3)  = w(3)
        valpar(4)  = w2(1)
        valpar(5)  = w2(2)
        valpar(6)  = w2(3)
        valpar(7)  = zr(ivite-1+1)
        valpar(8)  = zr(ivite-1+2)
        valpar(9)  = zr(ivite-1+3) 
        valpar(10) = w(4)  
        do i = 1, 6
            call fointe('FM', zk8(lforc+i-1), nbpar, nompar, valpar,&
                        q(i), ier)
        enddo
        do i = 7, nc
            call fointe('FM', zk8(lforc+i), nbpar, nompar, valpar,&
                        q(i), ier)
        enddo
! Noeud 2
        valpar(1)  = w(5)
        valpar(2)  = w(6)
        valpar(3)  = w(7)
        valpar(4)  = w2(1)
        valpar(5)  = w2(2)
        valpar(6)  = w2(3)
        valpar(7)  = zr(ivite-1+7)
        valpar(8)  = zr(ivite-1+8)
        valpar(9)  = zr(ivite-1+9)
        valpar(10) = w(8)     
        do i = 1, 6
            j = i + nc
            call fointe('FM', zk8(lforc+i-1), nbpar, nompar, valpar,&
                        q(j), ier)
        enddo
        do i = 7, nc
            j = i + nc
            call fointe('FM', zk8(lforc+i), nbpar, nompar, valpar,&
                        q(j), ier)
        enddo
    else
        ch16 = option
        call utmess('F', 'ELEMENTS2_47', sk=ch16)
    endif
!
!   controle de validite de forces variant lineairement
    if (itype .ne. 0) then
        do i = 1, nc
            if (qq(i) .ne. qq(i+nc)) then
                call utmess('F', 'ELEMENTS2_50')
            endif
        enddo
    endif
!
    if (okvent) then
        s=ddot(3,w2,1,w2,1)
        s2=1.d0/s
!       calcul de la norme du vecteur a projetter
        s=ddot(3,q(1),1,q(1),1)
        s4 = sqrt(s)
!       calcul du vecteur vitesse perpendiculaire
        fcx = 0.0d0
        if (s4 .gt. r8min) then
            call provec(w2, q(1), u)
            call provec(u, w2, v)
            call pscvec(3, s2, v, vp)
!           norme de la vitesse perpendiculaire
            vite2=ddot(3,vp,1,vp,1)
            valpav(1) = sqrt( vite2 )
            if (valpav(1) .gt. r8min) then
!               recuperation de l'effort en fonction de la vitesse
                call tecach('ONO', 'PVENTCX', 'L', iret, iad=ifcx)
                if (iret .ne. 0) then
                    call utmess('F', 'ELEMENTS2_53')
                endif
                if (zk8(ifcx)(1:1).eq.'.') then
                    call utmess('F', 'ELEMENTS2_53')
                endif
                call fointe('FM', zk8(ifcx), 1, nompav, valpav, fcx, iret)
                fcx = fcx / valpav(1)
            endif
        endif
        call pscvec(3, fcx, vp, q(1))
!
!       calcul de la norme du vecteur a projetter
        s=ddot(3,q(7),1,q(7),1)
        s4 = sqrt(s)
!       calcul du vecteur vitesse perpendiculaire
        fcx = 0.0d0
        if (s4 .gt. r8min) then
            call provec(w2, q(7), u)
            call provec(u, w2, v)
            call pscvec(3, s2, v, vp)
!           norme de la vitesse perpendiculaire
            vite2=ddot(3,vp,1,vp,1)
            valpav(1) = sqrt( vite2 )
            if (valpav(1) .gt. r8min) then
!               recuperation de l'effort en fonction de la vitesse
                call tecach('ONO', 'PVENTCX', 'L', iret, iad=ifcx)
                if (iret .ne. 0) then
                    call utmess('F', 'ELEMENTS2_53')
                endif
                if (zk8(ifcx)(1:1).eq.'.') then
                    call utmess('F', 'ELEMENTS2_53')
                endif
                call fointe('FM', zk8(ifcx), 1, nompav, valpav, fcx, iret)
                fcx = fcx / valpav(1)
            endif
        endif
        call pscvec(3, fcx, vp, q(7))
!
    else if (normal) then
        s=ddot(3,w2,1,w2,1)
        s2=1.d0/s
        s=ddot(3,q(1),1,q(1),1)
        s4 = sqrt(s)
        if (s4 .gt. r8min) then
            call provec(w2, q(1), u)
            s=ddot(3,u,1,u,1)
            s3 = sqrt(s)
            s5 = s3*sqrt(s2)/s4
            call provec(u, w2, v)
            call pscvec(3, s2, v, u)
            call pscvec(3, s5, u, q(1))
        endif
!
        s=ddot(3,q(7),1,q(7),1)
        s4 = sqrt(s)
        if (s4 .gt. r8min) then
            call provec(w2, q(7), u)
            s=ddot(3,u,1,u,1)
            s3 = sqrt(s)
            s5 = s3*sqrt(s2)/s4
            call provec(u, w2, v)
            call pscvec(3, s2, v, u)
            call pscvec(3, s5, u, q(7))
        endif
    endif
!   Passage repère local du vecteur force
    if (global .or. normal .or. okvent) then
        call utpvgl(nno, nc, pgl, q(1), qq(1))
    else
        qq(1:2*nc) = q(1:2*nc)
    endif
!   a cause des chargements variables
    coef1 = 1.0d0
    coef2 = 1.0d0
!
777 continue
!
!   Récuperation du coef_mult
    call tecach('NNO', 'PCOEFFR', 'L', iretr, iad=icoer)
    call tecach('NNO', 'PCOEFFC', 'L', iretc, iad=icoec)
!
    if (iretr.eq.0) then
        do i = 1, 2*nc
            qq(i) = qq(i) * zr(icoer)
        enddo
        call ptfop1(itype, nc, coef1, coef2, xl, qq, fer)
!
    else if (iretc.eq.0) then
        do i = 1, 2*nc
            qqr(i) = qq(i) * dble( zc(icoec) )
            qqi(i) = qq(i) * dimag( zc(icoec) )
        enddo
        call ptfop1(itype, nc, coef1, coef2, xl, qqr, fer)
        call ptfop1(itype, nc, coef1, coef2, xl, qqi, fei)
!
    else
        call ptfop1(itype, nc, coef1, coef2, xl, qq, fer)
    endif
!
end subroutine
