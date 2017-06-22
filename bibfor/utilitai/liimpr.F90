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

subroutine liimpr(noml, impr, fichie)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/iunifi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
    character(len=*) :: noml, fichie
    integer :: impr
!     ROUTINE D'IMPRESSION D'UNE LISTE DE ENTIERS OU DE REELS
!     ----------------------------------------------------------------
!
    character(len=8) :: file, k8bid, ctyp
    character(len=16) :: nomcmd
    character(len=19) :: nomlis
    character(len=24) :: lpas, nbpa, vale, bint, titr
    aster_logical :: lisree
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, iret, iul, jbor, jnbp
    integer :: jpas, jval, k, l, lg, ltitr
    integer :: nbint, nbtitr, nbval, nd, nl
!-----------------------------------------------------------------------
    call jemarq()
    if (impr .le. 0) goto 9999
    file = fichie
    iul = iunifi(file)
    if (iul .le. 0) then
        call getres(k8bid, k8bid, nomcmd)
        lg = max(1,lxlgut(file))
        call utmess('A', 'UTILITAI2_47', sk=file(1:lg))
        goto 9999
    endif
!
!     --- NOM DE LA FONCTION A EDITER ---
    nomlis = noml
    lpas = nomlis//'.LPAS'
    nbpa = nomlis//'.NBPA'
    vale = nomlis//'.VALE'
    bint = nomlis//'.BINT'
    titr = nomlis//'.TITR'
    lisree = .true.
    call jelira(vale, 'TYPE', cval=ctyp)
    if (ctyp(1:1) .eq. 'I') lisree = .false.
!
!     --- IMPRESSION DU TITRE ---
    write(iul,'(/,1X,79(''-''))')
    call jeexin(titr, iret)
    if (iret .ne. 0) then
        call jeveuo(titr, 'L', ltitr)
        call jelira(titr, 'LONMAX', nbtitr)
        do 10 i = 1, nbtitr
            write(iul,*) zk80(ltitr+i-1)
 10     continue
    endif
!
    call jelira(vale, 'LONMAX', nbval)
    call jelira(nbpa, 'LONMAX', nbint)
    call jeveuo(lpas, 'L', jpas)
    call jeveuo(nbpa, 'L', jnbp)
    call jeveuo(vale, 'L', jval)
    call jeveuo(bint, 'L', jbor)
    nl = nbval / 5
    nd = nbval - ( nl * 5 )
!
!
    write(iul,'(3X,A,12X,A,10X,A,10X,A,5X,A)')&
     &          'INTERVALLE','DEBUT','JUSQU_A','PAR_PAS','NOMBRE'
    if (lisree) then
        if (nbval .eq. 1) then
            write(iul,'(3X,7X,I3,5X,1PE12.5,5X,1PE12.5,5X,1PE12.5,5X,I6)')&
     &              1,zr(jbor),zr(jbor),zr(jpas),zi(jnbp)
            if (impr .gt. 1) then
                write(iul,'(3X,A)')'IMPRESSION DE LA LISTE DE REELS'
                write(iul, 1000)1,zr(jval)
            endif
        else
            do 20 i = 1, nbint
                write(iul,'(3X,7X,I3,5X,1PE12.5,5X,1PE12.5,5X,1PE12.5,5X,I6)')&
     &              i,zr(jbor+i-1),zr(jbor+i),zr(jpas+i-1),zi(jnbp+i-1)
 20         continue
            if (impr .gt. 1) then
                write(iul,'(3X,A)')'IMPRESSION DE LA LISTE DE REELS'
                do 21 l = 1, nl
                    write(iul,1000) 5*(l-1)+1,(zr( jval + 5*(l-1)+k-1)&
                    ,k=1,5)
 21             continue
                if (nd .ne. 0) then
                    write(iul,1000) 5*nl+1,(zr( jval +5*nl+k-1),k=1,&
                    nd)
                endif
            endif
        endif
    else
        if (nbval .eq. 1) then
            write(iul,'(3X,7X,I3,5X,I12,5X,I12,5X,I12,5X,I6)')&
            1,zi(jbor),zi(jbor),zi(jpas),zi(jnbp)
            if (impr .gt. 1) then
                write(iul,'(3X,A)')'IMPRESSION DE LA LISTE D ENTIERS'
                write(iul,'((I7,'' - '',I12))')1,zi(jval)
            endif
        else
            do 30 i = 1, nbint
                write(iul,'(3X,7X,I3,5X,I12,5X,I12,5X,I12,5X,I6)')&
                i,zi(jbor+i-1),zi(jbor+i),zi(jpas+i-1),zi(jnbp+i-1)
 30         continue
            if (impr .gt. 1) then
                write(iul,'(3X,A)')'IMPRESSION DE LA LISTE D ENTIERS'
                do 31 l = 1, nl
                    write(iul,'((I7,'' - '',5(I12,1X)))') 5*(l-1)+1,(&
                    zi( jval + 5*(l-1)+k-1),k=1,5)
 31             continue
                if (nd .ne. 0) then
                    write(iul,'(I7,'' - '',5(I12,1X))') 5*nl+1,(zi(&
                    jval +5*nl+k-1),k=1,nd)
                endif
            endif
        endif
    endif
!
9999 continue
    call jedema()
!
    1000 format(i7,' - ',5(1pe16.9,1x))
end subroutine
