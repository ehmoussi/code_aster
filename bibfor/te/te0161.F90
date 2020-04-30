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
subroutine te0161(option, nomte)
!
! --------------------------------------------------------------------------------------------------
!
!                          CALCUL FORCES REPARTIES
!
! nomte :
!           MECABL2
!           MECA_POU_D_T_GD
! option :
!           CHAR_MECA_PESA_R
!           CHAR_MECA_FR1D1D
!           CHAR_MECA_FF1D1D
!           CHAR_MECA_SR1D1D
!           CHAR_MECA_SF1D1D'
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
    character(len=16), intent(in) :: option, nomte
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
!
! --------------------------------------------------------------------------------------------------
!
    integer :: icodre(1), jj
    integer :: nno, kp, i, ivectu, ipesa, nddl, npg, iyty, nordre, lsect
    integer :: ipoids, ivf, igeom, imate, iforc
    integer :: itemps, nbpar, idepla, ideplp, k, l, ic, neu, iret, neum1
    aster_logical :: normal
    real(kind=8) :: r8min, r8bid, rho(1), a, coef
    real(kind=8) :: xss, xs2, xs4, c1, force(3), xuu(3), xvv(3), w2(3)
!
    integer :: ifcx, idfdk, jgano, ndim, nnos
    character(len=8), parameter :: nompav(1) = ['VITE']
    real(kind=8)                :: valpav(1), viterela(3)
!
    integer             :: ichamp
    aster_logical       :: okvent, fozero
    character(len=8)    :: nompar(13)
    real(kind=8)        :: valpar(13), fcx, vite2, xvp(3)
    real(kind=8)        :: xx(3), xv(3), xa(3), wx(6), wv(6), wa(6), temps
! --------------------------------------------------------------------------------------------------
    r8min = r8miem()
    r8bid=0.0; c1= 1.0
    nompar(1:3)   = ['X','Y','Z']
    nompar(4:6)   = ['DX','DY','DZ']
    nompar(7:9)   = ['VITE_X','VITE_Y','VITE_Z']
    nompar(10:12) = ['ACCE_X','ACCE_Y','ACCE_Z']
    nompar(13)    = 'INST'
!
    if (nomte.eq.'MECA_POU_D_T_GD') then
        nddl = 6
    else
        nddl = 3
    endif
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfdk, jgano=jgano)
    call jevete('&INEL.CABPOU.YTY', 'L', iyty)
!
    nordre = 3*nno
!   Par défaut pas de vent, effort dans le repère global
    normal = .false.; okvent = .false.
    temps  = 0.0; nbpar = 12
! --------------------------------------------------------------------------------------------------
    wx(:) = 0.0; wv(:) = 0.0; wa(:) = 0.0; w2(:) = 0.0; viterela(:) = 0.0
! --------------------------------------------------------------------------------------------------
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVECTUR', 'E', ivectu)
! --------------------------------------------------------------------------------------------------
    if (option.eq.'CHAR_MECA_PESA_R') then
        call jevech('PMATERC', 'L', imate)
        call jevech('PPESANR', 'L', ipesa)
        call rcvalb('FPG1', 1, 1, '+', zi(imate), ' ', 'ELAS', 0, ' ', [r8bid],&
                    1, 'RHO', rho, icodre, 1)
        if (nomte .eq. 'MECA_POU_D_T_GD') then
            call poutre_modloc('CAGNPO', ['A1'], 1, valeur=a)
        else
            call jevech('PCACABL', 'L', lsect)
            a = zr(lsect)
        endif
        c1 = a*rho(1)*zr(ipesa)
        force(1) = zr(ipesa+1)
        force(2) = zr(ipesa+2)
        force(3) = zr(ipesa+3)
! --------------------------------------------------------------------------------------------------
!   Forces Fixes réparties par valeurs réelles
    else if (option.eq.'CHAR_MECA_FR1D1D') then
        call jevech('PFR1D1D', 'L', iforc)
        normal = abs(zr(iforc+6)) .gt. 1.001
!       Pas de moment repartis
        r8bid = sqrt(ddot(3,zr(iforc+3),1,zr(iforc+3),1))
        if (r8bid .gt. r8min) then
            call utmess('F', 'ELEMENTS3_1', sk=nomte)
        endif
        force(1) = zr(iforc)
        force(2) = zr(iforc+1)
        force(3) = zr(iforc+2)
        if (normal) call ForceNormale(w2,force)
! --------------------------------------------------------------------------------------------------
!   Forces Suiveuses réparties par valeurs réelles
    else if (option.eq.'CHAR_MECA_SR1D1D') then
!       Pour le cas du vent
        call tecach('NNO', 'PVITER', 'L', iret, iad=iforc)
        if (iret .eq. 0) then
            normal = .true.
            okvent = .true.
            ! Récupération de la fonction d'effort en fonction de la vitesse
            call tecach('ONO', 'PVENTCX', 'L', iret, iad=ifcx)
            if (iret .ne. 0) then
                call utmess('F', 'ELEMENTS3_39')
            endif
            if (zk8(ifcx)(1:1) .eq. '.') then
                call utmess('F', 'ELEMENTS3_39')
            endif
!           Récupération de la vitesse de vent relative au noeud
            viterela(1) = zr(iforc)
            viterela(2) = zr(iforc+1)
            viterela(3) = zr(iforc+2)
        endif
! --------------------------------------------------------------------------------------------------
!   Forces Fixes et Suiveuses réparties par Fonctions
    else if ((option.eq.'CHAR_MECA_FF1D1D').or.(option.eq.'CHAR_MECA_SF1D1D')) then
        call jevech('PFF1D1D', 'L', iforc)
!       Pas de moment répartis
        fozero = (zk8(iforc+3).ne.'&FOZERO').or.(zk8(iforc+4).ne.'&FOZERO').or.&
                 (zk8(iforc+5).ne.'&FOZERO')
        if (fozero) then
            call utmess('F', 'ELEMENTS3_1', sk=nomte)
        endif
        normal = zk8(iforc+6) .eq. 'VENT'
        call tecach('NNO', 'PTEMPSR', 'L', iret, iad=itemps)
        if (iret .eq. 0) then
            temps = zr(itemps)
            nbpar = 13
        endif
    endif
!
! --------------------------------------------------------------------------------------------------
!   Forces Suiveuses : Actualisations des déplacements, vitesses, accélérations
    if ((option.eq.'CHAR_MECA_SR1D1D').or.(option.eq.'CHAR_MECA_SF1D1D')) then
        call jevech('PDEPLMR', 'L', idepla)
        call jevech('PDEPLPR', 'L', ideplp)
!       wx(1 2 3 4 5 6)  => position
!       w2(1 2 3)        => vecteur directeur
        do i = 1, 3
            wx(i)   = zr(igeom+i-1) + zr(idepla-1+i)      + zr(ideplp-1+i)
            wx(i+3) = zr(igeom+i+2) + zr(idepla-1+i+nddl) + zr(ideplp-1+i+nddl)
            w2(i)   = wx(i+3) - wx(i)
        enddo
!       wv(1 2 3 4 5 6) => Vitesses
        call tecach('NNO', 'PVITPLU', 'L', iret, iad=ichamp)
        if ( iret.eq.0 ) then
            do i = 1, 3
                wv(i)   = zr(ichamp+i-1)
                wv(i+3) = zr(ichamp+i+3-1)
            enddo
        endif
!       wa(1 2 3 4 5 6) => Accélérations
        call tecach('NNN', 'PACCPLU', 'L', iret, iad=ichamp)
        if ( iret.eq.0 ) then
            do i = 1, 3
                wa(i)   = zr(ichamp+i-1)
                wa(i+3) = zr(ichamp+i+3-1)
            enddo
        endif
    else
        do i = 1, 3
            wx(i)   = zr(igeom+i-1)
            wx(i+3) = zr(igeom+i+2)
            w2(i)   = wx(i+3) - wx(i)
        enddo
    endif
!
! --------------------------------------------------------------------------------------------------
    do kp = 1, npg
        k = (kp-1)*nordre*nordre
        l = (kp-1)*nno
!       Forces Fixes et Suiveuses réparties par Fonctions
        if ((option.eq.'CHAR_MECA_FF1D1D').or.(option.eq.'CHAR_MECA_SF1D1D')) then
            xx(:) = 0.0d0; xv(:) = 0.0d0; xa(:) = 0.0d0
!           xx(1 2 3) => position des points de gauss
            do ic = 1, 3
                do neu = 1, nno
                    xx(ic) = xx(ic) + wx(3*neu+ic-3)*zr(ivf+l+neu-1)
                enddo
            enddo
!           xv(1 2 3) => Vitesses aux points de gauss
            do ic = 1, 3
                do neu = 1, nno
                    xv(ic) = xv(ic) + wv(3*neu+ic-3)*zr(ivf+l+neu-1)
                enddo
            enddo
!           xa(1 2 3) => Accélérations aux points de gauss
            do ic = 1, 3
                do neu = 1, nno
                    xa(ic) = xa(ic) + wa(3*neu+ic-3)*zr(ivf+l+neu-1)
                enddo
            enddo
!
            valpar(1:3) = xx(1:3); valpar(4:6)   = w2(1:3)
            valpar(7:9) = xv(1:3); valpar(10:12) = xa(1:3)
            valpar(13) = temps
!
            do ic = 1, 3
                call fointe('FM', zk8(iforc+ic-1), nbpar, nompar, valpar, force(ic), iret)
            enddo
            if (normal) call ForceNormale(w2,force)
        endif
        if (okvent) then
            fcx = 0.0; xvp(:) = 0.0
!           Calcul du vecteur vitesse perpendiculaire
            xss=ddot(3,viterela,1,viterela,1)
            xs4 = sqrt(xss)
            if (xs4 .gt. r8min) then
                xss=ddot(3,w2,1,w2,1)
                xs2 = 1.0/xss
                call provec(w2, viterela, xuu)
                call provec(xuu, w2, xvv)
                call pscvec(3, xs2, xvv, xvp)
!               Norme de la vitesse perpendiculaire
                vite2 = ddot(3,xvp,1,xvp,1)
                valpav(1) = sqrt(vite2)
                if (valpav(1) .gt. r8min) then
                    call fointe('FM', zk8(ifcx), 1, nompav(1), valpav, fcx, iret)
                    fcx = fcx / valpav(1)
                endif
            endif
            call pscvec(3, fcx, xvp, force)
        endif
!
        coef = zr(ipoids-1+kp)*c1*sqrt(biline(nordre,zr(igeom), zr(iyty+k),zr(igeom)))
        do neu = 1, nno
            neum1 = neu - 1
            do ic = 1, 3
                jj = ivectu+nddl*neum1+(ic-1)
                zr(jj) = zr(jj) + coef*force(ic)*zr(ivf+l+neum1)
            enddo
        enddo
    enddo
!
! ==================================================================================================
!
contains
!
subroutine ForceNormale(w2,force)
!
#include "asterfort/provec.h"
#include "asterfort/pscvec.h"
#include "blas/ddot.h"
#include "asterc/r8miem.h"
!
    real(kind=8), intent(in)    :: w2(3)
    real(kind=8), intent(inout) :: force(3)
!
    real(kind=8) :: xuu(3), xvv(3), xsu(3)
    real(kind=8) :: xss, xs2, xs3, xs4, xs5, r8min
!
    r8min = r8miem()
    xss   = ddot(3,force,1,force,1)
    xs4 = sqrt(xss)
    if (xs4.gt.r8min) then
        xss = ddot(3,w2,1,w2,1)
        xs2 = 1.0/xss
        call provec(w2, force, xuu)
        call provec(xuu, w2, xvv)
        call pscvec(3, xs2, xvv, xsu)
        xss = ddot(3,xuu,1,xuu,1)
        xs3 = sqrt(xss)
        xs5 = xs3*sqrt(xs2)/xs4
        call pscvec(3, xs5, xsu, force)
    endif
end subroutine ForceNormale

end subroutine te0161
