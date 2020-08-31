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
subroutine rsGetOneModelFromResult(resultZ, nbStore, listStore, model)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/rsadpa.h"
!
character(len=*), intent(in) :: resultZ
integer, intent(in) :: nbStore, listStore(nbStore)
character(len=*), intent(out) :: model
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get model in results datastructure (must been unique !)
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  nbStore          : number of storing index
! In  listStore        : list of storing index
! Out model            : model (#PLUSIEURS si pas constant sur tout le résultat)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: modelRefe
    integer :: jvPara, numeStore, iStore
!
! --------------------------------------------------------------------------------------------------
!
    model     = ' '
    numeStore = listStore(1)
    call rsadpa(resultZ, 'L', 1, 'MODELE', numeStore, 0, sjv=jvPara)
    modelRefe = zk8(jvPara)

    do iStore = 2, nbStore
        numeStore = listStore(iStore)
        call rsadpa(resultZ, 'L', 1, 'MODELE', numeStore, 0, sjv=jvPara)
        model = zk8(jvPara)
        if (model .ne. modelRefe) then
            model = '#PLUSIEURS'
            goto 99
        endif
    end do
!
    model = modelRefe
!
 99 continue
!
end subroutine
