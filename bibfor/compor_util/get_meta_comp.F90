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

subroutine get_meta_comp(rela_comp,&
                         l_plas, l_visc,&
                         l_hard_isot, l_hard_kine, l_hard_line, l_hard_rest,&
                         l_plas_tran)
!
implicit none
!
#include "asterf_types.h"
!
character(len=16), intent(in) :: rela_comp
aster_logical, optional, intent(out) :: l_plas
aster_logical, optional, intent(out) :: l_visc
aster_logical, optional, intent(out) :: l_hard_isot
aster_logical, optional, intent(out) :: l_hard_kine
aster_logical, optional, intent(out) :: l_hard_line
aster_logical, optional, intent(out) :: l_hard_rest
aster_logical, optional, intent(out) :: l_plas_tran
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility - Metallurgy
!
! Characteristics of comportment law
!
! --------------------------------------------------------------------------------------------------
!
! In  rela_comp    : comportment relation
! Out l_plas       : ASTER_TRUE if plasticity
! Out l_visc       : ASTER_TRUE if visco-plasticity
! Out l_hard_isot  : ASTER_TRUE if isotropic hardening
! Out l_hard_kine  : ASTER_TRUE if kinematic hardening
! Out l_hard_line  : ASTER_TRUE if linear hardening
! Out l_hard_rest  : ASTER_TRUE if restoration hardening
! Out l_plas_tran  : ASTER_TRUE if transformation plasticity
!
! --------------------------------------------------------------------------------------------------
!
    if (present(l_plas)) then
        l_plas      = ASTER_FALSE
        if (rela_comp(6:6) .eq. 'P') then
            l_plas = ASTER_TRUE
        endif
    endif
!
    if (present(l_visc)) then
        l_visc      = ASTER_FALSE
        if (rela_comp(6:6) .eq. 'V') then
            l_visc = ASTER_TRUE
        endif
    endif
!
    if (present(l_hard_rest)) then
        l_hard_rest = ASTER_FALSE
        if (rela_comp(1:12) .eq. 'META_P_IL_RE'     .or.&
            rela_comp(1:15) .eq. 'META_P_IL_PT_RE'  .or.&
            rela_comp(1:12) .eq. 'META_V_IL_RE'     .or.&
            rela_comp(1:15) .eq. 'META_V_IL_PT_RE'  .or.&
            rela_comp(1:13) .eq. 'META_P_INL_RE'    .or.&
            rela_comp(1:16) .eq. 'META_P_INL_PT_RE' .or.&
            rela_comp(1:13) .eq. 'META_V_INL_RE'    .or.&
            rela_comp(1:16) .eq. 'META_V_INL_PT_RE') then
            l_hard_rest = ASTER_TRUE
        endif
    endif
!
    if (present(l_plas_tran)) then
        l_plas_tran = ASTER_FALSE
        if (rela_comp(1:12) .eq. 'META_P_IL_PT'     .or.&
            rela_comp(1:13) .eq. 'META_P_INL_PT'    .or.&
            rela_comp(1:15) .eq. 'META_P_IL_PT_RE'  .or.&
            rela_comp(1:16) .eq. 'META_P_INL_PT_RE' .or.&
            rela_comp(1:12) .eq. 'META_V_IL_PT'     .or.&
            rela_comp(1:13) .eq. 'META_V_INL_PT'    .or.&
            rela_comp(1:15) .eq. 'META_V_IL_PT_RE'  .or.&
            rela_comp (1:16) .eq.'META_V_INL_PT_RE') then
            l_plas_tran = ASTER_TRUE
        endif
    endif
!
    if (present(l_hard_isot)) then
        l_hard_isot = ASTER_FALSE
        if (rela_comp(1:9) .eq. 'META_P_IL' .or.&
            rela_comp(1:9) .eq. 'META_V_IL') then
            l_hard_isot = ASTER_TRUE
        endif
    endif
!
    if (present(l_hard_kine)) then
        l_hard_kine = ASTER_FALSE
        if (rela_comp(1:9) .eq. 'META_P_CL' .or.&
            rela_comp(1:9) .eq. 'META_V_CL') then
            l_hard_kine = ASTER_TRUE
        endif
    endif
!
    if (present(l_hard_line)) then
        l_hard_line = ASTER_FALSE
        if (rela_comp(1:9) .eq. 'META_P_IL' .or.&
            rela_comp(1:9) .eq. 'META_V_IL' .or.&
            rela_comp(1:9) .eq. 'META_P_CL' .or.&
            rela_comp(1:9) .eq. 'META_V_CL') then
            l_hard_line = ASTER_TRUE
        endif
    endif
!
end subroutine
