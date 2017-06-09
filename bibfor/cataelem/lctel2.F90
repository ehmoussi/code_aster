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

subroutine lctel2()
!     BUT : AJOUTER AUX OBJETS RESULTANTS DE LA LECTURE DES CATALOGUES
!      L'OBJET '&CATA.TE.TAILLMAX'   S V I
!           V(I_TE) : NOMBRE MAXI DE TERMES DANS UNE MATRICE ELEMENTAIRE
!                     POUR L'ELEMENT I_TE
!      L'OBJET '&CATA.TE.NBLIGCOL'
!      L'OBJET '&CATA.TE.OPTTE'
!
! ----------------------------------------------------------------------
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
    character(len=24) :: nomolo
    character(len=16) :: nomte
    integer :: nbte, nbop, nbgd, iatamx, nbmolo, imolo, jnblig, iamolo
    integer :: n, ioptte, iop, ite, joptte
    integer, pointer :: optt2(:) => null()
!
    call jemarq()
!
    call jelira('&CATA.TE.NOMTE', 'NOMMAX', nbte)
    call jelira('&CATA.OP.NOMOPT', 'NOMMAX', nbop)
    call jelira('&CATA.GD.NOMGD', 'NOMMAX', nbgd)
    call jelira('&CATA.TE.NOMMOLOC', 'NOMMAX', nbmolo)
!
!
!
!
!     OBJET .TAILLMAX :
!     -------------------
    call wkvect('&CATA.TE.TAILLMAX', 'G V I', nbte, iatamx)
    do 1, imolo=1,nbmolo
    call jeveuo(jexnum('&CATA.TE.MODELOC', imolo), 'L', iamolo)
    if (zi(iamolo-1+1) .eq. 5) then
        call jenuno(jexnum('&CATA.TE.NOMMOLOC', imolo), nomolo)
        nomte= nomolo(1:16)
        call jenonu(jexnom('&CATA.TE.NOMTE', nomte), ite)
        zi(iatamx-1+ite)=max(zi(iatamx-1+ite),zi(iamolo-1+3))
    endif
    1 end do
!
!
!     OBJET .NBLIGCOL :
!     -------------------
    call wkvect('&CATA.TE.NBLIGCOL', 'G V I', 6, jnblig)
    zi(jnblig-1+1)=nbop
    zi(jnblig-1+2)=nbte
    zi(jnblig-1+3)=nbte
    zi(jnblig-1+4)=nbgd
    zi(jnblig-1+5)=nbte
    zi(jnblig-1+6)=nbgd
!
!
!     OBJET .OPTTE :
!     -------------------
    call jeveuo('&CATA.TE.OPTT2', 'L', vi=optt2)
    call jelira('&CATA.TE.OPTT2', 'LONMAX', n)
    call wkvect('&CATA.TE.OPTTE', 'G V I', nbte*nbop, joptte)
    do 2,ioptte=1,n/2
    iop=optt2(2*(ioptte-1)+1)
    ite=optt2(2*(ioptte-1)+2)
    if (iop .eq. 0 .or. ite .eq. 0) goto 2
    zi(joptte-1+(ite-1)*nbop+iop)=ioptte
    2 end do
    call jedetr('&CATA.TE.OPTT2')
!
!
!
    call jedema()
end subroutine
