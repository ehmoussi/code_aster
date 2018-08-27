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
subroutine dbr_chck_pod(operation, ds_para_pod, l_reuse, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rs_paraonce.h"
#include "asterfort/dbr_chck_table.h"
!
character(len=16), intent(in) :: operation
type(ROM_DS_ParaDBR_POD), intent(in) :: ds_para_pod
aster_logical, intent(in) :: l_reuse
type(ROM_DS_Empi), intent(in) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Some checks - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  operation        : type of method
! In  ds_para_pod      : datastructure for parameters (POD)
! In  l_reuse          : .true. if reuse
! In  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: nb_para = 4
    character(len=16), parameter :: list_para(nb_para) = (/&
        'MODELE  ',&
        'CHAMPMAT',&
        'CARAELEM',&
        'EXCIT   '/)
    character(len=19) :: tabl_user, tabl_coor
    aster_logical :: l_tabl_user, l_lagr
    integer :: nb_mode, nb_snap, nb_line
    character(len=8) :: model = ' '
    integer, pointer :: v_tbnp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','ROM5_19')
    endif
!
! - General check
!
    if (l_reuse .and. operation .eq. 'POD') then
        call utmess('F','ROM2_13', sk = operation)
    endif
!
! - Get information about model
!
    model = ds_para_pod%ds_result_in%model
    if (model .eq. '#AUCUN' .or. model .eq. ' ') then
        if (ds_para_pod%model_user .eq. ' ') then
            call utmess('F', 'ROM5_54')
        endif
    endif
!
! - Get components in fields
!
    l_lagr = ds_para_pod%ds_result_in%l_lagr
    if (l_lagr) then
        call utmess('F', 'ROM5_22')
    endif
!
! - Check if parameters are the same on all storing index
!
    call rs_paraonce(ds_para_pod%ds_result_in%name, nb_para, list_para)
!
! - Check if COOR_REDUIT is OK
!
    tabl_user   = ds_para_pod%tabl_user
    l_tabl_user = ds_para_pod%l_tabl_user
    if (operation .eq. 'POD_INCR' .and. l_reuse) then
! ----- Check if table is OK
        tabl_coor = ds_empi%tabl_coor
        call jeveuo(tabl_coor//'.TBNP', 'L', vi=v_tbnp)
        nb_line = v_tbnp(2)
        if (nb_line .eq. 0) then
            if (.not.l_tabl_user) then
                call utmess('F', 'ROM7_23')
            endif
        else
            if (l_tabl_user) then
                call utmess('F', 'ROM7_24')
            endif
        endif
! ----- Check conformity of user table
        if (l_tabl_user) then
            nb_mode = ds_empi%nb_mode
            nb_snap = ds_para_pod%ds_snap%nb_snap
            call dbr_chck_table(tabl_user, nb_mode, nb_snap)
        endif
    endif
!
end subroutine
