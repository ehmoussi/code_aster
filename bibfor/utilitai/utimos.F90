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

subroutine utimos(unit, obin, lattr, lcont)
    implicit none
!     --
!     ARGUMENTS:
!     ----------
#include "asterf_types.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeimpa.h"
#include "asterfort/jeimpo.h"
#include "asterfort/utmess.h"
    character(len=*) :: obin
    integer :: unit
    aster_logical :: lattr, lcont
! ----------------------------------------------------------------------
!     IN:
!       UNIT   : UNITE LOGIQUE D'IMPRESSION
!       OBIN   : NOM D'UN OBJET SIMPLE JEVEUX (K24) A IMPRIMER
!      LATTR   : VRAI : ON IMPRIME LES ATTRIBUTS
!              : FAUX : ON N'IMPRIME PAS LES ATTRIBUTS
!      LCONT   : VRAI : ON IMPRIME LE CONTENU DES OBJETS
!              : FAUX : ON N'IMPRIME PAS LE CONTENU DES OBJETS
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    character(len=24) :: ob1
! DEB-------------------------------------------------------------------
!
!
!-----------------------------------------------------------------------
    integer :: iret
!-----------------------------------------------------------------------
    ob1 = obin
!
    call jeexin(ob1, iret)
    if (iret .le. 0) then
        call utmess('A', 'UTILITAI_99', sk=ob1)
        goto 9999
    endif
!
    if (lattr) then
        call jeimpa(unit, ob1, ' ')
    endif
!
    if (lcont) then
        call jeimpo(unit, ob1, ' ')
    endif
!
9999 continue
end subroutine
