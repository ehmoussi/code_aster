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
subroutine te0321(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
#include "asterfort/Metallurgy_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: THERMIQUE - 3D
! Option: META_INIT_ELNO
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
    character(len=24) :: nomres
    character(len=16) :: phase_type
    character(len=8) :: fami, poum
    integer :: icodre(1)
    real(kind=8) :: metaac(nb_nd_max*nbv_steel), metazi(nb_nd_max*nbv_zirc)
    real(kind=8) :: zero, ms0(1), zalpha, zbeta
    real(kind=8) :: tno0
    integer :: nno
    integer :: jv_compo, j, i_node, kpg, spt
    integer :: imate, itempe, iphasi, iphasn
!
! --------------------------------------------------------------------------------------------------
!
    zero = 0.d0
    fami = 'FPG1'
    kpg  = 1
    spt  = 1
    poum = '+'
    call elrefe_info(fami='RIGI',nno=nno)
    ASSERT(nno .le. nb_nd_max)
    ASSERT(nbv_steel .eq. STEEL_NBVARI)
    ASSERT(nbv_zirc .eq. ZIRC_NBVARI)
!
! - Input fields
!
    call jevech('PMATERC', 'L', imate) 
    call jevech('PTEMPER', 'L', itempe)
    call jevech('PPHASIN', 'L', iphasi)
    call jevech('PCOMPOR', 'L', jv_compo)
!
! - Output fields
!
    call jevech('PPHASNOU', 'E', iphasn)
!
! - Type of phase
!
    phase_type = zk16(jv_compo)
!
! - Values required for META_INIT_ELNO vector
!
    if (phase_type .eq. 'ACIER') then
! ----- All phases
        do j = 1, 5
            if (zr(iphasi-1+j) .eq. r8vide() .or. isnan(zr(iphasi-1+j))) then
                call utmess('F', 'META1_44')
            endif
        end do
! ----- Grain size
        if (zr(iphasi-1+SIZE_GRAIN) .eq. r8vide() .or. isnan(zr(iphasi-1+SIZE_GRAIN))) then
            call utmess('F', 'META1_46')
        endif
    else if (phase_type.eq.'ZIRC') then
! ----- All phases
        do j = 1, 3
            if (zr(iphasi-1+j) .eq. r8vide() .or. isnan(zr(iphasi-1+j))) then
                call utmess('F', 'META1_45')
            endif
        end do
! ----- Transition time
        if (zr(iphasi-1+TIME_TRAN) .eq. r8vide() .or. isnan(zr(iphasi-1+TIME_TRAN))) then
            call utmess('F', 'META1_47')
        endif
    endif
!
    if (phase_type .eq. 'ACIER') then
        nomres = 'MS0'
        call rcvalb(fami, kpg, spt, poum, zi(imate),&
                    ' ', 'META_ACIER', 0, ' ', [0.d0],&
                    1, nomres, ms0, icodre, 1)
        do i_node = 1, nno
            tno0 = zr(itempe+i_node-1)
            do j = 1, 5
                metaac(STEEL_NBVARI*(i_node-1)+j) = zr(iphasi-1+j)
            end do
            metaac(STEEL_NBVARI*(i_node-1)+TEMP_MARTENSITE) = ms0(1)
            metaac(STEEL_NBVARI*(i_node-1)+STEEL_TEMP)      = tno0
            do j = 1, STEEL_NBVARI
                zr(iphasn+STEEL_NBVARI*(i_node-1)-1+j) = metaac(STEEL_NBVARI*(i_node-1)+j)
            end do
        end do
    else if (phase_type .eq. 'ZIRC') then
        do i_node = 1, nno
            tno0 = zr(itempe+i_node-1)
            metazi(ZIRC_NBVARI*(i_node-1)+PALPHA1) = zr(iphasi-1+PALPHA1)
            metazi(ZIRC_NBVARI*(i_node-1)+PALPHA2) = zr(iphasi-1+PALPHA2)
            metazi(ZIRC_NBVARI*(i_node-1)+ZIRC_TEMP) = tno0
            metazi(ZIRC_NBVARI*(i_node-1)+TIME_TRAN) = zr(iphasi-1+TIME_TRAN)
            zalpha = metazi(ZIRC_NBVARI*(i_node-1)+PALPHA1) + metazi(ZIRC_NBVARI*(i_node-1)+PALPHA2)
            zbeta  = 1.d0-zalpha
            if (zbeta .gt. 0.1d0) then
                metazi(ZIRC_NBVARI*(i_node-1)+PALPHA1) = 0.d0
            else
                metazi(ZIRC_NBVARI*(i_node-1)+PALPHA1) = 10.d0*(zalpha-0.9d0)*zalpha
            endif
            metazi(ZIRC_NBVARI* (i_node-1)+PALPHA2) = zalpha -&
                                                      metazi(ZIRC_NBVARI*(i_node-1)+PALPHA1)
            metazi(ZIRC_NBVARI* (i_node-1)+PBETA)   = zbeta
            do j = 1, ZIRC_NBVARI
                zr(iphasn+ZIRC_NBVARI*(i_node-1)-1+j) = metazi(ZIRC_NBVARI*(i_node-1)+j)
            end do
        end do
    endif
!
end subroutine
