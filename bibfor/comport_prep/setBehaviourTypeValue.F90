! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine setBehaviourTypeValue(v_para   , i_comp_  ,&
                                 l_compor_, v_compor_)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/Behaviour_type.h"
!
type(Behaviour_Para), pointer :: v_para(:)
integer, optional, intent(in) :: i_comp_
character(len=16), intent(out), optional :: l_compor_(:)
character(len=16), pointer, optional :: v_compor_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of behaviour (mechanics)
!
! Save informations in the field <COMPOR>
!
! --------------------------------------------------------------------------------------------------
!
! In  v_para           : list of informations to save
! In  i_comp           : index in previous list
! In  l_compor         : liste of components for <CARTE> COMPOR - (SIMU_POIN_MAT)
! In  v_compor         : liste of components for <CARTE> COMPOR - (*_NON_LINE)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_comp
    aster_logical :: l_pmf, l_kit_thm, l_kit_ddi, l_kit_meta, l_kit_cg
!
! --------------------------------------------------------------------------------------------------
!
    i_comp = 1
    if (present(i_comp_)) then
        i_comp = i_comp_
    endif
!
    call comp_meca_l(v_para(i_comp)%rela_comp, 'PMF'     , l_pmf)
    call comp_meca_l(v_para(i_comp)%rela_comp, 'KIT_THM' , l_kit_thm)
    call comp_meca_l(v_para(i_comp)%rela_comp, 'KIT_DDI' , l_kit_ddi)
    call comp_meca_l(v_para(i_comp)%rela_comp, 'KIT_META', l_kit_meta)
    call comp_meca_l(v_para(i_comp)%rela_comp, 'KIT_CG'  , l_kit_cg)
!
    if (present(v_compor_)) then
        v_compor_(1:COMPOR_SIZE) = 'VIDE'
        v_compor_(RELA_NAME) = v_para(i_comp)%rela_comp
        write (v_compor_(NVAR),'(I16)') v_para(i_comp)%nb_vari
        v_compor_(DEFO) = v_para(i_comp)%defo_comp
        v_compor_(INCRELAS) = v_para(i_comp)%type_comp
        v_compor_(PLANESTRESS) = v_para(i_comp)%type_cpla
        if (.not.l_pmf) then
            write (v_compor_(NUME),'(I16)') v_para(i_comp)%nume_comp(1)
        endif
        v_compor_(MULTCOMP) = v_para(i_comp)%mult_comp
        v_compor_(POSTITER) = v_para(i_comp)%post_iter
        v_compor_(DEFO_LDC) = v_para(i_comp)%defo_ldc
        v_compor_(RIGI_GEOM) = v_para(i_comp)%rigi_geom
        v_compor_(REGUVISC) = v_para(i_comp)%regu_visc
        if (l_kit_thm) then
            v_compor_(THMC_NAME) = v_para(i_comp)%kit_comp(1)
            v_compor_(THER_NAME) = v_para(i_comp)%kit_comp(2)
            v_compor_(HYDR_NAME) = v_para(i_comp)%kit_comp(3)
            v_compor_(MECA_NAME) = v_para(i_comp)%kit_comp(4)
            write (v_compor_(THMC_NUME),'(I16)') v_para(i_comp)%nume_comp(1)
            write (v_compor_(THER_NUME),'(I16)') v_para(i_comp)%nume_comp(2)
            write (v_compor_(HYDR_NUME),'(I16)') v_para(i_comp)%nume_comp(3)
            write (v_compor_(MECA_NUME),'(I16)') v_para(i_comp)%nume_comp(4)
            write (v_compor_(THMC_NVAR),'(I16)') v_para(i_comp)%nb_vari_comp(1)
            write (v_compor_(THER_NVAR),'(I16)') v_para(i_comp)%nb_vari_comp(2)
            write (v_compor_(HYDR_NVAR),'(I16)') v_para(i_comp)%nb_vari_comp(3)
            write (v_compor_(MECA_NVAR),'(I16)') v_para(i_comp)%nb_vari_comp(4)
        endif
        if (l_kit_ddi) then
            v_compor_(CREEP_NAME) = v_para(i_comp)%kit_comp(1)
            v_compor_(PLAS_NAME)  = v_para(i_comp)%kit_comp(2)
            v_compor_(COUPL_NAME) = v_para(i_comp)%kit_comp(3)
            v_compor_(CPLA_NAME)  = v_para(i_comp)%kit_comp(4)
            write (v_compor_(CREEP_NUME),'(I16)') v_para(i_comp)%nume_comp(3)
            write (v_compor_(PLAS_NUME),'(I16)')  v_para(i_comp)%nume_comp(2)
            write (v_compor_(CREEP_NVAR),'(I16)') v_para(i_comp)%nb_vari_comp(1)
            write (v_compor_(PLAS_NVAR),'(I16)')  v_para(i_comp)%nb_vari_comp(2)
        endif
        v_compor_(KIT1_NAME) = v_para(i_comp)%kit_comp(1)
        if (l_kit_meta) then
            v_compor_(META_NAME)  = v_para(i_comp)%kit_comp(1)
        endif
        if (l_kit_cg) then
            v_compor_(CABLE_NAME)   = v_para(i_comp)%kit_comp(1)
            v_compor_(SHEATH_NAME)  = v_para(i_comp)%kit_comp(2)
        endif
    endif
    if (present(l_compor_)) then
        l_compor_(1:COMPOR_SIZE) = 'VIDE'
        l_compor_(RELA_NAME) = v_para(i_comp)%rela_comp
        write (l_compor_(NVAR),'(I16)') v_para(i_comp)%nb_vari
        l_compor_(DEFO) = v_para(i_comp)%defo_comp
        l_compor_(INCRELAS) = v_para(i_comp)%type_comp
        l_compor_(PLANESTRESS) = v_para(i_comp)%type_cpla
        if (.not.l_pmf) then
            write (l_compor_(NUME),'(I16)') v_para(i_comp)%nume_comp(1)
        endif
        l_compor_(MULTCOMP) = v_para(i_comp)%mult_comp
        l_compor_(POSTITER) = v_para(i_comp)%post_iter
        l_compor_(DEFO_LDC) = v_para(i_comp)%defo_ldc
        l_compor_(RIGI_GEOM) = v_para(i_comp)%rigi_geom
        l_compor_(REGUVISC) = v_para(i_comp)%regu_visc
        if (l_kit_ddi) then
            l_compor_(CREEP_NAME) = v_para(i_comp)%kit_comp(1)
            l_compor_(PLAS_NAME)  = v_para(i_comp)%kit_comp(2)
            l_compor_(COUPL_NAME) = v_para(i_comp)%kit_comp(3)
            l_compor_(CPLA_NAME)  = v_para(i_comp)%kit_comp(4)
            write (l_compor_(CREEP_NUME),'(I16)') v_para(i_comp)%nume_comp(3)
            write (l_compor_(PLAS_NUME),'(I16)')  v_para(i_comp)%nume_comp(2)
            write (l_compor_(CREEP_NVAR),'(I16)') v_para(i_comp)%nb_vari_comp(1)
            write (l_compor_(PLAS_NVAR),'(I16)')  v_para(i_comp)%nb_vari_comp(2)
        endif
        l_compor_(KIT1_NAME) = v_para(i_comp)%kit_comp(1)
        if (l_kit_meta) then
            l_compor_(META_NAME)  = v_para(i_comp)%kit_comp(1)
        endif
        if (l_kit_cg) then
            l_compor_(CABLE_NAME)   = v_para(i_comp)%kit_comp(1)
            l_compor_(SHEATH_NAME)  = v_para(i_comp)%kit_comp(2)
        endif
    endif
!
end subroutine
