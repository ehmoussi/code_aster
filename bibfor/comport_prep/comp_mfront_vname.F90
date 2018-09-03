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
subroutine comp_mfront_vname(nb_vari    , &
                             defo_comp  , type_cpla  , post_iter,&
                             libr_name  , subr_name  , model_mfront, model_dim,&
                             vari_begin , v_vari_name)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/lcinfo.h"
#include "asterc/lcvari.h"
#include "asterc/lcdiscard.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/comp_meca_code.h"
#include "asterfort/lxlgut.h"
#include "asterc/mfront_get_number_of_internal_state_variables.h"
#include "asterc/mfront_get_internal_state_variables.h"
#include "asterc/mfront_get_internal_state_variables_types.h"
!
integer, intent(in) :: nb_vari
character(len=16), intent(in) :: defo_comp
character(len=16), intent(in) :: type_cpla
character(len=16), intent(in) :: post_iter
character(len=255), intent(in) :: libr_name
character(len=255), intent(in) :: subr_name
character(len=16), intent(in) :: model_mfront
integer, intent(in) :: model_dim
integer, intent(in) :: vari_begin
character(len=16), pointer :: v_vari_name(:)
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
! In  l_excl           : .true. if exception case (no names for internal variables)
! In  vari_excl        : name of internal variables if l_excl
! In  l_kit_meta       : .true. if metallurgy
! In  defo_comp        : DEFORMATION comportment
! In  comp_code_py     : composite coded comportment (coding in Python)
! In  rela_code_py     : coded comportment for RELATION (coding in Python)
! In  meta_code_py     : coded comportment for metallurgy (coding in Python)
! In  v_vari_name      : pointer to names of internal variables
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_vari_type, i_vari_type, i_vari, i_dime, nb_vari_mfr, nb_vari_supp, i, leng
    character(len=16) :: vari_name, m_vari_name, m_vari_type, comp_code_py
    character(len=80), pointer :: v_varim_name(:) => null()
    character(len=80), pointer :: v_varim_type(:) => null()
    character(len=16), pointer :: v_vari_supp(:) => null()
    character(len=2), parameter :: cmpv_name(6) = (/'XX','YY','ZZ','XY','XZ','YZ'/)
    character(len=2), parameter :: cmpt_name(9) = (/'F0','F1','F2','F3','F4','F5','F6','F7','F8'/)
!
! --------------------------------------------------------------------------------------------------
!
    call mfront_get_number_of_internal_state_variables(libr_name   , subr_name,&
                                                       model_mfront, nb_vari_type)
    call comp_meca_code(defo_comp_    = defo_comp,&
                        type_cpla_    = type_cpla,&
                        post_iter_    = post_iter,&
                        comp_code_py_ = comp_code_py)
    if ( nb_vari .ne. 0 ) then
        AS_ALLOCATE(vk80 = v_varim_name, size = nb_vari_type)
        AS_ALLOCATE(vk80 = v_varim_type, size = nb_vari_type)
        call mfront_get_internal_state_variables(libr_name, subr_name,&
                                                 model_mfront, v_varim_name,&
                                                 nb_vari_type)
        call mfront_get_internal_state_variables_types(libr_name, subr_name,&
                                                       model_mfront, v_varim_type)
        i_vari = 0
        do i_vari_type = 1, nb_vari_type
            m_vari_name = v_varim_name(i_vari_type)(1:16)
            m_vari_type = v_varim_type(i_vari_type)(1:16)
            leng        = lxlgut(m_vari_name)
            if (m_vari_type .eq. 'scalar') then
                i_vari = i_vari + 1
                v_vari_name(vari_begin-1+i_vari) = m_vari_name
            elseif (m_vari_type .eq. 'vector') then
                do i_dime = 1, 2*model_dim
                    if (leng .le. 14) then
                        vari_name = m_vari_name(1:leng)//cmpv_name(i_dime)
                    else
                        vari_name = m_vari_name(1:14)//cmpv_name(i_dime)
                    endif
                    i_vari = i_vari + 1
                    v_vari_name(vari_begin-1+i_vari) = vari_name
                end do
            elseif (m_vari_type .eq. 'tensor') then
                do i_dime = 1, 9
                    if (leng .le. 14) then
                        vari_name = m_vari_name(1:leng)//cmpt_name(i_dime)
                    else
                        vari_name = m_vari_name(1:14)//cmpt_name(i_dime)
                    endif
                    i_vari = i_vari + 1
                    v_vari_name(vari_begin-1+i_vari) = vari_name
                end do
            else
                ASSERT(.False.)
            endif
        end do
        nb_vari_mfr  = i_vari
        nb_vari_supp = nb_vari-nb_vari_mfr
        if (nb_vari_mfr .ne. nb_vari) then
            AS_ALLOCATE(vk16 = v_vari_supp, size = nb_vari_supp)
            call lcvari(comp_code_py, nb_vari_supp, v_vari_supp)
            do i = 1, nb_vari_supp
               v_vari_name(vari_begin-1+i+nb_vari_mfr) = v_vari_supp(i)
            end do
            AS_DEALLOCATE(vk16 = v_vari_supp)
        endif
        AS_DEALLOCATE(vk80 = v_varim_name)
        AS_DEALLOCATE(vk80 = v_varim_type)   
    endif
    call lcdiscard(comp_code_py)
!
end subroutine
