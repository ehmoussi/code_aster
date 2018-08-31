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

subroutine cgcrio(resu, vecord)
    implicit none
!
#include "asterfort/assert.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/rsutnu.h"
    character(len=8) :: resu
    character(len=19) :: vecord
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : VERIFICATION DE LA COMPATIBILITE ENTRE EXCIT ET RESU
!
!  IN :
!     RESU   : MOT-CLE RESULTAT
!  OUT :
!     VECORD : VECTEUR DES NUME_ORDRE DU RESU
! ======================================================================
!
    integer :: ier, nbord
    real(kind=8) :: prec
    character(len=8) :: crit
!
    call jemarq()
!
    call getvr8(' ', 'PRECISION', scal=prec, nbret=ier)
    call getvtx(' ', 'CRITERE', scal=crit, nbret=ier)
!
    call rsutnu(resu, ' ', 0, vecord, nbord,&
                prec, crit, ier)
    ASSERT(ier.eq.0)
!
    call jedema()
!
end subroutine
