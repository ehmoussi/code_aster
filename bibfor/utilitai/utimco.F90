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

subroutine utimco(unit, obin, nivo, lattr, lcont)
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeimpa.h"
#include "asterfort/jeimpo.h"
#include "asterfort/jelira.h"
#include "asterfort/jeprat.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    character(len=*) :: obin
    integer :: nivo, unit
    aster_logical :: lattr, lcont
! ----------------------------------------------------------------------
!     IN:
!       UNIT   : UNITE LOGIQUE D'IMPRESSION
!       OBIN   : NOM D'UNE COLLECTION  JEVEUX (K24) A IMPRIMER
!       NIVO   : NIVEAU D'IMPRESSION
!      LATTR   : VRAI : ON IMPRIME LES ATTRIBUTS
!              : FAUX : ON N'IMPRIME PAS LES ATTRIBUTS
!      LCONT   : VRAI : ON IMPRIME LE CONTENU DES OBJETS
!              : FAUX : ON N'IMPRIME PAS LE CONTENU DES OBJETS
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    character(len=24) :: ob1
    character(len=50) :: acces
! DEB-------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: ioc, iret, nmaxoc
!-----------------------------------------------------------------------
    ob1 = obin
!
    call jeexin(ob1, iret)
    if (iret .le. 0) then
        call utmess('A', 'UTILITAI_99', sk=ob1)
        goto 999
    endif
!
    call jelira(ob1, 'NMAXOC', nmaxoc)
    call jelira(ob1, 'ACCES', cval=acces)
!
    write(unit,*)'IMPRESSION DE LA COLLECTION : ',ob1
!
    if (lattr) call jeimpa(unit, ob1, ' ')
    if ((lcont) .and. (acces(1:2).eq.'NO')) then
        call jeprat(unit, ob1, '$$NOM', 'REPERTOIRE DE NOMS DE LA COLLECTION :'//ob1)
    endif
!
!     -- BOUCLE SUR LES ELEMENTS DE LA COLLECTION :
!     ---------------------------------------------
    do ioc = 1, nmaxoc
        if ((nivo.eq.1) .and. (ioc.gt.10)) goto 999
        call jeexin(jexnum(ob1, ioc), iret)
        if (iret .eq. 0) goto 1
        if (lattr) then
            call jeimpa(unit, jexnum(ob1, ioc), ' ')
        endif
        if (lcont) then
            call jeimpo(unit, jexnum(ob1, ioc), ' ')
        endif
  1     continue
    end do
!
999 continue
end subroutine
