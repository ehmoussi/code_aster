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

function lisexi(prefob, indxch)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/lisdef.h"
    aster_logical :: lisexi
    character(len=13) :: prefob
    integer :: indxch
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! RETOURNE TRUE SI LE CHARGEMENT EXISTE
!
! ----------------------------------------------------------------------
!
!
! IN  PREFOB : PREFIXE DE LA CHARGE
! IN  INDXCH : INDEX DE LA CHARGE
!
!
!
!
    character(len=24) :: nomobj
    integer :: itypob(2)
    character(len=19) :: carte
    integer :: iret
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    lisexi = .false.
!
! --- RECUPERATION OBJET LIE A CETTE CHARGE
!
    call lisdef('OBJE', prefob, indxch, nomobj, itypob)
!
! --- VERIFICATION EXISTENCE
!
    if (itypob(1) .eq. 1) then
        carte = nomobj(1:19)
        call exisd('CARTE', carte, iret)
        if (iret .eq. 1) lisexi = .true.
    else if (itypob(1) .eq. 0) then
        call jeexin(nomobj, iret)
        if (iret .ne. 0) lisexi = .true.
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end function
