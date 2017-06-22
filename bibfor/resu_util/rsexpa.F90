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

subroutine rsexpa(resu, icode, nompar, iret)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsnopa.h"
    integer :: icode, iret
    character(len=*) :: resu, nompar
! ----------------------------------------------------------------------
! person_in_charge: jacques.pellet at edf.fr
!      VERIFICATION DE L'EXISTANCE D'UN NOM DE PARAMETRE OU DE
!      VARIABLE D'ACCES DANS UN RESULTAT COMPOSE
! ----------------------------------------------------------------------
! IN  : RESU  : NOM DE LA SD_RESULTAT
! IN  : NOMPAR : NOM SYMBOLIQUE DU PARAMETRE OU VARIABLE D'ACCES DONT
!                ON DESIRE VERIFIER L'EXISTANCE
! IN  : ICODE  : CODE = 0 : VARIABLE D'ACCES
!                     = 1 : PARAMETRE
!                     = 2 : VARIABLE D'ACCES OU PARAMETRE
! OUT : IRET   : = 0  LE NOM SYMBOLIQUE N'EXISTE PAS
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    integer :: nbac, nbpa
!
!-----------------------------------------------------------------------
    integer :: ipa, ire1
    character(len=16), pointer :: nom_par(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    iret=0
!
    call rsnopa(resu, icode, '&&RSEXPA.NOM_PAR', nbac, nbpa)
    call jeexin('&&RSEXPA.NOM_PAR', ire1)
    if (ire1 .gt. 0) call jeveuo('&&RSEXPA.NOM_PAR', 'E', vk16=nom_par)
    if ((nbac+nbpa) .ne. 0) then
        do 10 ipa = 1, nbac+nbpa
            if (nompar .eq. nom_par(ipa)) then
                iret=100
            endif
10      continue
    endif
!
    call jedetr('&&RSEXPA.NOM_PAR')
!
    call jedema()
end subroutine
