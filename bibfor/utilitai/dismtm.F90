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

subroutine dismtm(questi, nomobz, repi, repkz, ierd)
    implicit none
!     --     DISMOI(TYPE_MAILLE)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    integer :: repi, ierd
    character(len=*) :: questi
    character(len=*) :: nomobz, repkz
    character(len=32) :: repk
    character(len=8) :: nomob

! ----------------------------------------------------------------------
!    IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOBZ : NOM D'UN OBJET DE TYPE TYPE_MAILLE (K8)
!    OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    integer :: itm, ianbno
!
!
!
    call jemarq()
    nomob = nomobz
    repk = ' '
    repi = 0
    ierd = 0
    call jenonu(jexnom('&CATA.TM.NOMTM', nomob), itm)
    if (itm .eq. 0) then
        call utmess('F', 'UTILITAI_70')
    endif
!
!
    if (questi .eq. 'NUM_TYPMAIL') then
!     ----------------------------------
        repi = itm
!
!
    else if (questi.eq.'NBNO_TYPMAIL') then
!     ----------------------------------
        call jeveuo(jexnum('&CATA.TM.NBNO', itm), 'L', ianbno)
        repi = zi(ianbno)
!
!
    else if (questi.eq.'DIM_TOPO') then
!     ----------------------------------
        call jeveuo(jexnum('&CATA.TM.TMDIM', itm), 'L', ianbno)
        repi = zi(ianbno)
!
!
    else if (questi.eq.'TYPE_TYPMAIL') then
!     ----------------------------------
        call jeveuo(jexnum('&CATA.TM.TMDIM', itm), 'L', ianbno)
        repi = zi(ianbno)
        if (repi .eq. 0) then
            repk = 'POIN'
        else if (repi.eq.1) then
            repk = 'LIGN'
        else if (repi.eq.2) then
            repk = 'SURF'
        else if (repi.eq.3) then
            repk = 'VOLU'
        else
            ASSERT(.false.)
        endif
!
!
    else
        ierd = 1
    endif
!
    repkz = repk
    call jedema()
end subroutine
