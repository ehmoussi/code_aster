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

subroutine nmobno(sd_obsv, keyw_fact, nb_keyw_fact)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/impfoi.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: nb_keyw_fact
    character(len=19), intent(in) :: sd_obsv
    character(len=16), intent(in) :: keyw_fact
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear operators - Observation
!
! Name of observations
!
! --------------------------------------------------------------------------------------------------
!
! In  sd_obsv          : datastructure for observation parameters
! In  keyw_fact        : factor keyword to read observation parameters
! In  nb_keyw_fact     : number of factor keyword to read observation parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_keyw_fact, nb_title
    character(len=24) :: obsv_titl
    character(len=16), pointer :: v_obsv_titl(:) => null()
    character(len=16) :: title
    character(len=1) :: chaine
!
! --------------------------------------------------------------------------------------------------
!
!
! - Create vector for title
!
    obsv_titl = sd_obsv(1:14)//'     .TITR'
    call wkvect(obsv_titl, 'V V K16', nb_keyw_fact, vk16 = v_obsv_titl)
!
! - Set titles
!
    do i_keyw_fact = 1, nb_keyw_fact
        call impfoi(0, 1, i_keyw_fact, chaine)
        title = 'OBSERVATION_'//chaine
        call getvtx(keyw_fact, 'TITRE', iocc=i_keyw_fact, nbval=0, nbret=nb_title)
        nb_title = - nb_title
        ASSERT(nb_title.le.1)
        if (nb_title .ne. 0) then
            call getvtx(keyw_fact, 'TITRE', iocc=i_keyw_fact, nbval=nb_title, vect=title)
        endif
        v_obsv_titl(i_keyw_fact) = title
    end do
!
end subroutine
