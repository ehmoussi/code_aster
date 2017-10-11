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
!
subroutine thmGetBehaviourVari()
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/THM_type.h"
#include "asterfort/Behaviour_type.h"
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get parameters for internal variables
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nume_thmc
!
! --------------------------------------------------------------------------------------------------
!
    ds_thm%ds_behaviour%advime = 1
    ds_thm%ds_behaviour%advith = ds_thm%ds_behaviour%advime + ds_thm%ds_behaviour%nb_vari_meca
    ds_thm%ds_behaviour%advihy = ds_thm%ds_behaviour%advith + ds_thm%ds_behaviour%nb_vari_ther
    ds_thm%ds_behaviour%advico = ds_thm%ds_behaviour%advihy + ds_thm%ds_behaviour%nb_vari_hydr
    ds_thm%ds_behaviour%vihrho = 0
    ds_thm%ds_behaviour%vicphi = 0
    nume_thmc = ds_thm%ds_behaviour%nume_thmc
    if ((nume_thmc .eq. LIQU_GAZ) .or. (nume_thmc .eq. LIQU_GAZ_ATM) .or.&
        (nume_thmc .eq. LIQU_VAPE) .or. (nume_thmc .eq. LIQU_VAPE_GAZ) .or.&
        (nume_thmc .eq. LIQU_AD_GAZ) .or. (nume_thmc .eq. LIQU_AD_GAZ_VAPE)) then
        if ((nume_thmc .eq. LIQU_GAZ) .or. (nume_thmc .eq. LIQU_GAZ_ATM)) then
            ds_thm%ds_behaviour%vicsat = ds_thm%ds_behaviour%vicphi + 1
        else
            ds_thm%ds_behaviour%vicpvp = ds_thm%ds_behaviour%vicphi + 1
            ds_thm%ds_behaviour%vicsat = ds_thm%ds_behaviour%vicpvp + 1
        endif
        if (nume_thmc .eq. LIQU_AD_GAZ) then
            ds_thm%ds_behaviour%vicpr1 = ds_thm%ds_behaviour%vicsat + 1
            ds_thm%ds_behaviour%vicpr2 = ds_thm%ds_behaviour%vicpr1 + 1
        endif
    endif
!
end subroutine
