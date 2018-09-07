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
subroutine comp_nbvari(rela_comp    , defo_comp , type_cpla    , kit_comp_ ,&
                       post_iter_   , mult_comp_, libr_name_   ,&
                       subr_name_   , model_dim_, model_mfront_, nb_vari_  ,&
                       nb_vari_umat_, l_implex_ ,&
                       nb_vari_comp_, nume_comp_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/comp_nbvari_std.h"
#include "asterfort/comp_nbvari_kit.h"
#include "asterfort/comp_nbvari_ext.h"
!
character(len=16), intent(in) :: rela_comp
character(len=16), intent(in) :: defo_comp
character(len=16), intent(in) :: type_cpla
character(len=16), optional, intent(in) :: kit_comp_(4)
character(len=16), optional, intent(in) :: post_iter_
character(len=16), optional, intent(in) :: mult_comp_
character(len=255), optional, intent(in) :: libr_name_
character(len=255), optional, intent(in) :: subr_name_
integer, optional, intent(in) :: model_dim_
character(len=16), optional, intent(in) :: model_mfront_
integer, optional, intent(out) :: nb_vari_
integer, optional, intent(in) :: nb_vari_umat_
aster_logical, optional, intent(in) :: l_implex_
integer, optional, intent(out) :: nb_vari_comp_(4)
integer, optional, intent(out) :: nume_comp_(4)
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Count the number of internal variables
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
! In  nb_vari_umat     : number of internal variables for UMAT
! In  libr_name        : name of library if UMAT or MFront
! In  subr_name        : name of comportement in library if UMAT or MFront
! In  model_dim        : dimension of modelisation (2D or 3D)
! In  model_mfront     : type of modelisation MFront
! In  l_implex         : .true. if IMPLEX method
! Out nb_vari_comp     : number of internal variables kit comportment
! Out nume_comp        : number LCxxxx subroutine
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_vari_rela, nb_vari
    aster_logical :: l_cristal, l_kit_meta, l_kit_thm, l_kit_ddi, l_kit_cg, l_exte_comp
    aster_logical :: l_kit, l_meca_mfront
    aster_logical :: l_mfront_proto, l_mfront_offi, l_umat, l_implex
    character(len=16) :: kit_comp(4), post_iter, mult_comp, rela_meca
    integer :: nb_vari_exte, nume_comp(4)=0, nb_vari_comp(4)=0
    integer :: nb_vari_umat, model_dim
    character(len=255) :: libr_name, subr_name
    character(len=16) :: model_mfront
!
! --------------------------------------------------------------------------------------------------
!
    kit_comp(1:4) = 'VIDE'
    post_iter     = 'VIDE'
    mult_comp     = 'VIDE'
    nb_vari_umat  = 0
    nb_vari_exte  = 0
    nb_vari       = 0
    l_implex      = .false.
    l_meca_mfront = .false.
    if (present(kit_comp_)) then
        kit_comp(1:4) = kit_comp_(1:4)
    endif
    if (present(post_iter_)) then
        post_iter = post_iter_
    endif
    if (present(mult_comp_)) then
        mult_comp = mult_comp_
    endif
    if (present(nb_vari_umat_)) then
        nb_vari_umat = nb_vari_umat_
    endif
    if (present(libr_name_)) then
        libr_name = libr_name_
    endif
    if (present(subr_name_)) then
        subr_name = subr_name_
    endif
    if (present(model_dim_)) then
        model_dim = model_dim_
    endif
    if (present(model_mfront_)) then
        model_mfront = model_mfront_
    endif
    if (present(l_implex_)) then
        l_implex = l_implex_
    endif
!
! - Detection of specific cases
!
    call comp_meca_l(rela_comp, 'KIT'         , l_kit)
    call comp_meca_l(rela_comp, 'CRISTAL'     , l_cristal)
    call comp_meca_l(rela_comp, 'KIT_META'    , l_kit_meta)
    call comp_meca_l(rela_comp, 'KIT_THM'     , l_kit_thm)
    call comp_meca_l(rela_comp, 'KIT_DDI'     , l_kit_ddi)
    call comp_meca_l(rela_comp, 'KIT_CG'      , l_kit_cg)
    call comp_meca_l(rela_comp, 'EXTE_COMP'   , l_exte_comp)
    call comp_meca_l(rela_comp, 'MFRONT_PROTO', l_mfront_proto)
    call comp_meca_l(rela_comp, 'MFRONT_OFFI' , l_mfront_offi)
    call comp_meca_l(rela_comp, 'UMAT'        , l_umat)
!
! - Get number of internal variables for standard laws
!
    call comp_nbvari_std(rela_comp, defo_comp   , type_cpla  , nb_vari  ,&
                         kit_comp , post_iter   , mult_comp,&
                         l_cristal, l_implex    , &
                         nume_comp, nb_vari_rela)
!
! - Get number of internal variables for KIT
!
    if (l_kit) then
        call comp_nbvari_kit(kit_comp  , defo_comp   , nb_vari_rela,&
                             l_kit_meta, l_kit_thm   , l_kit_ddi   , l_kit_cg     ,&
                             nb_vari   , nb_vari_comp, nume_comp   , l_meca_mfront)
        if (l_meca_mfront) then
            rela_meca = kit_comp(4)
            call comp_meca_l(rela_meca, 'EXTE_COMP'   , l_exte_comp)
            call comp_meca_l(rela_meca, 'MFRONT_PROTO', l_mfront_proto)
            call comp_meca_l(rela_meca, 'MFRONT_OFFI' , l_mfront_offi)
            call comp_meca_l(rela_meca, 'UMAT'        , l_umat)
        endif
    endif
!
! - Get number of internal variables for external comportments
!
    if (l_exte_comp) then
        call comp_nbvari_ext(l_umat        , nb_vari_umat ,&
                             l_mfront_proto, l_mfront_offi,&
                             libr_name     , subr_name    ,&
                             model_dim     , model_mfront ,&
                             nb_vari_exte)
        if (l_meca_mfront) then
            nb_vari_comp(4) = nb_vari_exte
        endif
    endif
!
! - Total number of internal variables
!
    nb_vari = nb_vari_exte + nb_vari
!
! - Output
!
    if (present(nb_vari_)) then
        nb_vari_ = nb_vari
    endif
    if (present(nume_comp_)) then
        nume_comp_(1:4) = nume_comp(1:4)
    endif
    if (present(nb_vari_comp_)) then
        nb_vari_comp_(1:4) = nb_vari_comp(1:4)
    endif
!
end subroutine
