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

subroutine vtcopy(chin, chout, kstop, codret)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/vtcop1.h"
    character(len=*) :: chin, chout
    character(len=1) :: kstop
    integer :: codret
! person_in_charge: nicolas.sellenet at edf.fr
!     RECOPIE LES VALEURS DU CHAM_NO CHIN DANS LE CHAM_NO CHOUT
!     CETTE ROUTINE PERMET DE CHANGER LA NUMEROTATION D'UN CHAM_NO
!     SI KSTOP.EQ.' ' EN ENTREE ET QUE CODRET != 0 EN SORTIE, ALORS
!     DES COMPOSANTES DU CHAMP CHIN N'ONT PAS PU ETRE RECOPIEES ET
!     ONT ETE MISES A ZERO
!
!     PRECAUTIONS D'EMPLOI :
!     - LES CHAM_NOS DOIVENT EXISTER.
!     - LES DDLS DE "LAGRANGE" SONT MIS A ZERO DANS CHOUT.
!
!     ------------------------------------------------------------------
!
!
!
!
    character(len=19) :: ch1, ch2
!     ------------------------------------------------------------------
!
    call jemarq()
    ch1 = chin
    ch2 = chout
!
    call vtcop1(ch1, ch2, kstop, codret)
!
    call jedema()
end subroutine
