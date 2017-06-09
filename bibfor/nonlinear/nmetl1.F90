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

subroutine nmetl1(i_field, ds_inout)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/nmetnc.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
#include "asterfort/vtcopy.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: i_field
    type(NL_DS_InOut), intent(inout) :: ds_inout
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Input/output datastructure
!
! Read field for ETAT_INIT - From results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  i_field          : field index
! IO  ds_inout         : datastructure for input/output management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: stin_evol
    integer :: ievol, iret, init_nume
    character(len=24) :: valk(2)
    character(len=24) :: field_resu, field_algo
    character(len=16) :: field_type
    character(len=24) :: algo_name, init_name
    character(len=4) :: disc_type
!
! --------------------------------------------------------------------------------------------------
!
    field_resu = '&&NMETL1.CHAMP'
!
! - Get parameters
!
    stin_evol = ds_inout%stin_evol
    init_nume = ds_inout%init_nume
!
! - Field to read ?
!
    if (ds_inout%l_field_acti(i_field).and.ds_inout%field(i_field)%l_read_init) then
!
! ----- Name of field (type) in results datastructure
!
        field_type = ds_inout%field(i_field)%type
!
! ----- Name of field for initial state
!
        init_name  = ds_inout%field(i_field)%init_name
!
! ----- Spatial discretization of field
!
        disc_type  = ds_inout%field(i_field)%disc_type
!
! ----- Name of field in algorithm
!
        algo_name  = ds_inout%field(i_field)%algo_name
        call nmetnc(algo_name, field_algo)
!
! ----- Get field in resultats datastructure
!
        call rsexch(' '  , stin_evol, field_type, init_nume, field_resu,&
                    ievol)
!
! ----- Copy field
!
        if (ievol .eq. 0) then
            if (disc_type .eq. 'NOEU') then
                call vtcopy(field_resu, field_algo, ' ', iret)
                if (iret .ne. 0) then
                    valk(1) = field_resu
                    valk(2) = field_algo
                    call utmess('A', 'MECANONLINE_2', nk=2, valk=valk)
                endif
            elseif ((disc_type.eq.'ELGA').or.&
                    (disc_type.eq.'ELNO').or.&
                    (disc_type.eq.'ELEM')) then
                call copisd('CHAMP_GD', 'V', field_resu, field_algo)
            else
                write(6,*) 'LOCCHA: ',disc_type
                ASSERT(.false.)
            endif
            ds_inout%field(i_field)%init_type = 'RESU'
        else
            if (init_name .ne. ' '.and.ds_inout%field(i_field)%init_type.eq.' ') then
                call copisd('CHAMP', 'V', init_name, field_algo)
                ds_inout%field(i_field)%init_type = 'ZERO'
            endif
        endif
    endif
!
end subroutine
