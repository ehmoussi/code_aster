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

subroutine apsvnl(sdcont_defi, sdappa, model_ndim, nt_node)
!
implicit none
!
#include "asterfort/jeveuo.h"
#include "asterfort/cfnumn.h"
!
! aslint: disable=W1306
!
    character(len=24), intent(in) :: sdcont_defi
    character(len=19), intent(in) :: sdappa
    integer, intent(in) :: model_ndim 
    integer, intent(in) :: nt_node
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Smooth normals at nodes
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont_defi      : name of contact definition datastructure (from DEFI_CONTACT)
! In  sdappa           : name of pairing datastructure
! In  model_ndim       : dimension of model
! In  nt_node          : total number of nodes
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: sdappa_psno
    character(len=24) :: sdappa_norl
    real(kind=8), pointer :: v_sdappa_psno(:) => null()
    real(kind=8), pointer :: v_sdappa_norl(:) => null()
    integer :: i_node, i_dime, node_curr
    integer :: node_indx(nt_node), node_nume(nt_node)
!
! --------------------------------------------------------------------------------------------------
!
    sdappa_psno = sdappa(1:14)//'.PSNO'
    sdappa_norl = sdappa(1:19)//'.NORL'
    call jeveuo(sdappa_psno//'.VALE', 'E', vr = v_sdappa_psno)
    call jeveuo(sdappa_norl         , 'L', vr = v_sdappa_norl)
!
    do i_node = 1,nt_node
        node_indx(i_node) = i_node
    end do
!
    call cfnumn(sdcont_defi, nt_node, node_indx, node_nume)
!
    do i_node = 1, nt_node
        node_curr = node_nume(i_node)
        do i_dime=1,model_ndim
            v_sdappa_psno(3*(node_curr-1)+i_dime) = &
                v_sdappa_norl(3*(i_node-1)+i_dime)
        end do
    end do
!
end subroutine
