! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
subroutine rsGetOneBehaviourFromResult(resultZ, nbStore, listStore, compor)
!
implicit none
!
#include "asterfort/carcomp.h"
#include "asterfort/rsexch.h"
!
character(len=*), intent(in) :: resultZ
integer, intent(in) :: nbStore, listStore(nbStore)
character(len=*), intent(out) :: compor
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get behaviour in results datastructure (must been unique !)
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  nbStore          : number of storing index
! In  listStore        : list of storing index
! Out compor           : behaviour (#PLUSIEURS si pas constant sur tout le résultat)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: comporRefe, comporRead
    integer :: numeStore, iStore, icode, iret
!
! --------------------------------------------------------------------------------------------------
!
    compor    = ' '
    numeStore = listStore(1)

    call rsexch(' ', resultZ, 'COMPORTEMENT', numeStore, comporRefe, icode)
    if (icode .ne. 0) then
        compor = '#SANS'
        goto 99
    endif
    do iStore = 2, nbStore
        numeStore = listStore(iStore)
        call rsexch(' ', resultZ, 'COMPORTEMENT', numeStore, comporRead, icode)
        if (icode .ne. 0) then
            compor = '#SANS'
            goto 99
        endif
        call carcomp(comporRead, comporRefe, iret)
        if (iret .eq. 1) then
            compor = '#PLUSIEURS'
            goto 99
        endif
    end do
!
    compor = comporRefe
!
 99 continue
!
end subroutine
