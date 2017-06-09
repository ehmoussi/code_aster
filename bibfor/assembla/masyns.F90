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

subroutine masyns(matas)
! person_in_charge: jacques.pellet at edf.fr
    implicit none
!
!  BUT :
!   TRANSFORMER UNE MATR_ASSE SYMETRIQUE EN UNE MATR_ASSE NON-SYMETRIQUE
!   POUR CELA, ON DUPPLIQUE LES VALEURS DE LA MOITIE SUPERIEURE
!
!  ARGUMENT :
!    MATAS K19  JXVAR : MATR_ASSE A RENDRE NON-SYMETRIQUE
!
! ========================= DEBUT DES DECLARATIONS ====================
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
#include "asterfort/jexnum.h"
    character(len=*) :: matas
    character(len=1) :: base, ktyp
    character(len=19) :: mat19
    integer ::  i, nbloc, lgbloc, jvalmi, jvalms, jvalma
    character(len=24), pointer :: refa(:) => null()
!
!---------------------------------------------------------------------
    call jemarq()
!
    mat19 = matas(1:19)
    call jelira(mat19//'.VALM', 'CLAS', cval=base)
    call jelira(mat19//'.VALM', 'TYPE', cval=ktyp)
    ASSERT(ktyp.eq.'R'.or.ktyp.eq.'C')
    call jeveuo(mat19//'.REFA', 'E', vk24=refa)
    ASSERT(refa(9).eq.'MS')
    refa(9)='MR'
!
    call jelira(mat19//'.VALM', 'NMAXOC', nbloc)
    ASSERT(nbloc.eq.1)
    call jelira(jexnum(mat19//'.VALM', 1), 'LONMAX', lgbloc)
!
!
    call jedupo(mat19//'.VALM', 'V', '&&MASYNS.VALM', .false._1)
    call jedetr(mat19//'.VALM')
!
    call jecrec(mat19//'.VALM', base//' V '//ktyp, 'NU', 'DISPERSE', 'CONSTANT',&
                2)
    call jeecra(mat19//'.VALM', 'LONMAX', lgbloc)
    call jecroc(jexnum(mat19//'.VALM', 1))
    call jeveuo(jexnum(mat19//'.VALM', 1), 'E', jvalms)
    call jecroc(jexnum(mat19//'.VALM', 2))
    call jeveuo(jexnum(mat19//'.VALM', 2), 'E', jvalmi)
!
!
    call jeveuo(jexnum('&&MASYNS.VALM', 1), 'L', jvalma)
    if (ktyp .eq. 'R') then
        do 20 i = 1, lgbloc
            zr(jvalms+i-1) = zr(jvalma+i-1)
            zr(jvalmi+i-1) = zr(jvalma+i-1)
20      continue
    else
        do 21 i = 1, lgbloc
            zc(jvalms+i-1) = zc(jvalma+i-1)
            zc(jvalmi+i-1) = zc(jvalma+i-1)
21      continue
    endif
    call jedetr('&&MASYNS.VALM')
!
!
    call jedema()
end subroutine
