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
subroutine comp_meca_name(nb_vari    , nb_vari_meca,&
                          l_excl     , vari_excl   ,&
                          l_kit_meta , l_kit_thm   , l_mfront_offi, &
                          rela_comp  , defo_comp   , kit_comp     , type_cpla, post_iter,&
                          libr_name  , subr_name   , model_mfront , model_dim,&
                          v_vari_name)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lcinfo.h"
#include "asterc/lcvari.h"
#include "asterc/lcdiscard.h"
#include "asterfort/assert.h"
#include "asterfort/comp_mfront_vname.h"
#include "asterfort/comp_meca_code.h"
!
integer, intent(in) :: nb_vari, nb_vari_meca
aster_logical, intent(in) :: l_excl
character(len=16), intent(in) :: vari_excl
aster_logical, intent(in) :: l_kit_meta, l_kit_thm, l_mfront_offi
character(len=16), intent(in) :: rela_comp, defo_comp, kit_comp(4)
character(len=16), intent(in) :: type_cpla, post_iter
character(len=255), intent(in) :: libr_name, subr_name
character(len=16), intent(in) :: model_mfront
integer, intent(in) :: model_dim
character(len=16), pointer, intent(in) :: v_vari_name(:)
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Name of internal variables
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_vari          : number of internal variables
! In  nb_vari_meca     : number of internal variables for mechanic
! In  l_excl           : .true. if exception case (no names for internal variables)
! In  vari_excl        : name of internal variables if l_excl
! In  l_kit_meta       : .true. if metallurgy
! In  l_kit_thm        : .true. if kit THM
! In  l_mfront_offi    : .true. if MFront official
! In  rela_comp        : RELATION comportment
! In  defo_comp        : DEFORMATION comportment
! In  kit_comp         : KIT comportment
! In  type_cpla        : plane stress method
! In  post_iter        : type of post_treatment
! In  libr_name        : name of library if UMAT or MFront
! In  subr_name        : name of comportement in library if UMAT or MFront
! In  model_mfront     : type of modelisation MFront
! In  model_dim        : dimension of modelisation (2D or 3D)
! In  v_vari_name      : pointer to names of internal variables
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_vari_meta, nb_vari_rela, idummy, idummy2, nb_vari_other
    character(len=6) :: phas_name(10)
    character(len=8) :: rela_name(30)
    integer :: i_vari, i_vari_meta, i_vari_rela
    character(len=16) :: comp_code_py, rela_code_py, meta_code_py
!
! --------------------------------------------------------------------------------------------------
!
    if (l_excl) then
        v_vari_name(1:nb_vari) = vari_excl
    else
        call comp_meca_code(rela_comp_  = rela_comp , defo_comp_  = defo_comp ,&
                            type_cpla_  = type_cpla , kit_comp_   = kit_comp,&
                            post_iter_  = post_iter , l_implex_   = .false._1,&
                            comp_code_py_ = comp_code_py, rela_code_py_ = rela_code_py,&
                            meta_code_py_ = meta_code_py)
        if (l_kit_meta) then
            call lcinfo(meta_code_py, idummy, nb_vari_meta, idummy2)
            call lcinfo(rela_code_py, idummy, nb_vari_rela, idummy2)
            ASSERT(nb_vari_meta .le. 10)
            ASSERT(nb_vari_rela .le. 30)
            call lcvari(meta_code_py, nb_vari_meta, phas_name)
            call lcvari(rela_code_py, nb_vari_rela, rela_name)
            i_vari = 0
            do i_vari_meta = 1, nb_vari_meta
                do i_vari_rela = 1, nb_vari_rela
                    i_vari = i_vari + 1
                    v_vari_name(i_vari) = phas_name(i_vari_meta)//'##'//rela_name(i_vari_rela)
                enddo
            enddo
            do i_vari_rela = 1, nb_vari_rela
                i_vari = i_vari + 1
                v_vari_name(i_vari) = rela_name(i_vari_rela)
            enddo
            i_vari = i_vari + 1
            v_vari_name(i_vari) = 'INDIPLAS'
            if (defo_comp .eq. 'SIMO_MIEHE') then
                i_vari = i_vari + 1
                v_vari_name(i_vari) = 'TRAC_EPSE'
            endif
            if (defo_comp .eq. 'GDEF_LOG') then
                i_vari = i_vari + 1
                v_vari_name(i_vari) = 'TXX'
                i_vari = i_vari + 1
                v_vari_name(i_vari) = 'TYY'
                i_vari = i_vari + 1
                v_vari_name(i_vari) = 'TZZ'
                i_vari = i_vari + 1
                v_vari_name(i_vari) = 'TXY'
                i_vari = i_vari + 1
                v_vari_name(i_vari) = 'TXZ'
                i_vari = i_vari + 1
                v_vari_name(i_vari) = 'TYZ'
            endif
            ASSERT(i_vari .eq. nb_vari)
        elseif (l_kit_thm) then
            nb_vari_other = nb_vari - nb_vari_meca
            if (l_mfront_offi) then
                call lcvari(comp_code_py, nb_vari_other, v_vari_name(1:nb_vari_other))
                call comp_mfront_vname(nb_vari_meca, &
                                       defo_comp    , type_cpla  , post_iter   ,&
                                       libr_name    , subr_name  , model_mfront, model_dim,&
                                       nb_vari_other, v_vari_name)
            else
                call lcvari(comp_code_py, nb_vari, v_vari_name)
            endif
        elseif (l_mfront_offi) then
            call comp_mfront_vname(nb_vari    , &
                                   defo_comp  , type_cpla  , post_iter   ,&
                                   libr_name  , subr_name  , model_mfront, model_dim,&
                                   1          , v_vari_name)
        else
            call lcvari(comp_code_py, nb_vari, v_vari_name)
        endif
        call lcdiscard(comp_code_py)
        call lcdiscard(rela_code_py)
        call lcdiscard(meta_code_py)
    endif
!
end subroutine
