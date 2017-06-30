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

subroutine thmGetBehaviour(compor)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
!
!
    character(len=16), intent(in) :: compor(*)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get parameters for behaviour
!
! --------------------------------------------------------------------------------------------------
!
! In  compor         : name of comportment definition (field)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: rela_thmc
!
! --------------------------------------------------------------------------------------------------
!
    rela_thmc = compor(8)
    ds_thm%ds_behaviour%rela_thmc = compor(8)
    ds_thm%ds_behaviour%rela_ther = compor(9)
    ds_thm%ds_behaviour%rela_hydr = compor(10)
    ds_thm%ds_behaviour%rela_meca = compor(11)
!
! - For coupling law
!
    ds_thm%ds_behaviour%nb_pres = 0
    if (rela_thmc .eq. 'VIDE' .or. &
        rela_thmc .eq. ' ') then
        ds_thm%ds_behaviour%nb_pres = 0
    elseif (rela_thmc .eq. 'LIQU_SATU' .or. &
        rela_thmc .eq. 'GAZ' .or. &
        rela_thmc .eq. 'LIQU_GAZ_ATM' .or. &
        rela_thmc .eq. 'LIQU_VAPE') then
        ds_thm%ds_behaviour%nb_pres = 1
    else
        ds_thm%ds_behaviour%nb_pres = 2
    endif
!
    if (ds_thm%ds_behaviour%nb_pres .ge. 1) then
        ds_thm%ds_behaviour%nb_phase(1) = 1
        if (rela_thmc .eq. 'LIQU_GAZ' .or. &
            rela_thmc .eq. 'LIQU_VAPE_GAZ' .or. &
            rela_thmc .eq. 'LIQU_AD_GAZ_VAPE' .or. &
            rela_thmc .eq. 'LIQU_AD_GAZ'.or. &
            rela_thmc .eq. 'LIQU_VAPE') then
            ds_thm%ds_behaviour%nb_phase(1) = 2
        endif
        if (ds_thm%ds_behaviour%nb_pres .eq. 2) then
            ds_thm%ds_behaviour%nb_phase(2) = 1
            if (rela_thmc .eq. 'LIQU_AD_GAZ_VAPE' .or. &
                rela_thmc .eq. 'LIQU_AD_GAZ') then
                ds_thm%ds_behaviour%nb_phase(2) = 2
            endif
        endif  
    endif
!
! - For temperature
!
    ds_thm%ds_behaviour%l_temp = .true._1
    if (rela_thmc .eq. 'LIQU_SATU' .or. &
        rela_thmc .eq. 'LIQU_GAZ_ATM') then
        ds_thm%ds_behaviour%l_temp = .false._1
    endif
!
end subroutine
