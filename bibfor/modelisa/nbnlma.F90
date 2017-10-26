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
subroutine nbnlma(noma, nbm    , limanu    , nbtyp, lityp,&
                  nbn , l_error, elem_error)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=8), intent(in) :: noma
integer, intent(in) :: nbm
integer, intent(in) :: limanu(*)
integer, intent(in) :: nbtyp
character(len=8), intent(in) :: lityp(*)
integer, intent(out) :: nbn
aster_logical, intent(out) :: l_error
character(len=8), intent(out) :: elem_error
!
! --------------------------------------------------------------------------------------------------
!
! BUT : TROUVER LE NOMBRE DE NOEUDS QUI APPARTIENNENT A UNE LISTE DE
!       MAILLES, ET EVENTUELLEMENT LEURS NUMEROS
!       VERIFIER QUE LES MAILLES DE CETTE LISTE SONT D'UN TYPE CORRECT
!
! --------------------------------------------------------------------------------------------------
!
! ARGUMENTS D'ENTREE:
!      NOMA : NOM DU MAILLAGE
!      NBM  : NOMBRE DE MAILLES DANS LA LISTE.
!    LIMANU : LISTE DES NUMEROS DE MAILLE
!     NBTYP : NOMBRE DE TYPE_MAILLES DANS LA LISTE LITYP.
!             SI NBTYP=0: AUCUNE VERIF N'EST FAITE SUR LES TYPES
!    LITYP  : LISTE DES TYPES DE MAILLE
!             SI NBTYP=0: LITYP=K8BID
! ARGUMENTS DE SORTIE:
!      NBN  : NOMBRE DE NOEUDS
!   OBJETS JEVEUX CREES
!      &&NBNLMA.LN   : NUMEROS DES NOEUDS
!      &&NBNLMA.NBN  : NOMBRES D'OCCURENCES DES NOEUDS
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iatyma, iret, it, itrou, j, jln, jnbn, jtyp, m, mi, n, nbna, nbnm
    integer :: nn, numtyp,  p2
    character(len=8) :: mk, valk
    integer, pointer :: connex(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    nbn        = 0
    l_error    = ASTER_FALSE
    elem_error = ' '
    call jeveuo(noma//'.TYPMAIL', 'L', iatyma)
    call jeveuo(jexatr(noma//'.CONNEX', 'LONCUM'), 'L', p2)
    call jeveuo(noma//'.CONNEX', 'L', vi=connex)
!
! --- SI ON SOUHAITE CONTROLER LE TYPE DE MAILLE DE LIMANU:
    if (nbtyp .ne. 0) then
        nbnm = 0
        do m = 1, nbm
            mi = limanu(m)
            jtyp = iatyma-1 + mi
            nn = 0
            do it = 1, nbtyp
                call jenonu(jexnom('&CATA.TM.NBNO', lityp(it)), numtyp)
                if (zi(jtyp) .eq. numtyp) then
                    nn = zi(p2+mi+1-1) - zi(p2+mi-1)
                endif
            end do
            if (nn .eq. 0) then
                call jenuno(jexnum(noma//'.NOMMAI', mi), mk)
                valk = mk
                l_error    = ASTER_TRUE
                elem_error = mk
                !call utmess('F', 'MODELISA8_68', sk=valk)
                goto 99
            else
                nbnm = nbnm + nn
            endif
        end do
    else
        nbnm = 0
        do m = 1, nbm
            mi = limanu(m)
            nn = zi(p2+mi+1-1) - zi(p2+mi-1)
            nbnm = nbnm + nn
        end do
    endif
!
!
    call jeexin('&&NBNLMA.LN', iret)
    if (iret .ne. 0) call jedetr('&&NBNLMA.LN')
    call wkvect('&&NBNLMA.LN', 'V V I', nbnm, jln)
    call jeecra('&&NBNLMA.LN', 'LONUTI', 0)
!
    call jeexin('&&NBNLMA.NBN', iret)
    if (iret .ne. 0) call jedetr('&&NBNLMA.NBN')
    call wkvect('&&NBNLMA.NBN', 'V V I', nbnm, jnbn)
    call jeecra('&&NBNLMA.NBN', 'LONUTI', 0)
!
    do m = 1, nbm
        mi = limanu(m)
        nn = zi(p2+mi+1-1) - zi(p2+mi-1)
!
        do n = 1, nn
!
!           NBNA EST LE NOMBRE DE NOEUDS ACTUELLEMENT STOCKES
!
            call jelira('&&NBNLMA.LN', 'LONUTI', nbna)
            itrou = 0
!
!           SI LE NUMERO DE NOEUD EXISTE DEJA DANS .LN
!           ON INCREMENTE A LA PLACE J DANS LE TABLEAU &&NBNLMA.NBN
!
            do j = 1, nbna
                if (connex(1+zi(p2+mi-1)-1+n-1) .eq. zi(jln-1+j)) then
                    zi(jnbn-1+j) = zi(jnbn-1+j)+1
                    itrou = 1
                endif
            end do
!
!           SI LE NUMERO DE NOEUD N'EXISTE PAS,
!           ON LE STOCKE A LA PLACE NBNA (A LA FIN ) DANS LE TABLEAU .LN
!           ET ON STOCKE 1 A LA PLACE NBNA LE TABLEAU &&NBNLMA.NBN
!
            if (itrou .eq. 0) then
                nbna = nbna + 1
                zi( jln-1+nbna) = connex(1+zi(p2+mi-1)-1+n-1)
                zi(jnbn-1+nbna) = 1
                call jeecra('&&NBNLMA.LN', 'LONUTI', nbna)
                call jeecra('&&NBNLMA.NBN', 'LONUTI', nbna)
            endif
        end do
    end do
!
    nbn = nbna
!
 99 continue
!
    call jedema()
end subroutine
