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

subroutine op0057()
    implicit none
!
! person_in_charge: sebastien.fayolle at edf.fr
!.......................................................................
!       OPERATEUR DEFI_GLRC
!       DETERMINE LES PARAMETRES HOMOGENEISEES DES LOIS GLRC_DAMAGE
!       ET GLRC_DM A PARTIR DES PROPRIETES DU BETON ET DES COUCHES
!       D ACIER
!-----------------------------------------------------------------------
#include "asterfort/assert.h"
#include "asterfort/dglrda.h"
#include "asterfort/dglrdm.h"
#include "asterfort/getvtx.h"
    integer :: ibid
    character(len=16) :: relat
!
    call getvtx(' ', 'RELATION', scal=relat, nbret=ibid)
!
    if (relat(1:11) .eq. 'GLRC_DAMAGE') then
        call dglrda()
    else if (relat(1:7) .eq. 'GLRC_DM') then
        call dglrdm()
    else
        ASSERT(.false.)
    endif
!
end subroutine
