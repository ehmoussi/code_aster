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
subroutine comp_nbvari_std(rela_comp , defo_comp    , type_cpla   ,&
                           nb_vari   ,&
                           kit_comp_ , post_iter_   , mult_comp_  ,&
                           l_cristal_, l_implex_    , type_model2_,&
                           nume_comp_, nb_vari_rela_)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lcinfo.h"
#include "asterc/lcdiscard.h"
#include "asterfort/assert.h"
#include "asterfort/comp_meca_code.h"
#include "asterfort/jeveuo.h"
!
character(len=16), intent(in) :: rela_comp
character(len=16), intent(in) :: defo_comp
character(len=16), intent(in) :: type_cpla
integer, intent(out) :: nb_vari
character(len=16), optional, intent(in) :: kit_comp_(4)
character(len=16), optional, intent(in) :: post_iter_
character(len=16), optional, intent(in) :: mult_comp_
aster_logical, optional, intent(in) :: l_cristal_
aster_logical, optional, intent(in) :: l_implex_
character(len=16), optional, intent(in) :: type_model2_
integer, optional, intent(out) :: nb_vari_rela_
integer, optional, intent(out) :: nume_comp_(4)
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get number of internal variables for standard constitutive laws
!
! --------------------------------------------------------------------------------------------------
!
! In  rela_comp        : RELATION comportment
! In  defo_comp        : DEFORMATION comportment
! In  type_cpla        : plane stress method
! Out nb_vari          : number of internal variables
! In  kit_comp         : KIT comportment
! In  post_iter        : type of post_treatment
! In  mult_comp        : multi-comportment
! In  l_cristal        : .true. if *CRISTAL comportment
! In  l_implex         : .true. if IMPLEX method
! In  type_model2      : type of modelization (TYPMOD2)
! Out nb_vari_rela     : number of internal variables for RELATION
! Out nume_comp        : number LCxxxx subroutine
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: kit_comp(4), post_iter, mult_comp, type_model2
    aster_logical :: l_cristal, l_implex
    integer :: nb_vari_rela, nume_comp(4)
    character(len=16) :: comp_code_py, rela_code_py
    integer :: idummy, idummy2
    character(len=8) :: sdcomp
    integer :: nb_vari_cris
    integer, pointer :: v_cpri(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    kit_comp(:) = 'VIDE'
    if (present(kit_comp_)) then
        kit_comp(:) = kit_comp_(:)
    endif
    post_iter = 'VIDE'
    if (present(post_iter_)) then
        post_iter = post_iter_
    endif
    mult_comp = 'VIDE'
    if (present(mult_comp_)) then
        mult_comp = mult_comp_
    endif
    l_cristal = .false.
    if (present(l_cristal_)) then
        l_cristal = l_cristal_
    endif
    l_implex  = .false.
    if (present(l_implex_)) then
        l_implex = l_implex_
    endif
    type_model2 = 'VIDE'
    if (present(type_model2_)) then
        type_model2 = type_model2_
    endif
    nb_vari      = 0
    nb_vari_rela = 0
    nume_comp(:) = 0
!
! - Coding composite comportment (Python)
!
    call comp_meca_code(rela_comp_  = rela_comp , defo_comp_  = defo_comp ,&
                        type_cpla_  = type_cpla , kit_comp_   = kit_comp,&
                        post_iter_  = post_iter , l_implex_   = l_implex,&
                        type_model2_  = type_model2,&
                        comp_code_py_ = comp_code_py, rela_code_py_ = rela_code_py)
!
! - Get number of variables
!
    call lcinfo(rela_code_py, idummy, nb_vari_rela, idummy2)
    call lcinfo(comp_code_py, nume_comp(1), nb_vari, idummy2)
!
! - Special for CRISTAL
!
    if (l_cristal) then
        sdcomp = mult_comp(1:8)
        call jeveuo(sdcomp//'.CPRI', 'L', vi=v_cpri)
        nb_vari_cris = v_cpri(3)
        nb_vari      = nb_vari + nb_vari_cris
        if (defo_comp .eq. 'SIMO_MIEHE') then
            nb_vari = nb_vari + 3 + 9
        endif
    endif
!
! - End of encoding
!
    call lcdiscard(comp_code_py)
    call lcdiscard(rela_code_py)
!
! - Copy
!
    if (present(nume_comp_)) then
        nume_comp_(1:4) = nume_comp(1:4)
    endif
    if (present(nb_vari_rela_)) then
        nb_vari_rela_ = nb_vari_rela
    endif
!
end subroutine
