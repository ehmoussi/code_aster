! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine gtgrma(main, maax, nmgrma, lima, nbma)
!

    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jelira.h"
#include "asterfort/as_allocate.h"
#include "asterfort/utmess.h"

    character(len=8), intent(in) :: main, maax
    character(len=24), intent(in) :: nmgrma
    integer, pointer :: lima(:)
    integer, intent(out) :: nbma
! -------------------------------------------------------------------------------------------------
!   RECUPERATION DE LA LISTE DES NUMERO DE MAILLE DU GROUP NMGRMA
! -------------------------------------------------------------------------------------------------
!   MAIN est présent uniquement pour afficher le maillage donné par l'utilisateur dans le message
!   d'erreur
! -------------------------------------------------------------------------------------------------
    integer :: jgrma, inc, iret
    character(len=24) :: valk(2)
! -------------------------------------------------------------------------------------------------
    call jemarq()
!
    call jenonu(jexnom(main//'.GROUPEMA', nmgrma), iret)
    if (iret .eq. 0) then
        valk(1) = nmgrma
        valk(2) = main
        call utmess('F', 'MODELISA7_77', nk=2, valk=valk)
    endif
    
    call jelira(jexnom(maax//'.GROUPEMA', nmgrma),'LONUTI',nbma)
    call jeveuo(jexnom(maax//'.GROUPEMA', nmgrma),'L',jgrma)
    AS_ALLOCATE(vi=lima, size=nbma)
    do inc=1, nbma
        lima(inc)=zi(jgrma+inc-1)
    end do

!
    call jedema()
end subroutine
