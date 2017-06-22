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

subroutine jeccta(colle1)
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedupo.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
    character(len=*) :: colle1
! person_in_charge: jacques.pellet at edf.fr
! ======================================================================
!     RETASSAGE D'UNE COLLECTION CONTIGUE ALLOUEE TROP GRANDE
!     ------------------------------------------------------------------
! IN  COLLE1  : K24 : NOM DE LA COLLECTION CONTIGUE A RETASSER
!     ------------------------------------------------------------------
!
    character(len=8) :: base, type, acces, stock, modelo
    character(len=24) :: colle2
    integer :: k, nbobj, lont1, lont2, jloncu
    integer :: n1, jcoll1, jcoll2
!-----------------------------------------------------------------------
    call jemarq()
!
!
!     -- CALCUL DE :
!        BASE, TYPE, NBOBJ,
!        ACCES, STOCK, MODELO, LONT1 ET LONT2 :
!     -------------------------------------------------------
    call jelira(colle1, 'CLAS', cval=base)
    call jelira(colle1, 'TYPE', cval=type)
    call jelira(colle1, 'NMAXOC', nbobj)
    call jelira(colle1, 'ACCES', cval=acces)
    call jelira(colle1, 'MODELONG', cval=modelo)
    call jelira(colle1, 'STOCKAGE', cval=stock)
    call jelira(colle1, 'LONT', lont1)
    ASSERT(type.ne.'K')
    ASSERT(stock.eq.'CONTIG')
    ASSERT(modelo.eq.'VARIABLE')
    ASSERT(acces.eq.'NU')
!
    call jeveuo(jexatr(colle1, 'LONCUM'), 'L', jloncu)
    lont2=zi(jloncu-1+nbobj+1)
!
!
!     -- ALLOCATION ET REMPLISAGE DE COLLE2 :
!     ------------------------------------------------
    colle2='&&JECCTA.COLLEC2'
    call jecrec(colle2, 'V V '//type, acces, stock, modelo,&
                nbobj)
    call jeecra(colle2, 'LONT', lont2)
    call jeveuo(colle1, 'L', jcoll1)
    call jeveuo(colle2, 'E', jcoll2)
    if (type .eq. 'I') then
        do 10,k=1,lont2
        zi(jcoll2-1+k)=zi(jcoll1-1+k)
10      continue
    else if (type.eq.'R') then
        do 20,k=1,lont2
        zr(jcoll2-1+k)=zr(jcoll1-1+k)
20      continue
    else if (type.eq.'C') then
        do 30,k=1,lont2
        zc(jcoll2-1+k)=zc(jcoll1-1+k)
30      continue
    else
        ASSERT(.false.)
    endif
!
    do 40,k=1,nbobj
    n1=zi(jloncu-1+k+1)-zi(jloncu-1+k)
    call jecroc(jexnum(colle2, k))
    call jeecra(jexnum(colle2, k), 'LONMAX', n1)
    40 end do
!
!
!     RECOPIE DE COLLE2 DANS COLLE1 :
!     ------------------------------
    call jedetr(colle1)
    call jedupo(colle2, base, colle1, .false._1)
!
!
!     -- MENAGE :
    call jedetr(colle2)
    call jedema()
end subroutine
