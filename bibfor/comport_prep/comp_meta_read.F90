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

subroutine comp_meta_read(list_vale)
!
implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/assert.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: list_vale
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (metallurgy)
!
! Read informations from command file
!
! --------------------------------------------------------------------------------------------------
!
! In  list_vale   : list of informations to save
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: keywordfact
    integer :: iocc, nocc
    integer :: j_lvali, j_lvalk
    character(len=16) :: phas_type, rela_comp
    integer :: nb_vari
!
! --------------------------------------------------------------------------------------------------
!
    keywordfact = 'COMPORTEMENT'
    call getfac(keywordfact, nocc)
!
! - List construction
!
    call wkvect(list_vale(1:19)//'.VALI', 'V V I'  , nocc, j_lvali)
    call wkvect(list_vale(1:19)//'.VALK', 'V V K24', nocc, j_lvalk)
!
! - Read informations in CALC_META
!
    do iocc = 1, nocc
        call getvtx(keywordfact, 'RELATION', iocc = iocc, scal = phas_type)
        call getvis(keywordfact, phas_type, iocc = iocc, scal = nb_vari)
        rela_comp = phas_type
        zi(j_lvali-1+1)   = nb_vari
        zk24(j_lvalk-1+1) = rela_comp
    end do
!
end subroutine
