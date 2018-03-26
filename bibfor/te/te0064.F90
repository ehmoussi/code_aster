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
    integer, parameter :: nbv_steel = 8
    integer, parameter :: nbv_zirc  = 5
    integer, parameter :: nb_nd_max = 27
    character(len=16) :: phase_type
    integer :: icodre
    real(kind=8) :: dt10, dt21, instp
    real(kind=8) :: tno1, tno0, tno2
    real(kind=8) :: metaac(nb_nd_max*nbv_steel), metazi(nb_nd_max*nbv_zirc)
    integer :: nno, i_node, i_vari, itempe, itempa, itemps, iadtrc
    integer :: imate
    integer :: nb_hist, itempi, nbtrc, iadckm
    integer :: ipftrc, jftrc, jtrc, iphasi, iphasn, icompo
    integer :: jv_mater, nbcb1, nbcb2, nblexp, iadexp
!
! --------------------------------------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', nno=nno)
    ASSERT(nno .le. nb_nd_max)
    ASSERT(nbv_steel .eq. STEEL_NBVARI)
    ASSERT(nbv_zirc .eq. ZIRC_NBVARI)
!
! - Input fields
!
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPAR', 'L', itempa)
    call jevech('PTEMPER', 'L', itempe)
    call jevech('PTEMPIR', 'L', itempi)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PPHASIN', 'L', iphasi)
    call jevech('PCOMPOR', 'L', icompo)
    jv_mater  = zi(imate)
!
! - Output fields
!
    call jevech('PPHASNOU', 'E', iphasn)
!
! - Type of phase
!
    phase_type = zk16(icompo)
!
    if (phase_type .eq. 'ACIER') then
!
        call jevech('PFTRC', 'L', ipftrc)
        jftrc = zi(ipftrc)
        jtrc = zi(ipftrc+1)
!
        call rcadma(jv_mater, 'META_ACIER', 'TRC', iadtrc, icodre, 1)
!
        nbcb1 = nint(zr(iadtrc+1))
        nb_hist = nint(zr(iadtrc+2))
        nbcb2 = nint(zr(iadtrc+1+2+nbcb1*nb_hist))
        nblexp = nint(zr(iadtrc+1+2+nbcb1*nb_hist+1))
        nbtrc = nint(zr(iadtrc+1+2+nbcb1*nb_hist+2+nbcb2*nblexp+1))
        iadexp = 5 + nbcb1*nb_hist
        iadckm = 7 + nbcb1*nb_hist + nbcb2*nblexp
!
        do i_node = 1, nno
            dt10 = zr(itemps+1)
            dt21 = zr(itemps+2)
            tno1 = zr(itempe+i_node-1)
            tno0 = zr(itempa+i_node-1)
            tno2 = zr(itempi+i_node-1)
            call zacier(jv_mater,&
                        nb_hist, zr(jftrc), zr(jtrc),&
                        zr(iadtrc+3), zr(iadtrc+iadexp), &
                        nbtrc, zr(iadtrc+iadckm),&
                        tno0, tno1, tno2,&
                        dt10, dt21,&
                        zr(iphasi+STEEL_NBVARI*(i_node-1)), metaac(1+STEEL_NBVARI*(i_node-1)))
            do i_vari = 1, STEEL_NBVARI
                zr(iphasn+STEEL_NBVARI*(i_node-1)+i_vari-1) =&
                    metaac(1+STEEL_NBVARI*(i_node-1)+i_vari-1)
            end do
        end do
    else if (phase_type .eq. 'ZIRC') then
        dt10 = zr(itemps+1)
        dt21 = zr(itemps+2)
        instp= zr(itemps)+dt21
        do i_node = 1, nno
            tno1 = zr(itempe+i_node-1)
            tno2 = zr(itempi+i_node-1)
            call zedgar(jv_mater,&
                        tno1, tno2,&
                        instp, dt21,&
                        zr(iphasi+ZIRC_NBVARI*(i_node-1) ), metazi(1+ZIRC_NBVARI*(i_node-1)))
            do i_vari = 1, ZIRC_NBVARI
                zr(iphasn+ZIRC_NBVARI*(i_node-1)+i_vari-1) =&
                    metazi(1+ZIRC_NBVARI*(i_node-1)+i_vari-1)
            end do
        end do
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
