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

subroutine caracx(sdcont, nb_cont_zone)
!
implicit none
!
#include "asterfort/cfmmvd.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: sdcont
    integer, intent(in) :: nb_cont_zone
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Creation of datastructures for XFEM formulation (depending on contact zone)
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  nb_cont_zone     : number of zones of contact
!
! --------------------------------------------------------------------------------------------------
!
    character(len=1) :: jv_base
    character(len=24) :: sdcont_defi
    integer :: zcmxf, ztole
    character(len=24) :: sdcont_caraxf, sdcont_toleco
    integer :: j_sdcont_caraxf, j_sdcont_toleco
!
! --------------------------------------------------------------------------------------------------
!
    jv_base     = 'G'
    sdcont_defi = sdcont(1:8)//'.CONTACT'
!
! - Sizes
!
    zcmxf = cfmmvd('ZCMXF')
    ztole = cfmmvd('ZTOLE')
!
! - Datastructure for contact definition
!
    sdcont_caraxf = sdcont_defi(1:16)//'.CARAXF'
    sdcont_toleco = sdcont_defi(1:16)//'.TOLECO'
!
! - Creation
!
    call wkvect(sdcont_caraxf, jv_base//' V R' , zcmxf*nb_cont_zone, j_sdcont_caraxf)
    call wkvect(sdcont_toleco, jv_base//' V R' , ztole*nb_cont_zone, j_sdcont_toleco)
!
end subroutine
