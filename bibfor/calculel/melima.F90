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

subroutine melima(chin, ma, icode, ient, lima,&
                  nb)
!
    implicit none
!
! ----------------------------------------------------------------------
!     RETOURNE LE NOMBRE DE MAILLE D'1 GROUPE AFFECTE D'1 CARTE
!            AINSI QUE L'ADRESSE DU DEDEBUT DE LA LISTE DANS ZI.
! ----------------------------------------------------------------------
!
!
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    character(len=8) :: ma
    character(len=19) :: chin
    integer :: icode, ient, lima, nb
! ----------------------------------------------------------------------
!     ENTREES:
!     CHIN : NOM D'1 CARTE
!     MA   : NOM DU MAILLAGE SUPPORT DE LA CARTE.
!     IENT : NUMERO DE L'ENTITE AFFECTE PAR LA GRANDEUR
!             IENT = NUMERO DU GROUPE_MA SI CODE=2
!             IENT = NUMERO DE LA GRANDEUR EDITEE SI CODE = 3 OU -3
!     ICODE :  2  OU -3 OU 3
!
!     SORTIES:
!     NB   : NOMBRE DE MAILLES DANS LA LISTE.
!     LIMA : ADRESSE DANS ZI DE LA LISTE DES NUMEROS DE MAILLES.
!
! ----------------------------------------------------------------------
!
!     FONCTIONS EXTERNES:
!     -------------------
!
!     VARIABLES LOCALES:
!     ------------------
!
!
!     TRAITE LES 2 CAS :  - GROUPE NOMME DU MAILLAGE MA
!                         - GROUPE TARDIF DE LA CARTE CHIN
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (icode .eq. 2) then
!
!        GROUPE DE MAILLES DU MAILLAGE:
        call jelira(jexnum(ma//'.GROUPEMA', ient), 'LONUTI', nb)
        call jeveuo(jexnum(ma//'.GROUPEMA', ient), 'L', lima)
    else if (abs(icode).eq.3) then
!
!        GROUPE TARDIF :
        call jelira(jexnum(chin(1:19)//'.LIMA', ient), 'LONMAX', nb)
        call jeveuo(jexnum(chin(1:19)//'.LIMA', ient), 'L', lima)
    else
        ASSERT(.false.)
    endif
end subroutine
