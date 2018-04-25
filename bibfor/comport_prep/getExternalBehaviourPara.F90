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
subroutine getExternalBehaviourPara(mesh           , v_model_elem  , &
                                    rela_comp      , kit_comp      , &
                                    l_comp_external, comp_exte     , &
                                    keywf_         , i_comp_       , elem_type_,&
                                    type_cpla_in_  , type_cpla_out_)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/comp_read_exte.h"
#include "asterfort/comp_read_typmod.h"
#include "asterc/mfront_get_strain_model.h"
!
character(len=8), intent(in) :: mesh
integer, intent(in), pointer :: v_model_elem(:)
character(len=16), intent(in) :: rela_comp
character(len=16), intent(in) :: kit_comp(4)
aster_logical, intent(out) :: l_comp_external
type(Behaviour_External), intent(inout)   :: comp_exte
character(len=16), optional, intent(in) :: keywf_
integer, optional, intent(in) :: i_comp_
integer, optional, intent(in) :: elem_type_
character(len=16), optional, intent(in) :: type_cpla_in_
character(len=16), optional, intent(out) :: type_cpla_out_
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get parameters for external programs (MFRONT/UMAT)
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  v_model_elem     : pointer to list of elements in model
! In  elem_type        : type of element
!                         0 -  Get from affectation
! In  rela_comp        : RELATION comportment
! In  kit_comp         : KIT comportment
! Out l_comp_external  : .true. if external programs for behaviour
! IO  comp_exte        : values defining external behaviour
! In  keywf            : factor keyword to read (COMPORTEMENT)
! In  i_comp           : factor keyword index
! In  type_cpla_in     : stress plane hypothesis if known
! Out type_cpla_out    : stress plane hypothesis (for Deborst)
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_kit_thm
    character(len=16) :: rela_comp_ask, keywf
    integer :: i_comp
    aster_logical :: l_mfront_proto, l_mfront_offi, l_umat
    character(len=255) :: libr_name, subr_name
    integer :: nb_vari_umat
    character(len=16) :: model_mfront, type_cpla_out, type_cpla_in
    integer :: model_dim, elem_type, strain_model
!
! --------------------------------------------------------------------------------------------------
!
    l_umat         = ASTER_FALSE
    l_mfront_proto = ASTER_FALSE
    l_mfront_offi  = ASTER_FALSE
    keywf          = 'None'
    i_comp         = 0
    libr_name      = ' '
    subr_name      = ' '
    nb_vari_umat   = 0
    model_mfront   = ' '
    model_dim      = 0
    type_cpla_out  = 'VIDE'
    if (present(type_cpla_in_)) then
        type_cpla_in = type_cpla_in_
    endif
    elem_type      = 0
    if (present(elem_type_)) then
        elem_type = elem_type_ 
    endif
    strain_model   = 0
!
! - Read from command file or not ?
!
    if (present(keywf_)) then
        keywf       = keywf_
        i_comp      = i_comp_
    endif  
!
! - Select comportement
!
    call comp_meca_l(rela_comp, 'KIT_THM', l_kit_thm)
    if (l_kit_thm) then
        rela_comp_ask = kit_comp(4)
    else
        rela_comp_ask = rela_comp
    endif
!
! - Detect type
!
    call comp_meca_l(rela_comp_ask, 'UMAT'        , l_umat)
    call comp_meca_l(rela_comp_ask, 'MFRONT_OFFI' , l_mfront_offi)
    call comp_meca_l(rela_comp_ask, 'MFRONT_PROTO', l_mfront_proto)
!
! - Get parameters for external programs (MFRONT/UMAT)
!
    call comp_read_exte(rela_comp_ask, keywf         , i_comp       ,&
                        l_umat       , l_mfront_proto, l_mfront_offi,&
                        libr_name    , subr_name     , nb_vari_umat)
!
! - Get model for MFRONT
!
    if (l_mfront_proto .or. l_mfront_offi) then
        if (associated(v_model_elem) ) then
! --------- For *_NON_LINE cases
            call comp_read_typmod(mesh     , v_model_elem, elem_type    ,&
                                  keywf    , i_comp      , rela_comp    , type_cpla_in,&
                                  model_dim, model_mfront, type_cpla_out)
        else
! --------- For CALC_POINT_MAT case
            model_dim    = 3
            model_mfront = '_Tridimensional'
        endif
    endif
!
! - Get strain model for MFRONT
!
    if (l_mfront_proto .or. l_mfront_offi) then
        call mfront_get_strain_model(libr_name   , subr_name,&
                                     model_mfront, strain_model)
    endif
!
! - Global flag
!
    l_comp_external = l_mfront_proto .or. l_mfront_offi .or. l_umat
!
! - Save
!
    if (present(type_cpla_out_)) then
        type_cpla_out_ = type_cpla_out
    endif
    comp_exte%libr_name      = libr_name 
    comp_exte%subr_name      = subr_name
    comp_exte%model_mfront   = model_mfront
    comp_exte%model_dim      = model_dim
    comp_exte%nb_vari_umat   = nb_vari_umat
    comp_exte%l_umat         = l_umat
    comp_exte%l_mfront_proto = l_mfront_proto
    comp_exte%l_mfront_offi  = l_mfront_offi
    comp_exte%strain_model   = strain_model
!
end subroutine
