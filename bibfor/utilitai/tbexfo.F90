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

subroutine tbexfo(nomta, parax, paray, nomfo, interp,&
                  prolgd, basfon)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=*) :: nomta, parax, paray, nomfo, basfon, interp, prolgd
!      CREER UNE FONCTION A PARTIR D'UNE TABLE.
! ----------------------------------------------------------------------
! IN  : NOMTA  : NOM DE LA STRUCTURE "TABLE".
! IN  : PARAX  : PARAMETRE ABSCISSE
! IN  : PARAY  : PARAMETRE ORDONNEE
! IN  : NOMFO  : NOM DE LA FONCTION
! IN  : BASFON : BASE SUR LAQUELLE ON CREE LA FONCTION
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    integer :: iret, nbpara, nblign,   nbval
    integer :: iparx, ipary, lpro
    integer :: i, iv, jvalex, jvaley, jvallx, jvally, kvale, nbfon
    character(len=1) :: base
    character(len=4) :: typex, typey
    character(len=19) :: nomtab, nomfon
    character(len=24) :: nojvx, nojvlx, nojvy, nojvly, inpar, jnpar
    character(len=24) :: valk
    integer, pointer :: tbnp(:) => null()
    character(len=24), pointer :: tblp(:) => null()
!
! DEB------------------------------------------------------------------
!
    call jemarq()
!
    nomtab = nomta
    base = basfon(1:1)
    nomfon = nomfo
!
!     --- VERIFICATION DE LA BASE ---
!
    ASSERT(base.eq.'V' .or. base.eq.'G')
!
!     --- VERIFICATION DE LA TABLE ---
!
    call jeexin(nomtab//'.TBBA', iret)
    if (iret .eq. 0) then
        call utmess('F', 'UTILITAI4_64')
    endif
!
    call jeveuo(nomtab//'.TBNP', 'L', vi=tbnp)
    nbpara = tbnp(1)
    nblign = tbnp(2)
    if (nbpara .eq. 0) then
        call utmess('F', 'UTILITAI4_65')
    endif
    if (nblign .eq. 0) then
        call utmess('F', 'UTILITAI4_76')
    endif
!
!     --- VERIFICATION QUE LES PARAMETRES EXISTENT DANS LA TABLE ---
!
    call jeveuo(nomtab//'.TBLP', 'L', vk24=tblp)
    inpar = parax
    do 10 iparx = 1, nbpara
        jnpar = tblp(1+4*(iparx-1))
        if (inpar .eq. jnpar) goto 12
10  continue
    valk = inpar
    call utmess('F', 'UTILITAI6_89', sk=valk)
12  continue
    inpar = paray
    do 14 ipary = 1, nbpara
        jnpar = tblp(1+4*(ipary-1))
        if (inpar .eq. jnpar) goto 16
14  continue
    valk = inpar
    call utmess('F', 'UTILITAI6_89', sk=valk)
16  continue
!
    typex = tblp(1+4*(iparx-1)+1)
    nojvx = tblp(1+4*(iparx-1)+2)
    nojvlx = tblp(1+4*(iparx-1)+3)
    typey = tblp(1+4*(ipary-1)+1)
    nojvy = tblp(1+4*(ipary-1)+2)
    nojvly = tblp(1+4*(ipary-1)+3)
!
    if (typex .ne. typey) then
        if ((typex(1:1).eq.'I' .and. ((typey(1:1).eq.'R').or.(typey(1:1).eq.'C'))) .or. &
           (typex(1:1).eq.'R' .and. ((typey(1:1).eq.'I').or.(typey(1:1).eq.'C')))) goto 17
        call utmess('F', 'UTILITAI4_77')
    endif
17  continue
!
    call jeveuo(nojvx, 'L', jvalex)
    call jeveuo(nojvy, 'L', jvaley)
    call jeveuo(nojvlx, 'L', jvallx)
    call jeveuo(nojvly, 'L', jvally)
    nbval = 0
    do 20 i = 1, nblign
        if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) nbval = nbval + 1
20  end do
!
!     VERIF QU'ON A TROUVE QUELQUE CHOSE
    if (nbval .eq. 0) then
        call utmess('F', 'UTILITAI4_78')
    endif
!
    ASSERT(lxlgut(nomfon).le.24)
    call wkvect(nomfon//'.PROL', base//' V K24', 6, lpro)
    zk24(lpro) = 'FONCTION'
    zk24(lpro+1) = interp
    zk24(lpro+2) = parax
    zk24(lpro+3) = paray
    zk24(lpro+4) = prolgd
    zk24(lpro+5) = nomfon
!
    nbfon = nbval
    nbval = 2 * nbval
!
    iv = 0
    if (typex(1:1) .eq. 'I') then
!
        if (typey(1:1) .eq. 'R') then
            call wkvect(nomfon//'.VALE', base//' V R', nbval, kvale)
            do 300 i = 1, nblign
                if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                    iv = iv + 1
                    zr(kvale+iv-1) = zi(jvalex+i-1)*1.d0
                    zr(kvale+nbfon+iv-1) = zr(jvaley+i-1)
                endif
300          continue
        else if (typey(1:1) .eq. 'C') then
            zk24(lpro) = 'FONCT_C'
            call wkvect(nomfon//'.VALE', base//' V R', nbfon*3, kvale)
            do i = 1, nblign
                if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                    iv = iv + 1
                    zr(kvale+iv-1) = zi(jvalex+i-1)*1.d0
                    zr(kvale+nbfon+iv-1) = dble(zc(jvaley+i-1))
                    zr(kvale+2*nbfon+iv-1) = dimag(zc(jvaley+i-1))
                endif
            end do
        else if (typey(1:1) .eq. 'I') then
            call wkvect(nomfon//'.VALE', base//' V I', nbval, kvale)
            do 30 i = 1, nblign
                if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                    iv = iv + 1
                    zi(kvale+iv-1) = zi(jvalex+i-1)
                    zi(kvale+nbfon+iv-1) = zi(jvaley+i-1)
                endif
30          continue
        endif
!
    else if (typex(1:1) .eq. 'R') then
!
        if (typey(1:1) .eq. 'I') then
            call wkvect(nomfon//'.VALE', base//' V R', nbval, kvale)
            do 311 i = 1, nblign
                if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                    iv = iv + 1
                    zr(kvale+iv-1) = zr(jvalex+i-1)
                    zr(kvale+nbfon+iv-1) = zi(jvaley+i-1)*1.d0
                endif
311          continue
        else if (typey(1:1) .eq. 'C') then
            zk24(lpro) = 'FONCT_C'
            call wkvect(nomfon//'.VALE', base//' V R', 3*nbfon, kvale)
            do i = 1, nblign
                if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                    iv = iv + 1
                    zr(kvale+iv-1) = zr(jvalex+i-1)
                    zr(kvale+nbfon+iv-1) = dble(zc(jvaley+i-1))
                    zr(kvale+2*nbfon+iv-1) = dimag(zc(jvaley+i-1))

                endif
            end do
        else if (typey(1:1) .eq. 'R') then
            call wkvect(nomfon//'.VALE', base//' V R', nbval, kvale)
            do 31 i = 1, nblign
                if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                    iv = iv + 1
                    zr(kvale+iv-1) = zr(jvalex+i-1)
                    zr(kvale+nbfon+iv-1) = zr(jvaley+i-1)
                endif
31          continue
        endif
!
    else if (typex(1:1) .eq. 'C') then
        call wkvect(nomfon//'.VALE', base//' V C', nbval, kvale)
        do 32 i = 1, nblign
            if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                iv = iv + 1
                zc(kvale+iv-1) = zc(jvalex+i-1)
                zc(kvale+nbfon+iv-1) = zc(jvaley+i-1)
            endif
32      continue
    else if (typex(1:3) .eq. 'K80') then
        call wkvect(nomfon//'.VALE', base//' V K80', nbval, kvale)
        do 33 i = 1, nblign
            if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                iv = iv + 1
                zk80(kvale+iv-1) = zk80(jvalex+i-1)
                zk80(kvale+nbfon+iv-1) = zk80(jvaley+i-1)
            endif
33      continue
    else if (typex(1:3) .eq. 'K32') then
        call wkvect(nomfon//'.VALE', base//' V K32', nbval, kvale)
        do 34 i = 1, nblign
            if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                iv = iv + 1
                zk32(kvale+iv-1) = zk32(jvalex+i-1)
                zk32(kvale+nbfon+iv-1) = zk32(jvaley+i-1)
            endif
34      continue
    else if (typex(1:3) .eq. 'K24') then
        call wkvect(nomfon//'.VALE', base//' V K24', nbval, kvale)
        do 35 i = 1, nblign
            if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                iv = iv + 1
                zk24(kvale+iv-1) = zk24(jvalex+i-1)
                zk24(kvale+nbfon+iv-1) = zk24(jvaley+i-1)
            endif
35      continue
    else if (typex(1:3) .eq. 'K16') then
        call wkvect(nomfon//'.VALE', base//' V ZK16', nbval, kvale)
        do 36 i = 1, nblign
            if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                iv = iv + 1
                zk16(kvale+iv-1) = zk16(jvalex+i-1)
                zk16(kvale+nbfon+iv-1) = zk16(jvaley+i-1)
            endif
36      continue
    else if (typex(1:2) .eq. 'K8') then
        call wkvect(nomfon//'.VALE', base//' V ZK8', nbval, kvale)
        do 37 i = 1, nblign
            if (zi(jvallx+i-1) .eq. 1 .and. zi(jvally+i-1) .eq. 1) then
                iv = iv + 1
                zk8(kvale+iv-1) = zk8(jvalex+i-1)
                zk8(kvale+nbfon+iv-1) = zk8(jvaley+i-1)
            endif
37      continue
    endif
!
    call jedema()
end subroutine
