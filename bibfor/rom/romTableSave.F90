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

subroutine romTableSave(tabl_name  , nb_mode   , v_gamma   ,&
                        nume_store_, time_curr_, nume_snap_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/tbajli.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: tabl_name
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
! In  tabl_name        : name of table in results datastructure
! In  nb_mode          : number of empiric modes
! In  v_gamma          : pointer to reduced coordinates
! In  nume_store       : index to store in results
! In  time_curr        : current time
! In  nume_snap        : index of snapshot
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: nb_para = 5
    character(len=16), parameter :: para_name(nb_para) = (/'NUME_MODE  ','NUME_ORDRE ',&
                                                           'INST       ','NUME_SNAP  ',&
                                                           'COOR_REDUIT'/)
    integer :: i_mode, v_inte(3), nume_snap, nume_store
    real(kind=8) :: v_real(2), time_curr
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_39')
    endif
!
! - Get parameters
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
    v_real(1)  = time_curr
!
! - Save in table
!
    do i_mode = 1, nb_mode
        v_inte(1) = i_mode
        v_real(2) = v_gamma(i_mode+nb_mode*(nume_snap-1))
        call tbajli(tabl_name, nb_para, para_name, v_inte, v_real, [(0.d0,0.d0)], [' '], 0)
    enddo
!
end subroutine
