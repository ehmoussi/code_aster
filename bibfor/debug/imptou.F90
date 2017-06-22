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

subroutine imptou(base, tous, mess)
    implicit none
#include "jeveux.h"
!
#include "asterfort/dbgobj.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelstc.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
    character(len=*) :: base, tous, mess
! BUT : IMPRIMER LA SIGNATURE DE TOUS LES OBJETS PRESENTS SUR UNE BASE.
!
! BASE   IN  K1 : NOM DE LA BASE : 'G'/'V'/'L'/' '
! TOUS   IN  K3 :  / 'ALL' : ON IMPRIME TOUS LES OBJEST TROUVES
!                  / 'NEW' : ON N'IMPRIME QU ELES OBJETS "NOUVEAUX"
!                            (DEPUIS LE DERNIER APPEL A IMPTOU)
! MESS   IN  K* :  MESSAGE PREFIXANT CHAQUE LIGNE
! ----------------------------------------------------------------------
    character(len=1) :: bas1
    character(len=8) :: kbid
    character(len=24) :: obj, dejavu
    integer :: i, iret, nbval, nbobj
    integer :: nuobj
    character(len=24), pointer :: liste(:) => null()
!
    call jemarq()
!     GOTO 9999
    bas1=base
!
!
!     1. LA PREMIERE FOIS ON ALLOUE UN POINTEUR DE NOMS QUI CONTIENDRA
!        TOUS LES OBJETS DEJA IMPRIMES UNE FOIS : '&&IMPTOU.DEJAVU'
!     --------------------------------------------------------------
    dejavu='&&IMPTOU.DEJAVU'
    call jeexin(dejavu, iret)
    if (iret .eq. 0) then
        call jecreo(dejavu, 'G N K24')
        call jeecra(dejavu, 'NOMMAX', 90000)
    endif
!
!
!
!     2. RECUPERATION DE LA LISTE DES OBJETS :
!     --------------------------------------------------------------
    call jelstc(bas1, ' ', 0, 0, kbid,&
                nbval)
    nbobj = -nbval
!     -- ON AUGMENTE NBOBJ DE 1 CAR ON VA CREER UN OBJET DE PLUS !
    nbobj = nbobj+1
    AS_ALLOCATE(vk24=liste, size=nbobj)
    call jelstc(bas1, ' ', 0, nbobj, liste,&
                nbval)
!
!
!     3. IMPRESSION DE LA SIGNATURE DES OBJETS :
!     --------------------------------------------------------------
    do 10 i = 1, nbobj
        obj = liste(i)
        call jenonu(jexnom(dejavu, obj), nuobj)
        if (nuobj .eq. 0) call jecroc(jexnom(dejavu, obj))
!
        if ((nuobj.gt.0) .and. (tous.eq.'NEW')) goto 10
!
        call dbgobj(obj, 'OUI', 6, mess)
10  end do
!
!
!     4. MENAGE
!     --------------------------------------------------------------
    AS_DEALLOCATE(vk24=liste)
!
    call jedema()
!
end subroutine
