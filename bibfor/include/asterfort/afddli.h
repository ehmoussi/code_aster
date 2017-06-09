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

!
!
#include "asterf_types.h"
!
interface
    subroutine afddli(model, gran_cmp_nb, gran_cmp_name, node_nume, node_name, &
                      prnm, repe_type, repe_defi, coef_type, cmp_nb, &
                      cmp_name, cmp_acti, vale_type, vale_real, vale_func, &
                      vale_cplx, cmp_count, list_rela, lxfem, jnoxfl, &
                      jnoxfv, ch_xfem_stat, ch_xfem_lnno, ch_xfem_ltno, connex_inv,&
                      mesh, ch_xfem_heav)
        character(len=8), intent(in) :: model
        integer, intent(in) :: gran_cmp_nb
        character(len=8), intent(in) :: gran_cmp_name(gran_cmp_nb)
        integer, intent(in) :: node_nume 
        character(len=8), intent(in) :: node_name
        integer, intent(in) :: prnm(*)
        integer, intent(in) :: repe_type
        real(kind=8), intent(in) :: repe_defi(3)
        character(len=4), intent(in) :: coef_type
        integer, intent(in) :: cmp_nb
        character(len=16), intent(in) :: cmp_name(cmp_nb)
        integer, intent(in) :: cmp_acti(cmp_nb)
        character(len=4), intent(in) :: vale_type
        real(kind=8), intent(in) :: vale_real(cmp_nb)
        character(len=8), intent(in) :: vale_func(cmp_nb)
        complex(kind=8), intent(in) ::  vale_cplx(cmp_nb)
        integer, intent(inout) :: cmp_count(cmp_nb)
        character(len=19), intent(in) :: list_rela
        aster_logical, intent(in) :: lxfem
        integer, intent(in) :: jnoxfl
        integer, intent(in) :: jnoxfv
        character(len=19), intent(in) :: connex_inv
        character(len=19), intent(in) :: ch_xfem_stat
        character(len=19), intent(in) :: ch_xfem_lnno
        character(len=19), intent(in) :: ch_xfem_ltno
        character(len=19), intent(in) :: ch_xfem_heav
        character(len=8), intent(in) :: mesh
    end subroutine afddli
end interface
