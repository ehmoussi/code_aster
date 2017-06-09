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

subroutine stbast(nfie, nfis, lgrcou)
! aslint: disable=
    implicit none
#include "asterf_types.h"
#include "asterfort/presup.h"
#include "asterfort/uldefi.h"
#include "asterfort/ulisop.h"
#include "asterfort/ulopen.h"
    integer :: nfie, nfis
    aster_logical :: lgrcou
!
!      FONCTION : LANCEMENT DE L'INTERFACE IDEAS (SUPERTAB)
!
! ======================================================================
!
    character(len=16) :: k16nom
!
    if (ulisop ( nfie, k16nom ) .eq. 0) then
        call ulopen(nfie, ' ', 'IDEAS', 'NEW', 'O')
    else
!       TANT QU'IL Y AURA DES IUNIFI...
        call uldefi(nfie, ' ', 'IDEAS', 'L', 'NEW',&
                    'O')
    endif
    if (ulisop ( nfis, k16nom ) .eq. 0) then
        call ulopen(nfis, ' ', 'FICHIER-MODELE', 'NEW', 'O')
    endif
!
    call presup(nfie, nfis, lgrcou)
!
    write(nfis,*) 'FIN'
    rewind nfis
!
    call uldefi(-nfie, ' ', ' ', ' ', ' ',&
                ' ')
    call uldefi(-nfis, ' ', ' ', ' ', ' ',&
                ' ')
end subroutine
