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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romTableSave(tablResu   , nbMode   , v_gamma   ,&
                        numeStore_, timeCurr_, numeSnap_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/tbajli.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(NL_DS_TableIO), intent(in) :: tablResu
integer, intent(in) :: nbMode
real(kind=8), pointer :: v_gamma(:)
integer, optional, intent(in) :: numeStore_
real(kind=8), optional, intent(in) :: timeCurr_
integer, optional, intent(in) :: numeSnap_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Save table for the reduced coordinates
!
! --------------------------------------------------------------------------------------------------
!
! In  tablResu         : datastructure for table of reduced coordinates in result datastructure
! In  nbMode          : number of empiric modes
! In  v_gamma          : pointer to reduced coordinates
! In  numeStore       : index to store in results
! In  timeCurr        : current time
! In  numeSnap        : index of snapshot
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iMode, valInte(3), numeSnap, numeStore
    real(kind=8) :: valReal(2), timeCurr
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Initializations
!
    numeSnap  = 1
    if (present(numeSnap_)) then
        numeSnap = numeSnap_
    endif
    numeStore = 0
    if (present(numeStore_)) then
        numeStore = numeStore_
    endif
    timeCurr  = 0.d0
    if (present(timeCurr_)) then
        timeCurr = timeCurr_
    endif
    valInte(2) = numeStore
    valInte(3) = numeSnap
    valReal(2) = timeCurr
!
! - Debug
!
    if (niv .ge. 2) then
        if (present(timeCurr_)) then
            call utmess('I', 'ROM15_4', ni = 2, vali = [numeStore, nbMode], sr = timeCurr)
        else
            call utmess('I', 'ROM15_3', ni = 2, vali = [numeSnap, nbMode])
        endif
    endif
!
! - Save in table
!
    do iMode = 1, nbMode
        valInte(1) = iMode
        valReal(1) = v_gamma(iMode+nbMode*(numeSnap-1))
        call tbajli(tablResu%tablName, tablResu%nbPara, tablResu%paraName,&
                     valInte, valReal, [(0.d0,0.d0)], [' '], 0)
    enddo
!
end subroutine
