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

function digdel(modelo)
    implicit none
    integer :: digdel
!
! person_in_charge: jacques.pellet at edf.fr
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    integer :: modelo
! ----------------------------------------------------------------------
!     ENTREES:
!        MODELO : MODE_LOCAL (SON INDICE DANS &CATA.TE.MODELOC )
!
!     SORTIES:
!        DIGDEL : NOMBRE DE SCALAIRES REPRESENTANT LA GRANDEUR POUR LE
!                 MODE_LOCAL
!
! ----------------------------------------------------------------------
!
!     FONCTIONS EXTERNES:
!     -------------------
!
!     VARIABLES LOCALES:
!     ------------------
    integer :: modloc
!
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    call jeveuo(jexnum('&CATA.TE.MODELOC', modelo), 'L', modloc)
    digdel = zi(modloc-1+3)
    call jedema()
end function
