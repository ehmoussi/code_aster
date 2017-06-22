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

subroutine aptnol(sdappa, model_ndim, nt_node)
!
implicit none
!
#include "asterfort/jeveuo.h"
#include "asterfort/mmnorm.h"
!
!
    character(len=19), intent(in) :: sdappa
    integer, intent(in) :: model_ndim 
    integer, intent(in) :: nt_node
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Compute normals at nodes
!
! --------------------------------------------------------------------------------------------------
!
! In  sdappa           : name of pairing datastructure
! In  model_ndim       : dimension of model
! In  nt_node          : total number of nodes
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdappa_tgno, sdappa_norl
    real(kind=8), pointer :: v_sdappa_tgno(:) => null()
    real(kind=8), pointer :: v_sdappa_norl(:) => null()
    integer :: i_node
    real(kind=8) :: tau1(3), tau2(3), norm(3), noor
!
! --------------------------------------------------------------------------------------------------
!
    sdappa_tgno = sdappa(1:19)//'.TGNO'
    sdappa_norl = sdappa(1:19)//'.NORL'
    call jeveuo(sdappa_tgno, 'L', vr = v_sdappa_tgno)
    call jeveuo(sdappa_norl, 'E', vr = v_sdappa_norl)
!
! - Loop on nodes
!
    do i_node=1, nt_node
        noor      = 0.d0
        norm(1:3) = 0.d0
        tau1(1) = v_sdappa_tgno(6*(i_node-1)+1)
        tau1(2) = v_sdappa_tgno(6*(i_node-1)+2)
        tau1(3) = v_sdappa_tgno(6*(i_node-1)+3)
        tau2(1) = v_sdappa_tgno(6*(i_node-1)+4)
        tau2(2) = v_sdappa_tgno(6*(i_node-1)+5)
        tau2(3) = v_sdappa_tgno(6*(i_node-1)+6)
        call mmnorm(model_ndim, tau1, tau2, norm, noor)
        v_sdappa_norl(3*(i_node-1)+1) = norm(1)
        v_sdappa_norl(3*(i_node-1)+2) = norm(2)
        v_sdappa_norl(3*(i_node-1)+3) = norm(3)
    end do
!
end subroutine
