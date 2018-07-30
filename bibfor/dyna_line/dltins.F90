! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine dltins(nbgrpa, lispas, libint, linbpa, npatot,&
                  tinit, lisins)
!
implicit none
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=24) :: lispas, libint, linbpa, lisins
!
! --------------------------------------------------------------------------------------------------
!
! OUT : NBGRPA : NOMBRE DE GROUPE DE PAS
! OUT : LISPAS : OBJET DU ZR DES PAS DE CALCUL
! OUT : LIBINT : OBJET DU ZR DES BORNES DES INTERVALLES
! OUT : LINBPA : OBJET DU ZI DU NOMBRE DE PAS PAR INTERVALLE
! OUT : NPATOT : NOMBRE TOTAL DE PAS DE CALCUL
! IN  : TINIT  : TEMPS INITIAL
! IN  : LISINS : NOM DE LA LISTE DES INSTANTS DE CALCUL
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: valr(4)
    character(len=8) :: nomres, dyna, li
    character(len=16) :: typres, nomcmd
    integer :: i, ibid, iint, ip, iv, j, jbin2
    integer :: jbint, jlpa2, jlpas, jnbp2, jnbpa, jval2, jvale
    integer :: jvalr, k, n1, nbgrpa, nbinsr, nbinst, nbintn
    integer :: nbp, nbpd, nbpf, ndy, npatot, numef
    real(kind=8) :: dt, eps, t0, tfin, tinit
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call getres(nomres, typres, nomcmd)
!
!     --- EST-ON EN REPRISE ? ---
    call getvid('ETAT_INIT', 'RESULTAT', iocc=1, scal=dyna, nbret=ndy)
!
!     --- DEFINITION DES INSTANTS DE CALCUL A PARTIR DE "LIST_INST" ---
!
    call getvid('INCREMENT', 'LIST_INST', iocc=1, scal=li, nbret=n1)
    if (n1 .ne. 0) then
        call jeveuo(li//'           .LPAS', 'L', jlpas)
        call jeveuo(li//'           .NBPA', 'L', jnbpa)
        call jeveuo(li//'           .VALE', 'L', jvale)
        call jeveuo(li//'           .BINT', 'L', jbint)
        call jelira(li//'           .VALE', 'LONUTI', nbinst)
        call jelira(li//'           .NBPA', 'LONUTI', nbgrpa)
        lispas = li//'           .LPAS'
        libint = li//'           .BINT'
        linbpa = li//'           .NBPA'
!
        lisins = li//'           .VALE'
        npatot = nbinst - 1
!
!
!        --- SI REPRISE, IL FAUT SE RECALER ---
        if (ndy .ne. 0) then
!           --- DANS QUEL INTERVALLE SE SITUE LE TEMPS INITIAL ---
            do iint = 1, nbgrpa
                if (tinit .lt. zr(jbint+iint)) goto 102
            end do
            valr (1) = tinit
            valr (2) = zr(jbint+nbgrpa)
            call utmess('F', 'DYNALINE1_89', nr=2, valr=valr)
102         continue
            eps = zr(jlpas+iint-1) / 10.d0
            if (abs(zr(jbint+iint)-tinit) .lt. eps) iint = iint + 1
            nbintn = nbgrpa - iint + 1
!           --- ON CREE UNE NOUVELLE LISTE ---
            call wkvect('&&COMDLT.LI_BINT', 'V V R', nbintn+1, jbin2)
            call wkvect('&&COMDLT.LI_LPAS', 'V V R', nbintn, jlpa2)
            call wkvect('&&COMDLT.LI_NBPA', 'V V I', nbintn, jnbp2)
            j = 0
            do i = iint+1, nbgrpa
                j = j + 1
                zi(jnbp2+j) = zi(jnbpa+i-1)
                zr(jbin2+j) = zr(jbint+i-1)
                zr(jlpa2+j) = zr(jlpas+i-1)
            end do
            j = j + 1
            zr(jbin2+j) = zr(jbint+nbgrpa)
!           --- POUR LE PREMIER INTERVALLE ---
            zr(jbin2) = tinit
            nbpd = 0
            if (iint .ne. 1) then
                do i = 1, iint-1
                    nbpd = nbpd + zi(jnbpa+i-1)
                end do
            endif
            if (nbgrpa .eq. 1) then
                nbpf = nbinst - 1
            else
                nbpf = nbpd + zi(jnbpa+iint-1)
            endif
            eps = zr(jlpas+iint-1) / 10.d0
            do iv = nbpd, nbpf
                if (abs(zr(jvale+iv)-tinit) .lt. eps) goto 122
            end do
            valr (1) = tinit
            valr (2) = zr(jlpas+iint-1)
            valr (3) = zr(jbint+iint-1)
            valr (4) = zr(jbint+iint)
            call utmess('F', 'DYNALINE1_90', nr=4, valr=valr)
122         continue
            zi(jnbp2) = nbpf - iv
            zr(jlpa2) = zr(jlpas+iint-1)
            lispas = '&&COMDLT.LI_LPAS'
            libint = '&&COMDLT.LI_BINT'
            linbpa = '&&COMDLT.LI_NBPA'
            jnbpa = jnbp2
            jlpas = jlpa2
            jbint = jbin2
            nbgrpa = nbintn
            npatot = 0
            do ip = 1, nbgrpa
                npatot = npatot + zi(jnbpa+ip-1)
            end do
            nbinst = npatot + 1
            call wkvect('&&COMDLT.FI_JVALE', 'V V R', nbinst, jvale)
            j = 0
            zr(jvale) = tinit
            do i = 1, nbgrpa
                dt = zr(jlpas+i-1)
                nbp = zi(jnbpa+i-1)
                t0 = zr(jbint+i-1)
                do  k = 1, nbp
                    j = j + 1
                    zr(jvale+j) = t0 + k*dt
                end do
            end do
            lisins= '&&COMDLT.FI_JVALE'
        endif
!
        call getvis('INCREMENT', 'NUME_FIN', iocc=1, scal=numef, nbret=n1)
        if (n1 .eq. 0) then
            call getvr8('INCREMENT', 'INST_FIN', iocc=1, scal=tfin, nbret=n1)
            if (n1 .eq. 0) goto 999
        else
            call jeveuo(li//'           .VALE', 'L', jvalr)
            call jelira(li//'           .VALE', 'LONUTI', nbinsr)
            if (numef .ge. nbinsr) goto 999
            tfin = zr(jvalr+numef)
        endif
!
        if (tfin .lt. zr(jbint)) then
            valr (1) = tfin
            valr (2) = zr(jbint)
            call utmess('F', 'DYNALINE1_91', nr=2, valr=valr)
        else if (tfin.ge.zr(jbint+nbgrpa)) then
            goto 999
        endif
!        --- DANS QUEL INTERVALLE SE SITUE L'INSTANT ---
        do iint = 1, nbgrpa
            eps = zr(jlpas+iint-1) / 10.d0
            if (abs(zr(jbint+iint)-tfin) .lt. eps) exit
            if (tfin .lt. zr(jbint+iint)) exit
        end do
        nbintn = iint
!        --- ON CREE UNE NOUVELLE LISTE ---
        call wkvect('&&COMDLT.LI_BINTF', 'V V R', nbintn+1, jbin2)
        call wkvect('&&COMDLT.LI_LPASF', 'V V R', nbintn, jlpa2)
        call wkvect('&&COMDLT.LI_NBPAF', 'V V I', nbintn, jnbp2)
        do i = 1, iint
            zi(jnbp2+i-1) = zi(jnbpa+i-1)
            zr(jbin2+i-1) = zr(jbint+i-1)
            zr(jlpa2+i-1) = zr(jlpas+i-1)
        end do
        zr(jbin2+iint) = tfin
!        --- POUR LE DERNIER INTERVALLE ---
        nbpd = 0
        do i = 1, iint-1
            nbpd = nbpd + zi(jnbpa+i-1)
        end do
        nbpf = nbpd + zi(jnbpa+iint-1)
        eps = zr(jlpas+iint-1) / 10.d0
        do iv = nbpd, nbpf
            if (abs(zr(jvale+iv)-tfin) .lt. eps) goto 232
        end do
        valr (1) = tfin
        valr (2) = zr(jlpas+iint-1)
        valr (3) = zr(jbint+iint-1)
        valr (4) = zr(jbint+iint)
        call utmess('F', 'DYNALINE1_92', nr=4, valr=valr)
232      continue
        zi(jnbp2+iint-1) = iv - nbpd
        lispas = '&&COMDLT.LI_LPASF'
        libint = '&&COMDLT.LI_BINTF'
        linbpa = '&&COMDLT.LI_NBPAF'
        jnbpa = jnbp2
        jlpas = jlpa2
        jbint = jbin2
        nbgrpa = nbintn
        npatot = 0
        do ip = 1, nbgrpa
            npatot = npatot + zi(jnbpa+ip-1)
        end do
        nbinst = npatot + 1
        call wkvect('&&COMDLT.FI_JVALF', 'V V R', nbinst, jvale)
        zr(jvale) = zr(jbint)
        j=0
        do i = 1, nbgrpa
            dt = zr(jlpas+i-1)
            nbp = zi(jnbpa+i-1)
            t0 = zr(jbint+i-1)
            do k = 1, nbp
                j = j + 1
                zr(jvale+j) = t0 + k*dt
            end do
        end do
        lisins='&&COMDLT.FI_JVALF'
!
        goto 999
    endif
!
!     --- DEFINITION DES INSTANTS DE CALCUL A PARTIR DE "PAS" ---
!
    call getvr8('INCREMENT', 'INST_FIN', iocc=1, scal=tfin, nbret=ibid)
    call getvr8('INCREMENT', 'PAS', iocc=1, scal=dt, nbret=ibid)
    if (dt .eq. 0.d0) then
        call utmess('F', 'DYNALINE1_12')
    endif
    call wkvect('&&COMDLT.LI_BINT', 'V V R', 2, jbin2)
    call wkvect('&&COMDLT.LI_LPAS', 'V V R', 1, jlpa2)
    call wkvect('&&COMDLT.LI_NBPA', 'V V I', 1, jnbp2)
    npatot = nint((tfin-tinit)/dt)
    zi(jnbp2) = npatot
    zr(jbin2) = tinit
    zr(jbin2+1) = tfin
    zr(jlpa2) = dt
    nbgrpa=1
    lispas = '&&COMDLT.LI_LPAS'
    libint = '&&COMDLT.LI_BINT'
    linbpa = '&&COMDLT.LI_NBPA'
    call wkvect('&&COMDLT.LI_VALE', 'V V R', npatot+1, jval2)
    do i = 0, npatot
        zr(jval2+i)=tinit+i*dt
    end do
    lisins = '&&COMDLT.LI_VALE'
!
999 continue
    call jedema()
end subroutine
