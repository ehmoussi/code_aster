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

subroutine sanscc(sdcont, keywf, mesh)
!
implicit none
!
#include "asterfort/sansno.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: mesh
    character(len=16), intent(in) :: keywf
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Get SANS_ parameters for friction
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : factor keyword to read
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  mesh             : name of mesh
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_keyw
    parameter (nb_keyw=2)
    character(len=16) :: keyw_name(nb_keyw), keyw_type(nb_keyw)
!
    character(len=24) :: sdcont_defi
    character(len=24) :: sdcont_sanofr, sdcont_psanofr
!
! --------------------------------------------------------------------------------------------------
!
    keyw_type(1) = 'GROUP_NO'
    keyw_type(2) = 'NOEUD'
    keyw_name(1) = 'SANS_GROUP_NO_FR'
    keyw_name(2) = 'SANS_NOEUD_FR'
!
! - Datastructure for contact
!
    sdcont_defi    = sdcont(1:8)//'.CONTACT'
    sdcont_sanofr  = sdcont_defi(1:16)//'.SANOFR'
    sdcont_psanofr = sdcont_defi(1:16)//'.PSANOFR'
!
! - Read list of nodes and save them
!
    call sansno(sdcont , keywf    , mesh     , sdcont_sanofr, sdcont_psanofr,&
                nb_keyw, keyw_type, keyw_name)
!
end subroutine
