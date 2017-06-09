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

subroutine comp_meca_rkit(keywordfact, iocc, rela_comp, kit_comp)
!
implicit none
!
#include "asterfort/getvtx.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/ddi_kit_read.h"
#include "asterfort/thm_kit_read.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(in) :: keywordfact
    integer, intent(in) :: iocc
    character(len=16), intent(in) :: rela_comp
    character(len=16), intent(out) :: kit_comp(4)
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Read informations for KIT
!
! --------------------------------------------------------------------------------------------------
!
! In  keywordfact  : factor keyword to read
! In  iocc         : factor keyword index
! In  rela_comp    : comportment relation
! Out kit_comp     : KIT comportment
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nocc, nb_rela_kit
    character(len=16) :: rela_thmc, rela_hydr, rela_meca, rela_ther
    character(len=16) :: rela_flua, rela_plas, rela_cpla, rela_coup
    character(len=16) :: rela_cg(2), rela_meta
!
! --------------------------------------------------------------------------------------------------
!
    nb_rela_kit   = 0
    kit_comp(1:4) = 'VIDE'
!
    if (rela_comp(1:4) .eq. 'META') then
        nb_rela_kit = 1
        call getvtx(keywordfact, 'RELATION_KIT', iocc = iocc, &
                    nbval = nb_rela_kit, vect = rela_meta, nbret = nocc)
        ASSERT(nocc.eq.1)
        kit_comp(1) = rela_meta
        if (rela_comp.eq.'META_LEMA_ANI') then
            if (rela_meta.ne.'ZIRC') then
                call utmess('F','COMPOR3_91')
            endif
            kit_comp(1) = 'ZIRC'
        endif
    else if (rela_comp.eq.'KIT_DDI') then
        call ddi_kit_read(keywordfact, iocc, rela_flua, rela_plas, rela_cpla, &
                          rela_coup  )
        kit_comp(1) = rela_flua
        kit_comp(2) = rela_plas
        kit_comp(3) = rela_coup 
        kit_comp(4) = rela_cpla
    else if (rela_comp.eq.'KIT_CG') then
        nb_rela_kit = 2
        call getvtx(keywordfact, 'RELATION_KIT', iocc = iocc, &
                    nbval = nb_rela_kit, vect = rela_cg, nbret = nocc)
        ASSERT(nocc.eq.2)
        kit_comp(1) = rela_cg(1)
        kit_comp(2) = rela_cg(2)
    elseif ((rela_comp(1:5).eq.'KIT_H') .or. (rela_comp(1:6).eq.'KIT_TH')) then
        call thm_kit_read(keywordfact, iocc     , rela_comp, rela_thmc, rela_hydr, &
                          rela_meca  , rela_ther)
        kit_comp(1) = rela_thmc
        kit_comp(2) = rela_ther
        kit_comp(3) = rela_hydr
        kit_comp(4) = rela_meca
    else
        ASSERT(.false.)
    endif
end subroutine
