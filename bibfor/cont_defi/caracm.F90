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

subroutine caracm(sdcont, nb_cont_zone)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    character(len=8), intent(in) :: sdcont
    integer, intent(in) :: nb_cont_zone
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Creation of datastructures for meshed formulations (depending on contact zone)
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
    integer :: ztole, zdirn, zmeth
    character(len=24) :: sdcont_methco, sdcont_dirapp, sdcont_toleco, sdcont_dirnor
    integer :: j_sdcont_methco, j_sdcont_dirapp, j_sdcont_toleco, j_sdcont_dirnor
    character(len=24) :: sdcont_jeufo1, sdcont_jeufo2
    integer :: j_sdcont_jeufo1, j_sdcont_jeufo2
!
! --------------------------------------------------------------------------------------------------
!
    jv_base     = 'G'
    sdcont_defi = sdcont(1:8)//'.CONTACT'
!
! - Datastructure for contact definition
!
    sdcont_methco = sdcont_defi(1:16)//'.METHCO'
    sdcont_dirapp = sdcont_defi(1:16)//'.DIRAPP'
    sdcont_dirnor = sdcont_defi(1:16)//'.DIRNOR'
    sdcont_jeufo1 = sdcont_defi(1:16)//'.JFO1CO'
    sdcont_jeufo2 = sdcont_defi(1:16)//'.JFO2CO'
    sdcont_toleco = sdcont_defi(1:16)//'.TOLECO'
!
! - Sizes
!
    zmeth = cfmmvd('ZMETH')
    zdirn = cfmmvd('ZDIRN')
    ztole = cfmmvd('ZTOLE')
!
! - Creation
!
    call wkvect(sdcont_methco, jv_base//' V I' , zmeth*nb_cont_zone, j_sdcont_methco)
    call wkvect(sdcont_dirapp, jv_base//' V R' , 3*nb_cont_zone    , j_sdcont_dirapp)
    call wkvect(sdcont_dirnor, jv_base//' V R' , zdirn*nb_cont_zone, j_sdcont_dirnor)
    call wkvect(sdcont_jeufo1, jv_base//' V K8', nb_cont_zone      , j_sdcont_jeufo1)
    call wkvect(sdcont_jeufo2, jv_base//' V K8', nb_cont_zone      , j_sdcont_jeufo2)
    call wkvect(sdcont_toleco, jv_base//' V R' , ztole*nb_cont_zone, j_sdcont_toleco)
!
end subroutine
