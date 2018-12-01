! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine defContactCreateObjects(sdcont)
!
implicit none
!
#include "asterfort/cfmmvd.h"
#include "asterfort/wkvect.h"
!
character(len=8), intent(in) :: sdcont
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Creation of datastructures for all formulations (Not depending on contact zone)
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=1) :: jv_base
    character(len=24) :: sdcont_paraci, sdcont_paracr
    integer :: j_sdcont_paracr, j_sdcont_paraci
    integer :: zparr, zpari
!
! --------------------------------------------------------------------------------------------------
!
    jv_base = 'G'
!
! - Datastructure for contact definition
!
    sdcont_paraci = sdcont(1:8)//'.PARACI'
    sdcont_paracr = sdcont(1:8)//'.PARACR'
!
! - Sizes
!
    zparr = cfmmvd('ZPARR')
    zpari = cfmmvd('ZPARI')
!
! - Creation
!
    call wkvect(sdcont_paracr, jv_base//' V R', zparr, j_sdcont_paracr)
    call wkvect(sdcont_paraci, jv_base//' V I', zpari, j_sdcont_paraci)
!
end subroutine
