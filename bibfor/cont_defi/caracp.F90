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

subroutine caracp(sdcont)
!
implicit none
!
#include "asterfort/cfmmvd.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
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
    character(len=24) :: sdcont_defi
    character(len=24) :: sdcont_paraci, sdcont_paracr, sdcont_ndimco
    integer :: j_sdcont_paracr, j_sdcont_paraci, j_sdcont_ndimco
    integer :: zparr, zpari, zdime
!
! --------------------------------------------------------------------------------------------------
!
    jv_base = 'G'
!
! - Datastructure for contact definition
!
    sdcont_defi = sdcont(1:8)//'.CONTACT'
    sdcont_paraci = sdcont_defi(1:16)//'.PARACI'
    sdcont_paracr = sdcont_defi(1:16)//'.PARACR'
    sdcont_ndimco = sdcont_defi(1:16)//'.NDIMCO'
!
! - Sizes
!
    zparr = cfmmvd('ZPARR')
    zpari = cfmmvd('ZPARI')
    zdime = cfmmvd('ZDIME')
!
! - Creation
!
    call wkvect(sdcont_paracr, jv_base//' V R', zparr, j_sdcont_paracr)
    call wkvect(sdcont_paraci, jv_base//' V I', zpari, j_sdcont_paraci)
    call wkvect(sdcont_ndimco, jv_base//' V I', zdime, j_sdcont_ndimco)
!
end subroutine
