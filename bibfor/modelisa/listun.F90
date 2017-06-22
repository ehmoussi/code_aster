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

subroutine listun(noma, motfac, nzocu, nopono, nnocu,&
                  nolino)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/exnode.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nbnode.h"
    character(len=8) :: noma
    character(len=16) :: motfac
    integer :: nzocu
    character(len=24) :: nopono, nolino
    integer :: nnocu
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (LIAISON_UNILATERALE - LECTURE)
!
! STOCKAGE DES NOEUDS
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  MOTFAC : MOT_CLEF FACTEUR POUR LIAISON UNILATERALE
! IN  NZOCU  : NOMBRE DE ZONES DE LIAISON_UNILATERALE
! OUT NOPONO : NOM DE L'OBJET JEVEUX CONTENANT LE VECTEUR D'INDIRECTION
! OUT NOLINO : NOM DE L'OBJET JEVEUX CONTENANT LA LISTE DES NOEUDS
! OUT NNOCU  : NOMBRE DE TOTAL DE NOEUDS POUR TOUTES LES OCCURRENCES
!
!
!
!
!
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- COMPTE DES NOEUDS
!
    call nbnode(noma, motfac, nzocu, nopono, nnocu)
!
! --- LECTURE DES NOEUDS
!
    call exnode(noma, motfac, nzocu, nnocu, nolino)
!
    call jedema()
end subroutine
