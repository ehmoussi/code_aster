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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmcroi(sd_obsv, keyw_fact, nb_keyw_fact)
!
implicit none
!
#include "asterfort/nmcrpx.h"
#include "asterfort/getvtx.h"
#include "asterfort/wkvect.h"
!
integer, intent(in) :: nb_keyw_fact
character(len=19), intent(in) :: sd_obsv
character(len=16), intent(in) :: keyw_fact
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear operators - Observation
!
! Read parameters for list of time
!
! --------------------------------------------------------------------------------------------------
!
! In  sd_obsv          : datastructure for observation parameters
! In  keyw_fact        : factor keyword to read observation parameters
! In  nb_keyw_fact     : number of factor keyword to read observation parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_keyw_fact
    character(len=1) :: base
    character(len=19) :: list_inst_obsv
    character(len=2) :: chaine
    character(len=16) :: keyw_step
    character(len=8) :: answer
    character(len=24) :: obsv_init
    character(len=8), pointer :: v_obsv_init(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    base      = 'V'
    keyw_step = 'PAS_OBSE'
    do i_keyw_fact = 1, nb_keyw_fact
        write(chaine,'(I2)') i_keyw_fact
        list_inst_obsv = sd_obsv(1:14)//chaine(1:2)//'.LI'
        call nmcrpx(keyw_fact, keyw_step, i_keyw_fact, list_inst_obsv, base)
    end do
!
! - Initial observation
!
    obsv_init = sd_obsv(1:14)//'     .INIT'
    call wkvect(obsv_init, 'V V K8', nb_keyw_fact, vk8 = v_obsv_init)
    do i_keyw_fact = 1, nb_keyw_fact
        call getvtx(keyw_fact, 'OBSE_ETAT_INIT', iocc=i_keyw_fact, scal = answer)
        v_obsv_init(i_keyw_fact) = answer
    end do
!
end subroutine
