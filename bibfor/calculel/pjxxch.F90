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

subroutine pjxxch(correz, ch1z, ch2z, tychv, prfchz,&
                  prol0, ligrez, base, iret)
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/pjefch.h"
#include "asterfort/pjngch.h"
    character(len=*) :: correz, ch1z, ch2z, prfchz, ligrez
! person_in_charge: jacques.pellet at edf.fr
!-------------------------------------------------------------------
!     BUT : PROJETER UN CHAMP "CH1" SUIVANT "CORRES"
!           POUR CREER "CH2" SUR LA BASE "BASE"
!-------------------------------------------------------------------
!  IRET (OUT)  : = 0    : OK
!                = 1    : PB : ON N' A PAS PU PROJETER LE CHAMP
!                = 10   : ON NE SAIT PAS ENCORE FAIRE
!-------------------------------------------------------------------
    character(len=19) :: ch1, ch2, prfchn, ligrel
    character(len=16) :: corres, method
    character(len=1) :: base
!     TYCHV = NOEU OU ' ', SI TYCHV = NOEU CH2Z SERA UN CHAM_NO
    character(len=4) :: tychv
    character(len=*) :: prol0
    integer :: iret
    character(len=24), pointer :: pjxx_k1(:) => null()
!
!
    call jemarq()
    corres=correz
    ch1=ch1z
    ch2=ch2z
    prfchn=prfchz
    ligrel=ligrez
!
!
!     -- GLUTE MODIFICATION STRUCTURALE : (SI CORRES=' ')
    if (corres .ne. ' ') then
        call jeveuo(corres//'.PJXX_K1', 'L', vk24=pjxx_k1)
        method=pjxx_k1(3)
    else
        method='COLLOCATION'
    endif
!
!
    if (method .eq. 'COLLOCATION') then
        ASSERT(tychv.eq.' ' .or. tychv.eq.'NOEU')
        call pjefch(corres, ch1, ch2, tychv, prfchn,&
                    prol0, ligrel, base, iret)
!
    else if (method(1:10).eq.'NUAGE_DEG_') then
        call pjngch(ch1, ch2, corres)
        iret=0
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
