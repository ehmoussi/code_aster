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

subroutine utimob(unit, obin, nivo, lattr, lcont,&
                  xous)
    implicit none
!     --
!     ARGUMENTS:
!     ----------
#include "asterf_types.h"
#include "asterfort/utimco.h"
#include "asterfort/utimos.h"
#include "asterfort/utmess.h"
    character(len=*) :: obin, xous
    integer :: nivo, unit
    aster_logical :: lattr, lcont
! ----------------------------------------------------------------------
!     IN:
!       UNIT   : UNITE LOGIQUE D'IMPRESSION
!       OBIN   : NOM D'UN OBJET JEVEUX (K24) A IMPRIMER
!       NIVO   : NIVEAU D'IMPRESSION
!      LATTR   : VRAI : ON IMPRIME LES ATTRIBUTS
!              : FAUX : ON N'IMPRIME PAS LES ATTRIBUTS
!      LCONT   : VRAI : ON IMPRIME LE CONTENU DES OBJETS
!              : FAUX : ON N'IMPRIME PAS LE CONTENU DES OBJETS
!       XOUS   : 'X' : COLLECTION ; 'S' : OBJET SIMPLE
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    character(len=1) :: xous2
    character(len=24) :: ob1
    character(len=40) :: lb
! DEB-------------------------------------------------------------------
!
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    ob1 = obin
    xous2=xous
    lb='----------------------------------------'
    write(unit,'(A40,A40)') lb,lb
!
    if (xous2 .eq. 'X') then
        call utimco(unit, ob1, nivo, lattr, lcont)
    else if (xous2 .eq.'S') then
        call utimos(unit, ob1, lattr, lcont)
    else
!
        call utmess('F', 'UTILITAI5_41', sk=xous2)
    endif
!
end subroutine
