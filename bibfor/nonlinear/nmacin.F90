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

subroutine nmacin(fonact, matass, deppla, cncind)
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmpcin.h"
    integer :: fonact(*)
    character(len=19) :: matass, deppla, cncind
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE
!
! BUT : ACTUALISER LES CHARGES CINEMATIQUES DE FACON A CALCULER
!       UNE CORRECTION PAR RAPPORT AU DEPLACEMENT COURANT (DEPPLA)
!
! ----------------------------------------------------------------------
!
!
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  MATASS : SD MATRICE ASSEMBLEE
! IN  DEPPLA : DEPLACEMENT COURANT
! OUT CNCIND : CHAMP DES INCONNUES CINEMATIQUES CORRIGE PAR DEPPLA
!
!
!
!
!
    integer :: neq, i
    aster_logical :: lcine
    integer, pointer :: ccid(:) => null()
    real(kind=8), pointer :: cind(:) => null()
    real(kind=8), pointer :: depla(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- FONCTIONNALITES ACTIVEES
!
    lcine = isfonc(fonact,'DIRI_CINE')
!
    if (lcine) then
        call jelira(cncind(1:19)//'.VALE', 'LONMAX', ival=neq)
        call nmpcin(matass)
        call jeveuo(matass(1:19)//'.CCID', 'L', vi=ccid)
        call jeveuo(deppla(1:19)//'.VALE', 'L', vr=depla)
        call jeveuo(cncind(1:19)//'.VALE', 'E', vr=cind)
!
! ---   CONSTRUCTION DU CHAMP CNCINE QUI RENDRA
! ---   DEPPLA CINEMATIQUEMENT ADMISSIBLE
!
        do 10 i = 1, neq
            if (ccid(i) .eq. 1) then
                cind(i) = cind(i)-depla(i)
            endif
 10     continue
!
    endif
!
    call jedema()
end subroutine
