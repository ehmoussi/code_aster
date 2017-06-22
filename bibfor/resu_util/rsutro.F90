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

subroutine rsutro(nomsd, iordg, iordr, ierr)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: iordg, iordr, ierr
    character(len=*) :: nomsd
! person_in_charge: jacques.pellet at edf.fr
!      CORRESPONDANCE NUMERO D'ORDRE UTILISATEUR (IORDR) AVEC LE
!      NUMERO DE RANGEMENT (IORDG).
! ----------------------------------------------------------------------
! IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
! IN  : IORDG  : NUMERO DE RANGEMENT.
! OUT : IORDR  : NUMERO D'ORDRE UTILISATEUR.
! OUT : IERR   : CODE RETOUR
!                = 0  , LA RELATION EXISTE .
!                = 10 , LE .ORDR N'EST PAS REMPLI (SD RESULTAT VIDE)
!                = 20 , LE NUMERO DE RANGEMENT EST SUPERIEUR AU MAX
!                       AUTORISE
! ----------------------------------------------------------------------
    character(len=19) :: nomd2
! ----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer ::  nbordr
    integer, pointer :: ordr(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    ierr = 0
    nomd2 = nomsd
!
!     --- RECUPERATION DU .ORDR ---
    call jelira(nomd2//'.ORDR', 'LONUTI', nbordr)
    if (nbordr .eq. 0) then
        ierr = 10
    else if (iordg.gt.nbordr) then
        ierr = 20
    else
        call jeveuo(nomd2//'.ORDR', 'L', vi=ordr)
        iordr = ordr(iordg)
    endif
!
    call jedema()
end subroutine
