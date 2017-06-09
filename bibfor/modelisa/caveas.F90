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

subroutine caveas(chargz)
!.======================================================================
    implicit none
!
!       CAVEAS -- TRAITEMENT DU MOT CLE VECT_ASSE
!
!      TRAITEMENT DU MOT CLE VECT_ASSE DE AFFE_CHAR_MECA
!      CE MOT CLE PERMET DE SPECIFIER UN VECTEUR ASSEMBLE (UN CHAM_NO)
!      QUI SERVIRA DE SECOND MEMBRE DANS STAT_NON_LINE
!                                   OU   DYNA_NON_LINE
!
! -------------------------------------------------------
!  CHARGE        - IN    - K8   - : NOM DE LA SD CHARGE
!                - JXVAR -      -   LA  CHARGE EST ENRICHIE
!                                   DU VECTEUR ASSEMBLE DONT LE NOM
!                                   EST STOCKE DANS L'OBJET
!                                   CHAR//'CHME.VEASS'
! -------------------------------------------------------
!
!.========================= DEBUT DES DECLARATIONS ====================
!
! -----  ARGUMENTS
#include "jeveux.h"
#include "asterfort/chpver.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=*) :: chargz
! ------ VARIABLES LOCALES
    character(len=8) :: charge, vecass
    character(len=24) :: obj
!
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
!-----------------------------------------------------------------------
    integer :: idveas, ier, nvecas
!-----------------------------------------------------------------------
    call jemarq()
!
    call getvid(' ', 'VECT_ASSE', scal=vecass, nbret=nvecas)
    if (nvecas .eq. 0) goto 9999
!
    call chpver('F', vecass, 'NOEU', 'DEPL_R', ier)
!
    charge = chargz
    obj = charge//'.CHME.VEASS'
!
    call wkvect(obj, 'G V K8', 1, idveas)
    zk8(idveas) = vecass
!
9999  continue
!
    call jedema()
!.============================ FIN DE LA ROUTINE ======================
end subroutine
