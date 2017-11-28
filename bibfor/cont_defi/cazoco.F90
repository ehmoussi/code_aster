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

subroutine cazoco(sdcont      , model, keywf, cont_form, i_zone,&
                  nb_cont_zone)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cazocc.h"
#include "asterfort/cazocd.h"
#include "asterfort/cazocm.h"
#include "asterfort/cazocx.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: model
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: nb_cont_zone
    integer, intent(in) :: cont_form
    integer, intent(in) :: i_zone
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Get parameters (depending on contact zones)
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  model            : name of model
! In  keywf            : factor keyword to read
! In  nb_cont_zone     : number of zones of contact
! In  cont_form        : formulation of contact
! In  i_zone           : index of contact zone
!
! --------------------------------------------------------------------------------------------------
!
    if (cont_form .eq. 1) then
        call cazocm(sdcont, keywf, i_zone)
        call cazocd(sdcont, keywf, i_zone, nb_cont_zone)
    else if (cont_form .eq. 2) then
        call cazocm(sdcont, keywf, i_zone)
        call cazocc(sdcont, keywf, i_zone,nb_cont_zone = nb_cont_zone)
    else if (cont_form .eq. 3) then
        call cazocx(sdcont, model, keywf, i_zone)
    else if (cont_form .eq. 5) then
        call cazocm(sdcont, keywf, i_zone)
        call cazocc(sdcont, keywf, i_zone)
    else
        ASSERT(.false.)
    endif
!
end subroutine
