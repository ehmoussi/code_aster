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

subroutine caform(cont_form)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/cazouu.h"
#include "asterfort/getvtx.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    integer, intent(out) :: cont_form
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Get contact formulation
!
! --------------------------------------------------------------------------------------------------
!
! Out cont_form        : formulation of contact
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: s_formul, keywf, s_algo_cont
    integer :: noc, nb_cont_zone
!
! --------------------------------------------------------------------------------------------------
!
    keywf     = 'ZONE'
    cont_form = 0
!
! - Contact formulation
!
    call getvtx(' ', 'FORMULATION', scal=s_formul, nbret=noc)
    ASSERT(noc.ne.0)
!
    if (s_formul .eq. 'DISCRETE') then
        cont_form = 1
    else if (s_formul.eq.'CONTINUE') then
        call getvtx(keywf, 'ALGO_CONT', iocc=1, scal=s_algo_cont)
        if (s_algo_cont.eq.'LAC') then
            call getfac(keywf, nb_cont_zone)
            call cazouu(keywf, nb_cont_zone, 'ALGO_CONT','T')
            cont_form = 5
        else
            cont_form = 2
        endif
    else if (s_formul.eq.'XFEM') then
        cont_form = 3
    else if (s_formul.eq.'LIAISON_UNIL') then
        cont_form = 4
    else
        ASSERT(.false.)
    endif
!
end subroutine
