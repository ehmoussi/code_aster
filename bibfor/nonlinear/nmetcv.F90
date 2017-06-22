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

subroutine nmetcv(field_refe, field_in, field_disc_in, field_out, field_disc_out)
!
implicit none
!
#include "asterfort/chpchd.h"
#include "asterfort/copisd.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: field_refe
    character(len=24), intent(in) :: field_in
    character(len=24), intent(in) :: field_out
    character(len=4), intent(in) :: field_disc_in
    character(len=4), intent(in) :: field_disc_out
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Input/output datastructure
!
! Field conversion (discretization)
!
! --------------------------------------------------------------------------------------------------
!
! In  field_refe      : name of a reference field to convert ELGA fields
! In  field_in        : name of field to convert
! In  field_disc_in   : spatial discretization of field to convert
! In  field_out       : name of field converted
! In  field_disc_out  : spatial discretization of field converted
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: valk(3)
!
! --------------------------------------------------------------------------------------------------
!
!
! - Good discretization -> nothing to do
!
    if (field_disc_in .eq. field_disc_out) then
        call copisd('CHAMP_GD', 'V', field_in, field_out)
    else
!
! ----- Not good discretization -> is it possible to convert ?
!
        valk(1) = field_in
        valk(2) = field_disc_in
        valk(3) = field_disc_out
        if (field_disc_out .eq. 'ELGA') then
            if (field_refe .eq. ' ') then
                call utmess('F', 'ETATINIT_52', nk=3, valk=valk)
            else
                call utmess('I', 'ETATINIT_51', nk=3, valk=valk)
            endif
        else
            call utmess('F', 'ETATINIT_52', nk=3, valk=valk)
        endif
!
! ----- Not good discretization -> convert
!
        call chpchd(field_in , field_disc_out, field_refe, 'NON', 'V',&
                    field_out)
    endif
!
end subroutine
