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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine thm_kit_read(keywordfact, iocc     , rela_comp, rela_thmc, rela_hydr,&
                        rela_meca  , rela_ther)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/getvtx.h"
#include "asterfort/assert.h"
#include "asterc/lckitread.h"
!
character(len=16), intent(in) :: keywordfact
integer, intent(in) :: iocc
character(len=16), intent(in) :: rela_comp
character(len=16), intent(out) :: rela_thmc
character(len=16), intent(out) :: rela_hydr
character(len=16), intent(out) :: rela_meca
character(len=16), intent(out) :: rela_ther
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Read informations for KIT
!
! --------------------------------------------------------------------------------------------------
!
! In  keywordfact  : factor keyword to read (COMPORTEMENT)
! In  iocc         : factor keyword index in COMPORTEMENT
! In  rela_comp    : comportment relation (KIT_*)
! Out rela_thmc    : relation for coupling
! Out rela_hydr    : relation for hydraulic
! Out rela_meca    : relation for mechanic
! Out rela_ther    : relation for thermic
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nocc
    character(len=16) :: rela_kit(4), rela_list(4), list_kit(5)
!
! --------------------------------------------------------------------------------------------------
!
    rela_thmc = 'VIDE'
    rela_hydr = 'VIDE'
    rela_meca = 'VIDE'
    rela_ther = 'VIDE'
!
! - Read command file
!
    call getvtx(keywordfact, 'RELATION_KIT', iocc = iocc, nbval = 0, nbret = nocc)
    nocc = -nocc
    call getvtx(keywordfact, 'RELATION_KIT', iocc = iocc, nbval = nocc, vect = rela_kit)
!
! - Get right type
!
    list_kit(1:5)      = 'VIDE'
    list_kit(1)        = rela_comp
    list_kit(2:nocc+1) = rela_kit(1:nocc)
    call lckitread(5, list_kit, rela_list)
    rela_meca = rela_list(1)
    rela_hydr = rela_list(2)
    rela_thmc = rela_list(3)
    rela_ther = rela_list(4)
!
end subroutine
