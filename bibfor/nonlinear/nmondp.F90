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

subroutine nmondp(lischa, londe, chondp, nondp)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterc/getfac.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
    integer :: nondp
    character(len=24) :: chondp
    character(len=19) :: lischa
    aster_logical :: londe
!
!
!
!
    integer :: jinf, ialich, nchar, ich, iondp, nond
    character(len=24) :: infoch, charge
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    londe = .false.
    infoch = lischa(1:19)//'.INFC'
    charge = lischa(1:19)//'.LCHA'
    nondp = 0
    call jeveuo(infoch, 'L', jinf)
    call jeveuo(charge, 'L', ialich)
    call getfac('EXCIT', nchar)
    do 30 ich = 1, nchar
        if (zi(jinf+nchar+ich) .eq. 6) then
            nondp = nondp + 1
        endif
 30 end do
!
! --- RECUPERATION DES DONNEES DE CHARGEMENT PAR ONDE PLANE
    chondp = '&&NMONDP.ONDP'
    if (nondp .eq. 0) then
        call wkvect(chondp, 'V V K8', 1, iondp)
    else
        londe = .true.
        call wkvect(chondp, 'V V K8', nondp, iondp)
        nond = 0
        do 40 ich = 1, nchar
            if (zi(jinf+nchar+ich) .eq. 6) then
                nond = nond + 1
                zk8(iondp+nond-1) = zk24(ialich+ich-1)
            endif
 40     continue
    endif
    call jedema()
end subroutine
