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

subroutine poinco(sdcont, keywf, mesh, nb_cont_zone, nb_cont_surf)
!
implicit none
!
#include "asterfort/nbzoco.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: mesh
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: nb_cont_zone
    integer, intent(out) :: nb_cont_surf
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Surfaces of contact
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  keywf            : factor keyword to read
! In  mesh             : name of mesh
! In  nb_cont_zone     : number of zones of contact
! Out nb_cont_surf     : number of surfaces of contact
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_zone, nb_surf
    character(len=24) :: sdcont_pzoneco
    integer, pointer :: v_sdcont_pzoneco(:) => null()
    character(len=24) :: sdcont_psumaco, sdcont_psunoco
    integer :: j_sdcont_psumaco, j_sdcont_psunoco
    character(len=24) :: sdcont_defi
!
! --------------------------------------------------------------------------------------------------
!
    nb_cont_surf = 0
!
! - Datastructures for contact
!
    sdcont_defi    = sdcont(1:8)//'.CONTACT'
    sdcont_pzoneco = sdcont_defi(1:16)//'.PZONECO'
    sdcont_psumaco = sdcont_defi(1:16)//'.PSUMACO'
    sdcont_psunoco = sdcont_defi(1:16)//'.PSUNOCO'
!
! - Number of zones of contact
!
    call wkvect(sdcont_pzoneco, 'G V I', nb_cont_zone+1, vi = v_sdcont_pzoneco)
    do i_zone = 1, nb_cont_zone
        call nbzoco(keywf, mesh, i_zone, nb_surf)
        nb_cont_surf = nb_cont_surf + nb_surf
        v_sdcont_pzoneco(i_zone+1) = nb_cont_surf
    end do
!
! - Create datastructures: pointers to elements and nodes of contact
!
    call wkvect(sdcont_psumaco, 'G V I', nb_cont_surf+1, j_sdcont_psumaco)
    call wkvect(sdcont_psunoco, 'G V I', nb_cont_surf+1, j_sdcont_psunoco)
!
end subroutine
