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

subroutine char_xfem(mesh, model, l_xfem, connex_inv, ch_xfem_stat,&
                     ch_xfem_node, ch_xfem_lnno, ch_xfem_ltno, ch_xfem_heav)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/celces.h"
#include "asterfort/cncinv.h"
#include "asterfort/cnocns.h"
#include "asterfort/jeexin.h"
!
!
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
    aster_logical, intent(out) :: l_xfem
    character(len=19), intent(out) :: connex_inv
    character(len=19), intent(out) :: ch_xfem_node
    character(len=19), intent(out) :: ch_xfem_stat
    character(len=19), intent(out) :: ch_xfem_lnno
    character(len=19), intent(out) :: ch_xfem_ltno
    character(len=19), intent(out) :: ch_xfem_heav
!
! --------------------------------------------------------------------------------------------------
!
! AFFE_CHAR_MECA
!
! Get fields for XFEM method
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh         : name of mesh
! In  model        : name of model
! Out l_xfem       : .true. if xfem
! Out connex_inv   : inverse connectivity (blank if not xfem)
! Out ch_xfem_node : xfem node-field (blank if not xfem)
! Out ch_xfem_stat : status of nodes field (blank if not xfem)
! Out ch_xfem_lnno : normal level-set field (blank if not xfem)
! Out ch_xfem_ltno : tangent level-set field (blank if not xfem)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ier
!
! --------------------------------------------------------------------------------------------------
!
!
!
! - Initializations
!
    l_xfem = .false.
    ch_xfem_node = ' '
    ch_xfem_stat = ' '
    ch_xfem_lnno = ' '
    ch_xfem_ltno = ' '
    connex_inv = ' '
!
    call jeexin(model//'.XFEM_CONT', ier)
    if (ier .ne. 0) then
        l_xfem = .true.
        connex_inv = '&&CHXFEM.CNXINV'
        call cncinv(mesh, [0], 0, 'V', connex_inv)
        ch_xfem_node = '&&CHXFEM.NOXFEM'
        call cnocns(model//'.NOXFEM', 'V', ch_xfem_node)
        ch_xfem_stat = '&&CHXFEM.STAT'
        ch_xfem_lnno = '&&CHXFEM.LNNO'
        ch_xfem_ltno = '&&CHXFEM.LTNO'
        ch_xfem_heav = '&&CHXFEM.HEAV'
        call celces(model//'.STNO', 'V', ch_xfem_stat)
        call celces(model//'.LNNO', 'V', ch_xfem_lnno)
        call celces(model//'.LTNO', 'V', ch_xfem_ltno)
        call celces(model//'.TOPONO.HNO', 'V', ch_xfem_heav)
    endif
!
end subroutine
