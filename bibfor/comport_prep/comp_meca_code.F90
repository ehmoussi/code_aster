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
subroutine comp_meca_code(rela_comp_   , defo_comp_   , type_cpla_   , kit_comp_    ,&
                          meca_comp_   , post_iter_   , l_implex_    ,&
                          comp_code_py_, rela_code_py_, defo_code_py_, meta_code_py_,&
                          meca_code_py_)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lccree.h"
#include "asterfort/comp_meca_l.h"
!
character(len=16), optional, intent(in) :: rela_comp_
character(len=16), optional, intent(in) :: defo_comp_
character(len=16), optional, intent(in) :: type_cpla_
character(len=16), optional, intent(in) :: kit_comp_(4)
character(len=16), optional, intent(in) :: meca_comp_
character(len=16), optional, intent(in) :: post_iter_
aster_logical, optional, intent(in) :: l_implex_
character(len=16), optional, intent(out) :: comp_code_py_
character(len=16), optional, intent(out) :: rela_code_py_
character(len=16), optional, intent(out) :: defo_code_py_
character(len=16), optional, intent(out) :: meta_code_py_
character(len=16), optional, intent(out) :: meca_code_py_
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Coding composite comportment
!
! --------------------------------------------------------------------------------------------------
!
! In  rela_comp        : RELATION comportment
! In  defo_comp        : DEFORMATION comportment
! In  type_cpla        : plane stress method
! In  kit_comp         : KIT comportment
! In  meca_comp        : relation for mechanical part
! In  post_iter        : type of post_treatment
! In  l_implex         : .true. if IMPLEX method
! Out comp_code_py     : composite coded comportment (coding in Python)
! Out rela_code_py     : coded comportment for RELATION (coding in Python)
! Out defo_code_py     : coded comportment for DEFORMATION (coding in Python)
! Out meta_code_py     : coded comportment for metallurgy (coding in Python)
! Out meca_code_py     : coded comportment for mechanical part (coding in Python)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_comp_elem, ikit
    character(len=16) :: rela_thmc, rela_hydr, rela_meca, rela_ther
    character(len=16) :: comp_elem(20), rela_meta
    character(len=16) :: meta_code_py, rela_code_py, defo_code_py, meca_code_py, comp_code_py
    aster_logical :: l_kit_meta, l_kit_thm, l_implex
    character(len=16) :: post_iter
    character(len=16) :: rela_comp, defo_comp, kit_comp(4), type_cpla, meca_comp
!
! --------------------------------------------------------------------------------------------------
!
    rela_comp = 'VIDE'
    if (present(rela_comp_)) then
        rela_comp = rela_comp_
    endif
    defo_comp = 'VIDE'
    if (present(defo_comp_)) then
        defo_comp = defo_comp_
    endif
    meca_comp = 'VIDE'
    if (present(meca_comp_)) then
        meca_comp = meca_comp_
    endif
    type_cpla = 'VIDE'
    if (present(type_cpla_)) then
        type_cpla = type_cpla_
    endif
    kit_comp(1:4) = 'VIDE'
    if (present(kit_comp_)) then
        kit_comp(:) = kit_comp_(:)
    endif
    post_iter = 'VIDE'
    if (present(post_iter_)) then
        post_iter = post_iter_
    endif
    l_implex  = .false.
    if (present(l_implex_)) then
        l_implex = l_implex_
    endif
!
    nb_comp_elem    = 0
    comp_elem(1:20) = 'VIDE'
    call comp_meca_l(rela_comp, 'KIT_META', l_kit_meta)
    call comp_meca_l(rela_comp, 'KIT_THM' , l_kit_thm)
!
! - Create composite comportment
!
    nb_comp_elem = nb_comp_elem + 1
    comp_elem(nb_comp_elem) = rela_comp
    nb_comp_elem = nb_comp_elem + 1
    comp_elem(nb_comp_elem) = defo_comp
    nb_comp_elem = nb_comp_elem + 1
    comp_elem(nb_comp_elem) = type_cpla
    do ikit = 1, 4
        nb_comp_elem = nb_comp_elem + 1
        comp_elem(nb_comp_elem) = kit_comp(ikit)
    enddo
    if (post_iter.ne.' ') then
        nb_comp_elem = nb_comp_elem + 1
        comp_elem(nb_comp_elem) = post_iter
    endif
!
! - Reorder THM behaviours
!
    if (l_kit_thm) then
        rela_thmc = comp_elem(4)
        rela_ther = comp_elem(5)
        rela_hydr = comp_elem(6)
        rela_meca = comp_elem(7)
        comp_elem(4) = rela_meca
        comp_elem(5) = rela_hydr
        comp_elem(6) = rela_ther
        comp_elem(7) = rela_thmc
    endif
!
! - Implex
!
    if (l_implex) then
        nb_comp_elem = nb_comp_elem + 1
        comp_elem(nb_comp_elem) = 'IMPLEX'
    endif
!
! - Coding metallurgy comportment
!
    meta_code_py = ' '
    if (l_kit_meta) then
        rela_meta = kit_comp(1)
        call lccree(1, rela_meta, meta_code_py)
    endif
!
! - Coding only RELATION (Python)
!
    call lccree(1, rela_comp, rela_code_py)
!
! - Coding only DEFORMATION (Python)
!
    call lccree(1, defo_comp, defo_code_py)
!
! - Coding only mechanical part (Python)
!
    call lccree(1, meca_comp, meca_code_py)
!
! - Coding composite comportment (Python)
!
    call lccree(nb_comp_elem, comp_elem, comp_code_py)
!
    if (present(meta_code_py_)) then
        meta_code_py_ = meta_code_py
    endif
    if (present(rela_code_py_)) then
        rela_code_py_ = rela_code_py
    endif
    if (present(defo_code_py_)) then
        defo_code_py_ = defo_code_py
    endif
    if (present(meca_code_py_)) then
        meca_code_py_ = meca_code_py
    endif
    if (present(comp_code_py_)) then
        comp_code_py_ = comp_code_py
    endif
!
end subroutine
