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

subroutine cclodr(nuoplo, nbordr, lisord, nobase, minord,&
                  maxord, resuin, resuou, lacalc)
    implicit none
!     --- ARGUMENTS ---
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
    integer :: nuoplo, nbordr, minord, maxord
    character(len=8) :: resuin, resuou, nobase
    character(len=19) :: lisord
    character(len=24) :: lacalc
!  CALC_CHAMP - DETERMINATION LISTE OPTIONS AVEC DEPENDANCE REDUITE
!  -    -                     -     -            -          -
! ----------------------------------------------------------------------
!
!  MODIFICATION DE LACALC EN METTANT DES 0 LORSQUE L'OPTION NE DOIT
!   PAS ETRE CALCULEE
!
!  IN  :
!   NUOPLO  I    INDICE DE L'OPTION POUR LAQUELLE ON SOUHAITE OBTENIR
!                LA LISTE DE NUMEROS D'ORDRE
!   NBORDR  I    NOMBRE DE NUMEROS D'ORDRE
!   LISORD  K19  LISTE DE NUMEROS D'ORDRE
!   NOBASE  K8   BASE DU NOM A PARTIR DE LAQUELLE LE NOM DES OBJETS DE
!                CCLIOP SERONT CONSTRUITS
!   MINORD  I    NUMERO D'ORDRE MIN
!   MAXORD  I    NUMERO D'ORDRE MAX
!   RESUIN  K8   NOM DE LA STRUCTURE DE DONNEES RESULTAT IN
!   RESUOU  K8   NOM DE LA STRUCTURE DE DONNEES RESULTAT OUT
!
!  IN/OUT :
!   LACALC  K24  NOM DE LA LISTE D'ENTIER QUI SERA MODIFIE
! ----------------------------------------------------------------------
! person_in_charge: nicolas.sellenet at edf.fr
!
    integer :: jlisop, jliori, jlidep, ierd, inddeb, indfin
    integer :: iordr, curmax, curmin, iter, decal, numord, jlnoin
    integer :: jordo2, jlisde, jordr, jacalc
!
    character(len=1) :: isodep
    character(len=16) :: option
    character(len=19) :: nosyou
    character(len=24) :: noliop, nolori, noldep, noliin, nolisd
!
    aster_logical :: exitor
!
    call jemarq()
!
    call jeveuo(lisord, 'L', jordr)
!
    isodep = ' '
    noliop = nobase//'.LISOPT'
    nolori = nobase//'.LISORI'
    noldep = nobase//'.LISDEP'
    noliin = nobase//'.LNOINS'
    nolisd = nobase//'.ISODEP'
!
    call jeveuo(noliop, 'L', jlisop)
    call jeveuo(nolori, 'L', jliori)
    call jeveuo(noldep, 'L', jlidep)
    call jeveuo(noliin, 'L', jlnoin)
    call jeveuo(nolisd, 'L', jlisde)
    call jeveuo(lacalc, 'E', jacalc)
!
    option = zk24(jlisop+nuoplo-1)
    inddeb = zi(jliori+2*nuoplo-2)
    indfin = zi(jliori+2*nuoplo-1)
    isodep = zk8(jlisde+nuoplo-1)
!
    if (inddeb .ne. 0) then
!       CAS 1 : CETTE OPTION DEPEND D'AUTRES OPTIONS A CALCULER
!               AUQUEL CAS, IL FAUT REGARDER COMMENT ELLE EN DEPEND
!               ET LA LISTE DES NUMEROS D'ORDRE DE SES PARENTS
        call jeveuo(noliin, 'L', jlnoin)
        curmax = maxord
        curmin = minord
        do 10 iter = inddeb, indfin
            call jeveuo(zk24(jlnoin+iter-1), 'L', jordo2)
!
            if (zk8(jlidep+iter-1) .eq. 'NP1') then
                decal = -1
            else if (zk8(jlidep+iter-1).eq.'NM1') then
                decal = +1
            else
                decal = 0
            endif
!
!         LA LISTE DE NUMEROS D'ORDRE PROVIENT DE OP0058
!         ELLE EST DONC CROISSANTE
            curmax = min(curmax,zi(jordo2+2)+decal)
            curmin = max(curmin,zi(jordo2+1)+decal)
 10     continue
!
        exitor = .true.
        if (zi(jacalc+nuoplo-1) .eq. 1) then
            do 30 iordr = 1, nbordr
                numord = zi(jordr-1+iordr)
                if ((isodep.eq.'-') .and. (numord.eq.minord)) then
                    goto 30
                    elseif ( (isodep.eq.'+').and.(numord.eq.maxord) )&
                then
                    goto 30
                endif
                if (numord .ge. curmin) then
                    if (numord .gt. curmax) goto 40
                    nosyou = ' '
                    call rsexch(' ', resuin, option, numord, nosyou,&
                                ierd)
                    if (ierd .ne. 0) then
                        call rsexch(' ', resuou, option, numord, nosyou,&
                                    ierd)
                    endif
!
                    if (ierd .ne. 0) then
                        exitor = .false.
                    endif
                endif
 30         continue
        endif
!
 40     continue
!
        if (exitor) then
            do 50 iter = inddeb, indfin
                zi(jacalc+iter-1) = 0
 50         continue
        endif
    endif
!
    call jedema()
!
end subroutine
