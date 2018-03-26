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
subroutine comp_meta_read(ds_comporMeta)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lcinfo.h"
#include "asterc/lcdiscard.h"
#include "asterc/lccree.h"
#include "asterfort/getvtx.h"
!
type(META_PrepPara), intent(inout) :: ds_comporMeta
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (metallurgy)
!
! Read informations from command file
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_comporMeta    : datastructure to prepare comportement
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: keywordfact
    integer :: i_comp, nb_comp
    character(len=16) :: phase_type, loi_meta
    integer :: nb_comp_elem, nume_comp, nb_vari, idummy, iret
    character(len=16) :: comp_elem(2), comp_code_py
!
! --------------------------------------------------------------------------------------------------
!
    keywordfact = 'COMPORTEMENT'
    nb_comp     = ds_comporMeta%nb_comp
!
! - Read informations in CALC_META
!
    do i_comp = 1, nb_comp
        call getvtx(keywordfact, 'RELATION', iocc = i_comp, scal = phase_type, nbret=iret)
        call getvtx(keywordfact, 'LOI_META', iocc = i_comp, scal = loi_meta, nbret=iret)
! ----- Create composite comportment
        nb_comp_elem = 2
        comp_elem(1) = phase_type
        comp_elem(2) = loi_meta
        call lccree(nb_comp_elem, comp_elem, comp_code_py)
! ----- Get number of variables and index of behaviour
        call lcinfo(comp_code_py, nume_comp, nb_vari, idummy)
! ----- Glute provisoire: nombre de phases different entre CALC_META et STAT_NON_LINE
        call lcdiscard(comp_code_py)
! ----- Save values
        ds_comporMeta%v_comp(i_comp)%phase_type = phase_type
        ds_comporMeta%v_comp(i_comp)%loi_meta   = loi_meta
        ds_comporMeta%v_comp(i_comp)%nb_vari    = nb_vari
        ds_comporMeta%v_comp(i_comp)%nume_comp  = nume_comp
    end do
!
end subroutine
