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

subroutine gicnx2()
    implicit none
!
! ----------------------------------------------------------------------
!     BUT : CREER  L'OBJET &&GILIRE.CONNEX2
!           QUI DONNE LA CONNECTIVITE DE TOUTES LES MAILLES LUES.
!
! ----------------------------------------------------------------------
!
!     FONCTIONS EXTERNES:
!     -------------------
!
!     VARIABLES LOCALES:
!     ------------------
!
#include "jeveux.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    character(len=8) :: nomobj
!
!-----------------------------------------------------------------------
    integer :: i,  iacnx2,   ima, imat
    integer :: ino, iret, lont, nbel, nbmato, nbno, nbobj
    integer :: nbobj4
    integer, pointer :: descobj(:) => null()
    character(len=8), pointer :: vnomobj(:) => null()
    integer, pointer :: connex(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    call jeexin('&&GILIRE.NOMOBJ', iret)
    if (iret .eq. 0) then
        call utmess('F', 'PREPOST_46')
    endif
    call jeveuo('&&GILIRE.NOMOBJ', 'L', vk8=vnomobj)
!
!     -- RECUPERATION DU NOMBRE D'OBJETS LUS:
    call jelira('&&GILIRE.DESCOBJ', 'LONMAX', nbobj4)
    call jeveuo('&&GILIRE.DESCOBJ', 'L', vi=descobj)
    nbobj = nbobj4/4
!
!     -- CALCUL DES DIMENSIONS DE L'OBJET .CONNEX2:
    nbmato=0
    lont  =0
    do 1 i = 1, nbobj
        if (descobj(4*(i-1)+1) .ne. 0) goto 1
        nbno=descobj(4*(i-1)+3)
        nbel=descobj(4*(i-1)+4)
        nbmato=nbmato+nbel
        lont= lont+nbel*nbno
 1  end do
!
!     -- CREATION DE L'OBJET .CONNEX2:
    call jecrec('&&GILIRE.CONNEX2', 'V V I', 'NU', 'CONTIG', 'VARIABLE',&
                nbmato)
    call jeecra('&&GILIRE.CONNEX2', 'LONT', lont)
    imat=0
    do 2 i = 1, nbobj
        if (descobj(4*(i-1)+1) .ne. 0) goto 2
        nbno=descobj(4*(i-1)+3)
        nbel=descobj(4*(i-1)+4)
        nomobj=vnomobj(2*(i-1)+1)
        if (nbel .eq. 0) goto 2
        call jeveuo('&&GILIRE'//nomobj//'.CONNEX', 'L', vi=connex)
        do 3 ima = 1, nbel
            imat = imat +1
            call jecroc(jexnum('&&GILIRE.CONNEX2', imat))
            call jeecra(jexnum('&&GILIRE.CONNEX2', imat), 'LONMAX', nbno)
            call jeveuo(jexnum('&&GILIRE.CONNEX2', imat), 'E', iacnx2)
            do 4 ino = 1, nbno
                zi(iacnx2-1+ino)=connex(nbno*(ima-1)+ino)
 4          continue
 3      continue
 2  end do
!
    call jedema()
end subroutine
