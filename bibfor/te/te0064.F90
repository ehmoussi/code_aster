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
!
subroutine te0064(option, nomte)
!
use Metallurgy_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/rcadma.h"
#include "asterfort/zacier.h"
#include "asterfort/zedgar.h"
#include "asterfort/Metallurgy_type.h"
#include "asterfort/nzcomp_prep.h"
#include "asterfort/nzcomp.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: THERMIQUE - 3D
! Option: META_ELNO
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: phase_type
    real(kind=8) :: dt10, dt21, inst2
    real(kind=8) :: tno1, tno0, tno2
    integer :: nno, i_node, itempe, itempa, jv_time
    integer :: imate, nb_vari, nume_comp
    integer :: itempi
    integer :: jv_phase_in, jv_phase_out, icompo
    integer :: jv_mater
    type(META_MaterialParameters) :: metaPara
!
! --------------------------------------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', nno=nno)
!
! - Input/Output fields
!
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPAR', 'L', itempa)
    call jevech('PTEMPER', 'L', itempe)
    call jevech('PTEMPIR', 'L', itempi)
    call jevech('PTEMPSR', 'L', jv_time)
    call jevech('PPHASIN', 'L', jv_phase_in)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PPHASNOU', 'E', jv_phase_out)
!
    phase_type = zk16(icompo)
    jv_mater   = zi(imate)
    read (zk16(icompo+3),'(I16)') nume_comp
!
! - Preparation
!
    call nzcomp_prep(jv_mater, phase_type,&
                     nb_vari , metaPara)
!
! - Time parameters: 0 - 1 - 2
!
    dt10  = zr(jv_time+1)
    dt21  = zr(jv_time+2)
    inst2 = zr(jv_time)+dt21
!
! - Loop on nodes
!
    do i_node = 1, nno
! ----- Temperatures: 0 - 1 - 2
        tno1 = zr(itempe+i_node-1)
        tno0 = zr(itempa+i_node-1)
        tno2 = zr(itempi+i_node-1)
! ----- General switch
        call nzcomp(jv_mater , metaPara , nume_comp,&
                    dt10     , dt21     , inst2    ,&
                    tno0     , tno1     , tno2     ,&
                    zr(jv_phase_in+nb_vari*(i_node-1)),&
                    zr(jv_phase_out+nb_vari*(i_node-1)))
    end do
!
end subroutine
