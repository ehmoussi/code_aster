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
subroutine romTableSave(tablResu   , nb_mode   , v_gamma   ,&
                        nume_store_, time_curr_, nume_snap_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/tbajli.h"
!
type(NL_DS_TableIO), intent(in) :: tablResu
integer, intent(in) :: nb_mode
real(kind=8), pointer :: v_gamma(:)
integer, optional, intent(in) :: nume_store_
real(kind=8), optional, intent(in) :: time_curr_
integer, optional, intent(in) :: nume_snap_
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
! In  nb_mode          : number of empiric modes
! In  v_gamma          : pointer to reduced coordinates
! In  nume_store       : index to store in results
! In  time_curr        : current time
! In  nume_snap        : index of snapshot
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_mode, v_inte(3), nume_snap, nume_store
    real(kind=8) :: v_real(2), time_curr
!
! --------------------------------------------------------------------------------------------------
!
    nume_snap   = 1
    if (present(nume_snap_)) then
        nume_snap = nume_snap_
    endif
    nume_store  = 0
    if (present(nume_store_)) then
        nume_store = nume_store_
    endif
    time_curr  = 0
    if (present(time_curr_)) then
        time_curr = time_curr_
    endif
    v_inte(2)  = nume_store
    v_inte(3)  = nume_snap
    v_real(2)  = time_curr
!
! - Save in table
!
    do i_mode = 1, nb_mode
        v_inte(1) = i_mode
        v_real(1) = v_gamma(i_mode+nb_mode*(nume_snap-1))
        call tbajli(tablResu%tablName, tablResu%nbPara, tablResu%paraName,&
                     v_inte, v_real, [(0.d0,0.d0)], [' '], 0)
    enddo
!
end subroutine
