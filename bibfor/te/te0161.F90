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
!
subroutine te0161(option, nomte)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8miem.h"
#include "asterfort/biline.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/jevete.h"
#include "asterfort/poutre_modloc.h"
#include "asterfort/provec.h"
#include "asterfort/pscvec.h"
#include "asterfort/rcvalb.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "blas/ddot.h"
character(len=16), intent(in) :: option, nomte
! --- ------------------------------------------------------------------
!                          CALCUL FORCES REPARTIES
!     NOMTE :
!        MECABL2
!        MECA_POU_D_T_GD
!    OPTION :
!        CHAR_MECA_FR1D1D
!        CHAR_MECA_FF1D1D
!        CHAR_MECA_SR1D1D
!        CHAR_MECA_SF1D1D'
!
! --- ------------------------------------------------------------------
    integer :: icodre(1), jj
    integer :: nno, kp, i, ivectu, ipesa, nddl, npg, iyty, nordre, lsect
    integer :: ipoids, ivf, igeom, imate, iforc
    integer :: itemps, nbpar, idepla, ideplp, k, l, ic, neu, iret, neum1
    aster_logical :: normal
    real(kind=8) :: r8min, r8bid=0.d0, rho(1), a, coef
    real(kind=8) :: s, s2, s3, s4, s5, x(4), c1, c2(3), w(6), u(3), v(3), w2(3)
!
    integer :: ifcx, idfdk, jgano, ndim, nnos
    character(len=8) :: nompar(10), nompav(1)
    real(kind=8) :: valpav(1), fcx, vite2, vp(3)
    aster_logical :: okvent, fozero
    real(kind=8) :: valpar(10), xv(3) ,wv(6)
    integer      :: ivite

! --- ------------------------------------------------------------------
    data nompar/'X','Y','Z','DX','DY','DZ',&
     &                  'VITE_X','VITE_Y','VITE_Z','INST'/
    data nompav/'VITE'/
! --- ------------------------------------------------------------------
    r8min = r8miem()
!
    if (nomte .eq. 'MECA_POU_D_T_GD') then
        nddl = 6
    else
        nddl = 3
    endif
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfdk, jgano=jgano)
    call jevete('&INEL.CABPOU.YTY', 'L', iyty)
!
    nordre = 3*nno
! --- ------------------------------------------------------------------
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVECTUR', 'E', ivectu)
! --- ------------------------------------------------------------------
    if (option .eq. 'CHAR_MECA_PESA_R') then
        call jevech('PMATERC', 'L', imate)
        call jevech('PPESANR', 'L', ipesa)
        call rcvalb('FPG1', 1, 1, '+', zi(imate),&
                    ' ', 'ELAS', 0, ' ', [r8bid],&
                    1, 'RHO', rho, icodre, 1)
        if (nomte .eq. 'MECA_POU_D_T_GD') then
            call poutre_modloc('CAGNPO', ['A1'], 1, valeur=a)
        else
            call jevech('PCACABL', 'L', lsect)
            a = zr(lsect)
        endif
        c1 = a*rho(1)*zr(ipesa)
        c2(1) = zr(ipesa+1)
        c2(2) = zr(ipesa+2)
        c2(3) = zr(ipesa+3)
    endif
!     PAR DEFAUT PAS DE VENT,  EFFORT DANS LE REPERE GLOBAL
    normal = .false.
    okvent = .false.
! --- ------------------------------------------------------------------
    if (option .eq. 'CHAR_MECA_FR1D1D' .or. option .eq. 'CHAR_MECA_SR1D1D') then
        c1 = 1.0d0
!        POUR LE CAS DU VENT
        call tecach('NNO', 'PVITER', 'L', iret, iad=iforc)
        if (iret .eq. 0) then
            normal = .true.
            okvent = .true.
        else
            call jevech('PFR1D1D', 'L', iforc)
            normal = abs(zr(iforc+6)) .gt. 1.001d0
        endif
    endif
!
! --- ------------------------------------------------------------------
    if (option .eq. 'CHAR_MECA_FF1D1D' .or. option .eq. 'CHAR_MECA_SF1D1D') then
        c1 = 1.0d0
        call jevech('PFF1D1D', 'L', iforc)
        normal = zk8(iforc+6) .eq. 'VENT'
        call tecach('NNO', 'PTEMPSR', 'L', iret, iad=itemps)
        if (iret .eq. 0) then
            x(4) = zr(itemps)
            nbpar = 10
        else
            nbpar = 9
        endif
    endif
!
! --- ------------------------------------------------------------------
    if (option .eq. 'CHAR_MECA_SR1D1D' .or. option .eq. 'CHAR_MECA_SF1D1D') then
        call jevech('PDEPLMR', 'L', idepla)
        call jevech('PDEPLPR', 'L', ideplp)
!CCP         w(1 2 3 4 5 6) => position  
        do i = 1, 3
            w(i) = zr(igeom+i-1) + zr(idepla-1+i) + zr(ideplp-1+i)
            w(i+3) = zr(igeom+i+2) + zr(idepla-1+i+nddl) + zr(ideplp- 1+i+nddl)
            w2(i) = w(i+3) - w(i)
        enddo
!CCP       wv (1 2 3 4 5 6) => Vitesses 
         call tecach('NNO', 'PVITPLU', 'L', iret, iad=ivite)
         do i = 1, 3
             wv(i)   = zr(ivite+i-1)
             wv(i+3) = zr(ivite+i+3-1)
         enddo
    else
        do i = 1, 3
            w(i) = zr(igeom+i-1)
            w(i+3) = zr(igeom+i+2)
            w2(i) = w(i+3) - w(i)
        enddo
    endif
!
! --- ------------------------------------------------------------------
! --- FORCES REPARTIES PAR VALEURS REELLES
    if (option .eq. 'CHAR_MECA_FR1D1D') then
!        PAS DE MOMENT REPARTIS
        r8bid = sqrt(ddot(3,zr(iforc+3),1,zr(iforc+3),1))
        if (r8bid .gt. r8min) then
            call utmess('F', 'ELEMENTS3_1', sk=nomte)
        endif
!
        c2(1) = zr(iforc)
        c2(2) = zr(iforc+1)
        c2(3) = zr(iforc+2)
        if (normal) then
            s=ddot(3,c2,1,c2,1)
            s4 = sqrt(s)
            if (s4 .gt. r8min) then
                s=ddot(3,w2,1,w2,1)
                s2 = 1.d0/s
                call provec(w2, c2, u)
                s=ddot(3,u,1,u,1)
                s3 = sqrt(s)
                s5 = s3*sqrt(s2)/s4
                call provec(u, w2, v)
                call pscvec(3, s2, v, u)
                call pscvec(3, s5, u, c2)
            endif
        endif
    endif
!
! --- ------------------------------------------------------------------
    do kp = 1, npg
        k = (kp-1)*nordre*nordre
        l = (kp-1)*nno
        if (option .eq. 'CHAR_MECA_FF1D1D' .or. option .eq. 'CHAR_MECA_SF1D1D') then
!           PAS DE MOMENT REPARTIS
            fozero = (zk8(iforc+3).ne.'&FOZERO') .or. (zk8(iforc+4) .ne.'&FOZERO') .or.&
                     (zk8(iforc+5).ne.'&FOZERO')
            if (fozero) then
                call utmess('F', 'ELEMENTS3_1', sk=nomte)
            endif
!
!CCP       x(1 2 3) => position 
            do ic = 1, 3
                x(ic) = 0.d0
                do neu = 1, nno
                    x(ic) = x(ic) + w(3*neu+ic-3)*zr(ivf+l+neu-1)
                enddo
            enddo

!CCP       xv (1 2 3) => Vitesses 
            do ic = 1, 3
               xv(ic) = 0.d0
               do neu = 1, nno
                  xv(ic) = xv(ic) + wv(3*neu+ic-3)*zr(ivf+l+neu-1)
               enddo
            enddo 

! ici : x designe la position du point de gauss, w2 le vecteur directeur de l element cable
!CCP    PG i
            valpar(1)  = x(1)
            valpar(2)  = x(2)
            valpar(3)  = x(3)
            valpar(4)  = w2(1)
            valpar(5)  = w2(2)
            valpar(6)  = w2(3)
            valpar(7)  = xv(1)
            valpar(8)  = xv(2)
            valpar(9)  = xv(3) 
            valpar(10) = x(4)    

            do ic = 1, 3
                call fointe('FM', zk8(iforc+ic-1), nbpar, nompar, valpar,&
                            c2( ic), iret)
            enddo
            if (normal) then
                s=ddot(3,c2,1,c2,1)
                s4 = sqrt(s)
                if (s4 .gt. r8min) then
                    s=ddot(3,w2,1,w2,1)
                    s2 = 1.d0/s
                    call provec(w2, c2, u)
                    s=ddot(3,u,1,u,1)
                    s3 = sqrt(s)
                    s5 = s3*sqrt(s2)/s4
                    call provec(u, w2, v)
                    call pscvec(3, s2, v, u)
                    call pscvec(3, s5, u, c2)
                endif
            endif
        endif
        if (okvent) then
!           RECUPERATION DE LA VITESSE DE VENT RELATIVE AU NOEUD
            c2(1) = zr(iforc)
            c2(2) = zr(iforc+1)
            c2(3) = zr(iforc+2)
!           CALCUL DU VECTEUR VITESSE PERPENDICULAIRE
            s=ddot(3,c2,1,c2,1)
            s4 = sqrt(s)
            fcx = 0.0d0
            if (s4 .gt. r8min) then
                s=ddot(3,w2,1,w2,1)
                s2 = 1.d0/s
                call provec(w2, c2, u)
                call provec(u, w2, v)
                call pscvec(3, s2, v, vp)
!              NORME DE LA VITESSE PERPENDICULAIRE
                vite2=ddot(3,vp,1,vp,1)
                valpav(1) = sqrt(vite2)
                if (valpav(1) .gt. r8min) then
!                 RECUPERATION DE L'EFFORT EN FONCTION DE LA VITESSE
                    call tecach('ONO', 'PVENTCX', 'L', iret, iad=ifcx)
                    if (iret .ne. 0) then
                        call utmess('F', 'ELEMENTS3_39')
                    endif
                    if (zk8(ifcx)(1:1) .eq. '.') then
                        call utmess('F', 'ELEMENTS3_39')
                    endif
                    call fointe('FM', zk8(ifcx), 1, nompav, valpav,&
                                fcx, iret)
                    fcx = fcx/valpav(1)
                endif
            endif
            call pscvec(3, fcx, vp, c2)
        endif
!
        coef = zr(ipoids-1+kp)*c1*sqrt(biline(nordre,zr(igeom), zr(iyty+k),zr(igeom)))
        do neu = 1, nno
            neum1 = neu - 1
            do ic = 1, 3
                jj = ivectu+nddl*neum1+(ic-1)
                zr(jj) = zr(jj) + coef*c2(ic)*zr(ivf+l+neum1)
            enddo
        enddo
    end do
end subroutine
