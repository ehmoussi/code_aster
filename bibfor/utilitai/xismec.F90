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

function xismec()
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
    aster_logical :: xismec
!
! BUT : POST_CHAM_XFEM : LE RESULTAT A POST-TRAITER EST-IL MECANIQUE?
!
! OUT XISMEC : VRAI SI LE RESULTAT A POST-TRAITER EST UN RESU MECANIQUE
!              FAUX SINON (ON VERIFIE ALORS QUE CE RESU EST THERMIQUE)
!
!-----------------------------------------------------------------------
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=16) :: k16tmp
    character(len=24) :: licham
    integer :: jlicha
    aster_logical :: lmeca
!-----------------------------------------------------------------------
!
    call jemarq()
!
    licham = '&&OP0196.LICHAM'
    call jeveuo(licham, 'L', jlicha)
    k16tmp = zk16(jlicha-1+1)
!
    if (k16tmp .eq. 'DEPL') then
        lmeca=.true.
    else if (k16tmp.eq.'TEMP') then
        lmeca = .false.
    else
        ASSERT(.false.)
    endif
!
    xismec=lmeca
!
    call jedema()
end function
