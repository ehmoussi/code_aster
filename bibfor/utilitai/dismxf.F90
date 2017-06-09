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

subroutine dismxf(questi, nomobz, repi, repkz, ierd)
    implicit none
! person_in_charge: samuel.geniaut at edf.fr
!
!     --     DISMOI(XFEM)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: repi, ierd
    character(len=*) :: questi, nomobz, repkz
    character(len=32) :: repk
    character(len=8) :: nomob
! ----------------------------------------------------------------------
!     IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOB  : NOM D'UN OBJET DE TYPE SD_FISS_XFEM
!     OUT:
!       REPI   : REPONSE ( SI ENTIER )
!       REPK   : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD    : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    integer :: jinfo,  long
    character(len=8), pointer :: mailla(:) => null()
!
!
    call jemarq()
    nomob=nomobz
    repk=' '
    ierd = 0
!
    if (questi .eq. 'TYPE_DISCONTINUITE') then
!
        call jeveuo(nomob//'.INFO', 'L', jinfo)
        repk = zk16(jinfo-1+1)
!
    else if (questi.eq.'CHAM_DISCONTINUITE') then
!
        call jeveuo(nomob//'.INFO', 'L', jinfo)
        repk = zk16(jinfo-1+2)
!
    else if (questi.eq.'TYPE_FOND') then
!
        call jeveuo(nomob//'.INFO', 'L', jinfo)
        repk = zk16(jinfo-1+3)
!
    else if (questi.eq.'NOM_MAILLA') then
!
        call jeveuo(nomob//'.MAILLAGE', 'L', vk8=mailla)
        repk = mailla(1)
!
    else if (questi.eq.'NB_FOND') then
!
        call jelira(nomob//'.FONDMULT', 'LONMAX', long)
        repi = long/2
!
    else if (questi.eq.'NB_POINT_FOND') then
!
        call jelira(nomob//'.FONDFISS', 'LONMAX', long)
        repi = long/4
!
    else
!
        ierd=1
!
    endif
!
    repkz = repk
    call jedema()
end subroutine
