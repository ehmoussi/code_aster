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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine dbr_chck_table(tabl_namez, nb_mode_in, nb_snap_in)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/tbGetListPara.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/tbexve.h"
#include "asterfort/jeveuo.h"
!
character(len=*), intent(in) :: tabl_namez
integer, intent(in) :: nb_mode_in, nb_snap_in
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Some checks for POD methods
!
! Check conformity of user table
!
! --------------------------------------------------------------------------------------------------
!
! In  tabl_name        : name of table
! In  nb_mode_in       : number of modes in empiric base
! In  nb_snap_in       : number of snap in empiric base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_para, nb_line, nb_mode, nb_snap
    integer :: i_para, i_line
    character(len=24), pointer :: v_list_para(:) => null()
    character(len=24), pointer :: v_type_para(:) => null()
    aster_logical :: l_error
    character(len=24), parameter :: list_para(5) = (/'COOR_REDUIT','INST       ',&
                                                     'NUME_MODE  ','NUME_ORDRE ',&
                                                     'NUME_SNAP  '/)
    character(len=8), parameter :: type_para(5) = (/'R','R','I','I','I'/)
    integer, pointer :: v_nume_snap(:) => null()
    character(len=24) :: typval
    integer :: nbval
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','ROM5_80')
    endif
    l_error = ASTER_FALSE
!
! - Name/type of parameters
!
    call tbGetListPara(tabl_namez, nb_para, v_list_para, v_type_para, nb_line)
    l_error = nb_para .ne. 5
    do i_para = 1, nb_para
        if (v_list_para(i_para) .ne. list_para(i_para)) then
            l_error = ASTER_TRUE
            exit
        endif
        if (v_type_para(i_para) .ne. type_para(i_para)) then
            l_error = ASTER_TRUE
            exit
        endif
    end do
    if (l_error) then
        call utmess('F', 'ROM7_27')
    endif
    AS_DEALLOCATE(vk24 = v_type_para)
    AS_DEALLOCATE(vk24 = v_list_para)
!
! - Number of lines
!
    if (nb_line .eq. 0) then
        call utmess('F', 'ROM7_28')
    endif
!
! - Number of snapshots
!
    call tbexve(tabl_namez, 'NUME_SNAP', '&&NUMESNAP', 'V', nbval, typval)
    call jeveuo('&&NUMESNAP', 'E', vi = v_nume_snap)
    nb_snap = 0
    do i_line = 1, nb_line
        if (v_nume_snap(i_line) .gt. nb_snap) nb_snap = v_nume_snap(i_line)
    end do
!
! - Number of modes
!
    nb_mode = nb_line / nb_snap
    if (nb_snap .ne. nb_snap_in) then
        call utmess('F', 'ROM7_29')
    endif
    if (nb_mode .ne. nb_mode_in) then
        call utmess('F', 'ROM7_30')
    endif
!
end subroutine
