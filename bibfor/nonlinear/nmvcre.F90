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

subroutine nmvcre(model, mate, cara_elem, varc_refe)
!
    implicit none
!
#include "asterfort/detrsd.h"
#include "asterfort/vrcref.h"
!
!
    character(len=24), intent(in) :: model
    character(len=8), intent(in) :: mate
    character(len=8), intent(in) :: cara_elem
    character(len=24), intent(in) :: varc_refe
!
! --------------------------------------------------------------------------------------------------
!
! Command variables utility
!
! Computation of reference command variables vector
!
! --------------------------------------------------------------------------------------------------
!
! In  model          : name of model
! In  mate           : name of material characteristics (field)
! In  cara_elem      : name of elementary characteristics (field)
! In  varc_refe      : name of reference command variables vector
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: champ
!
! --------------------------------------------------------------------------------------------------
!
    champ = varc_refe(1:14)//'.TOUT'
    call detrsd('VARI_COM', varc_refe)
    call vrcref(model, mate, cara_elem, champ)
!
end subroutine
