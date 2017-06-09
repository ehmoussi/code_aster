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

subroutine juagrn(nom, long)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=*) :: nom
    integer :: long
!     Redimensionnement d'un repertoire de nom
!     ------------------------------------------------------------------
! IN  NOM  : K24 : NOM DE L'OBJET A REDIMENSIONNER
! IN  LONG : I   : NOUVELLE LONGUEUR DU VECTEUR
!     ------------------------------------------------------------------
!
!
    character(len=8) :: type, no1
    character(len=16) :: no2
    character(len=24) :: no3
    character(len=32) :: no4
    character(len=80) :: no5
!
    integer :: lonma2, lonmax, iaux, jadr, ltyp
!-----------------------------------------------------------------------
    call jemarq()
    call jelira(nom, 'NOMMAX', lonmax)
    call jelira(nom, 'TYPE  ', cval=type)
    if (type(1:1) .ne. 'K') then
        ASSERT(.false.)
    else
        call jelira(nom, 'LTYP', ltyp)
        call codent(ltyp, 'G', type(2:))
        call wkvect('&&JEAGRN.TMP', 'V V '//type, long, jadr)
    endif
    lonma2 = min(lonmax, long)
    if (ltyp .eq. 8) then
        do iaux = 1, lonma2
            call jenuno(jexnum(nom, iaux), no1)
            zk8(jadr+iaux-1) = no1
        enddo
    else if (ltyp .eq. 16) then
        do iaux = 1, lonma2
            call jenuno(jexnum(nom, iaux), no2)
            zk16(jadr+iaux-1) = no2
        enddo
    else if (ltyp .eq. 24) then
        do iaux = 1, lonma2
            call jenuno(jexnum(nom, iaux), no3)
            zk24(jadr+iaux-1) = no3
        enddo
    else if (ltyp .eq. 32) then
        do iaux = 1, lonma2
            call jenuno(jexnum(nom, iaux), no4)
            zk32(jadr+iaux-1) = no4
        enddo
    else if (ltyp .eq. 80) then
        do iaux = 1, lonma2
            call jenuno(jexnum(nom, iaux), no5)
            zk80(jadr+iaux-1) = no5
        enddo
    else
        ASSERT(.false.)
    endif
!
    call jedetr(nom)
    call jecreo(nom, 'V N '//type)
    call jeecra(nom, 'NOMMAX', ival=long)
!
    if (ltyp .eq. 8) then
        do iaux = 1, lonma2
            call jecroc(jexnom(nom, zk8(jadr+iaux-1)))
        enddo
    else if (ltyp .eq. 16) then
        do iaux = 1, lonma2
            call jecroc(jexnom(nom, zk16(jadr+iaux-1)))
        enddo
    else if (ltyp .eq. 24) then
        do iaux = 1, lonma2
            call jecroc(jexnom(nom, zk24(jadr+iaux-1)))
        enddo
    else if (ltyp .eq. 32) then
        do iaux = 1, lonma2
            call jecroc(jexnom(nom, zk32(jadr+iaux-1)))
        enddo
    else if (ltyp .eq. 80) then
        do iaux = 1, lonma2
            call jecroc(jexnom(nom, zk80(jadr+iaux-1)))
        enddo
    endif
!
    call jedetr('&&JEAGRN.TMP')
    call jedema()
end subroutine
