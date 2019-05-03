! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine te0551(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/rcvalb.h"
#include "asterfort/tecach.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: THERMIQUE - 3D*, AXIS*, PLAN*
! Option: DURT_ELNO
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, idurt, iphasi, iret
    integer :: nb_node, imate, i_node, nb_vari
    integer :: icodre(5), kpg, spt
    real(kind=8) :: phase(5), valres(5), durtno
    character(len=8) :: fami, poum
    character(len=24) :: nomres(5)
    integer :: jtab(6)
!
! --------------------------------------------------------------------------------------------------
!
    fami = 'FPG1'
    kpg  = 1
    spt  = 1
    poum = '+'
    call elrefe_info(fami='RIGI', nno=nb_node)
!
    call tecach('OOO', 'PPHASIN', 'L', iret, nval=6, itab=jtab)
    nb_vari = jtab(6)
    iphasi  = jtab(1)
    call jevech('PMATERC', 'L', imate)
    call jevech('PDURT_R', 'E', idurt)
!
! - Get material properties
!
    nomres(1) = 'F1_DURT'
    nomres(2) = 'F2_DURT'
    nomres(3) = 'F3_DURT'
    nomres(4) = 'F4_DURT'
    nomres(5) = 'C_DURT'
    call rcvalb(fami, kpg, spt, poum, zi(imate),&
                ' ', 'DURT_META', 1, 'TEMP', [0.d0],&
                5, nomres, valres, icodre, 2)
!
! - Compute
!
    do i_node = 1, nb_node
        do i = 1, 5
            phase(i) = zr(iphasi+nb_vari*(i_node-1)+i-1)
        end do
        durtno = 0.d0
        do i = 1, 5
            durtno = durtno + phase(i) * valres(i)
        end do
        zr(idurt+(i_node-1)) = durtno
    end do
!
end subroutine
