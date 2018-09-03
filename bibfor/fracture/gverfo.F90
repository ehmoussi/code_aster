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

subroutine gverfo(cartei, ier)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=19) :: cartei
    integer :: ier
!
!     BUT : VERIFIE SI LE CHARGMENT FONCTION EST DE TYPE 'FORMULE'
!           ROUTINE APPELEE PAR GCHARG (OPERATEUR CALC_G)
!
!
!     IN :    cartei   : NOM DE LA CHARGE (ex: NOMCHA//'.CHME.F3D3D')
!
!     OUT:    IER     : =1 : PRESENCE D'UN CHARGMENT 'FORMULE'
!                       =0 : SINON
!
! ======================================================================
! ----------------------------------------------------------------------
    integer ::  nbvale, in
    character(len=19) :: nch19
    character(len=24), pointer :: prol(:) => null()
    character(len=8), pointer :: vale(:) => null()
!
    call jemarq()
!
    call jeveuo(cartei//'.VALE', 'L', vk8=vale)
    call jelira(cartei//'.VALE', 'LONMAX', nbvale)
!
    ier=0
    do 10 in = 1, nbvale
        if (vale(in)(1:7) .ne. '&FOZERO' .and. vale(in)(1:7) .ne. '       '&
            .and. vale(in)(1:6) .ne. 'GLOBAL') then
            nch19=vale(in)

            call jeveuo(nch19//'.PROL', 'L', vk24=prol)
            if (prol(1)(1:8) .eq. 'INTERPRE') then
                ier=1
                goto 999
            endif
        endif
10  continue
!
999 continue
!
    call jedema()
!
end subroutine
