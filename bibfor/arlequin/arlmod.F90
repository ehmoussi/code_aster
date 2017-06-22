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

subroutine arlmod(nomo,mailar,modarl,tabcor)


    implicit none

#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/exisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/arlmol.h"
#include "asterfort/arlmom.h"
#include "asterfort/jedema.h"

!     ARGUMENTS:
!     ----------
    character(len=8) :: mailar,modarl,nomo
    character(len=24) :: tabcor
    integer :: iret

! ----------------------------------------------------------------------

! ROUTINE ARLEQUIN

! CREATION DU PSEUDO-MODELE

! ----------------------------------------------------------------------


! IN  MAIL   : NOM DU MAILLAGE
! IN  NOMO   : NOM DU MODELE
! IN  MAILAR : NOM DU PSEUDO-MAILLAGE
! IN  TABCOR : TABLEAU DE CORRESPONDANCE
!            POUR CHAQUE NOUVEAU NUMERO ABSOLU DANS MAILAR
!             -> ANCIEN NUMERO ABSOLU DANS MAIL
! OUT MODARL : NOM DU PSEUDO-MODELE

! ----------------------------------------------------------------------

    call jemarq()

! --- NOM SD TEMPORAIRE

    modarl = '&&ARL.MO'

! --- DESTRUCTION DU PSEUDO-MODELE S'IL EXISTE

    call exisd('MODELE', modarl, iret)
    if (iret .ne. 0) then
       call detrsd('MODELE',modarl)
    endif

! --- CREATION DU LIGREL DU PSEUDO-MODELE

    call arlmol(nomo,mailar,modarl,tabcor)

! --- CREATION DU PSEUDO-MODELE

    call arlmom(mailar,modarl)

    call jedema()

end subroutine
