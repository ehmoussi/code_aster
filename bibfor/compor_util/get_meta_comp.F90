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

subroutine get_meta_comp(rela_comp,&
                         l_plas, l_visc,&
                         l_hard_isot, l_hard_kine, l_hard_line, l_hard_rest,&
                         l_plas_tran)
!
implicit none
!
!
    character(len=16), intent(in) :: rela_comp
    logical, optional, intent(out) :: l_plas
    logical, optional, intent(out) :: l_visc
    logical, optional, intent(out) :: l_hard_isot
    logical, optional, intent(out) :: l_hard_kine
    logical, optional, intent(out) :: l_hard_line
    logical, optional, intent(out) :: l_hard_rest
    logical, optional, intent(out) :: l_plas_tran
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
! Out l_plas       : .true. if plasticity
! Out l_visc       : .true. if visco-plasticity
! Out l_hard_isot  : .true. if isotropic hardening
! Out l_hard_kine  : .true. if kinematic hardening
! Out l_hard_line  : .true. if linear hardening
! Out l_hard_rest  : .true. if restoration hardening
! Out l_plas_tran  : .true. if transformation plasticity
!
! --------------------------------------------------------------------------------------------------
!
    if (present(l_plas)) then
        l_plas      = .false.
        if (rela_comp(6:6) .eq. 'P') then
            l_plas = .true.
        endif
    endif
!
    if (present(l_visc)) then
        l_visc      = .false.
        if (rela_comp(6:6) .eq. 'V') then
            l_visc = .true.
        endif
    endif
!
    if (present(l_hard_rest)) then
        l_hard_rest = .false.
        if (rela_comp(1:12) .eq. 'META_P_IL_RE'     .or.&
            rela_comp(1:15) .eq. 'META_P_IL_PT_RE'  .or.&
            rela_comp(1:12) .eq. 'META_V_IL_RE'     .or.&
            rela_comp(1:15) .eq. 'META_V_IL_PT_RE'  .or.&
            rela_comp(1:13) .eq. 'META_P_INL_RE'    .or.&
            rela_comp(1:16) .eq. 'META_P_INL_PT_RE' .or.&
            rela_comp(1:13) .eq. 'META_V_INL_RE'    .or.&
            rela_comp(1:16) .eq. 'META_V_INL_PT_RE') then
            l_hard_rest = .true.
        endif
    endif
!
    if (present(l_plas_tran)) then
        l_plas_tran = .false.
        if (rela_comp(1:12) .eq. 'META_P_IL_PT'     .or.&
            rela_comp(1:13) .eq. 'META_P_INL_PT'    .or.&
            rela_comp(1:15) .eq. 'META_P_IL_PT_RE'  .or.&
            rela_comp(1:16) .eq. 'META_P_INL_PT_RE' .or.&
            rela_comp(1:12) .eq. 'META_V_IL_PT'     .or.&
            rela_comp(1:13) .eq. 'META_V_INL_PT'    .or.&
            rela_comp(1:15) .eq. 'META_V_IL_PT_RE'  .or.&
            rela_comp (1:16) .eq.'META_V_INL_PT_RE') then
            l_plas_tran = .true.
        endif
    endif
!
    if (present(l_hard_isot)) then
        l_hard_isot = .false.
        if (rela_comp(1:9) .eq. 'META_P_IL' .or.&
            rela_comp(1:9) .eq. 'META_V_IL') then
            l_hard_isot = .true.
        endif
    endif
!
    if (present(l_hard_kine)) then
        l_hard_kine = .false.
        if (rela_comp(1:9) .eq. 'META_P_CL' .or.&
            rela_comp(1:9) .eq. 'META_V_CL') then
            l_hard_kine = .true.
        endif
    endif
!
    if (present(l_hard_line)) then
        l_hard_line = .false.
        if (rela_comp(1:9) .eq. 'META_P_IL' .or.&
            rela_comp(1:9) .eq. 'META_V_IL' .or.&
            rela_comp(1:9) .eq. 'META_P_CL' .or.&
            rela_comp(1:9) .eq. 'META_V_CL') then
            l_hard_line = .true.
        endif
    endif
!
end subroutine
