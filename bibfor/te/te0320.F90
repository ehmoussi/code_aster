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
subroutine te0320(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterc/r8vide.h"
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
! Elements: THERMIQUE - AXIS*, PLAN*
! Option: META_INIT_ELNO
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: nomres
    character(len=16) :: phase_type
    character(len=8) :: fami, poum
    integer :: icodre(1)
    real(kind=8) :: zero, metapg(63), ms0(1), zalpha, zbeta
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
!
! - Input fields
!
    call jevech('PMATERC', 'L', imate) 
    call jevech('PTEMPER', 'L', itempe)
    call jevech('PPHASIN', 'L', iphasi)
!
! - Type of phase
!
    call jevech('PCOMPOR', 'L', jv_compo)
    phase_type = zk16(jv_compo)
!
! - Output fields
!
    call jevech('PPHASNOU', 'E', iphasn)
!
! - Values required for META_INIT_ELNO vector
!
    if (phase_type .eq. 'ACIER') then
! ----- All FERRITE phases + grain size
        do j = 1, 5
            if (zr(iphasi-1+j) .eq. r8vide() .or. isnan(zr(iphasi-1+j))) then
                call utmess('F', 'META1_44')
            endif
        end do
    else if (phase_type.eq.'ZIRC') then
! ----- All ALPHA phases + transition time
        if (zr(iphasi-1+1) .eq. r8vide() .or.&
            zr(iphasi-1+2) .eq. r8vide() .or.&
            zr(iphasi-1+4) .eq. r8vide() .or.&
            isnan(zr(iphasi-1+1)) .or.&
            isnan(zr(iphasi-1+2)) .or.&
            isnan(zr(iphasi-1+4))) then
            call utmess('F', 'META1_45')
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
                metapg(STEEL_NBVARI*(i_node-1)+j) = zr(iphasi-1+j)
            end do
            metapg(STEEL_NBVARI*(i_node-1)+TEMP_MARTENSITE) = ms0(1)
            metapg(STEEL_NBVARI*(i_node-1)+STEEL_TEMP)      = tno0
            do j = 1, STEEL_NBVARI
                zr(iphasn+STEEL_NBVARI*(i_node-1)-1+j) = metapg(STEEL_NBVARI*(i_node-1)+j)
            end do
        end do
    else if (phase_type(1:4) .eq. 'ZIRC') then
        do i_node = 1, nno
            tno0 = zr(itempe+i_node-1)
            metapg(ZIRC_NBVARI*(i_node-1)+1) = zr(iphasi-1+1)
            metapg(ZIRC_NBVARI*(i_node-1)+2) = zr(iphasi-1+2)
            metapg(ZIRC_NBVARI*(i_node-1)+ZIRC_TEMP) = tno0
            metapg(ZIRC_NBVARI*(i_node-1)+TIME_TRAN) = zr(iphasi-1+4)
            zalpha = metapg(ZIRC_NBVARI*(i_node-1)+2) + metapg(ZIRC_NBVARI*(i_node-1)+1)
            zbeta  = 1-zalpha
            if (zbeta .gt. 0.1d0) then
                metapg(ZIRC_NBVARI*(i_node-1)+PALPHA1) = 0.d0
            else
                metapg(ZIRC_NBVARI*(i_node-1)+PALPHA1) = 10.d0*(zalpha-0.9d0)*zalpha
            endif
            metapg(ZIRC_NBVARI* (i_node-1)+PALPHA2) = zalpha -&
                                                      metapg(ZIRC_NBVARI*(i_node-1)+PALPHA1)
            do j = 1, ZIRC_NBVARI
                zr(iphasn+ZIRC_NBVARI*(i_node-1)-1+j) = metapg(ZIRC_NBVARI*(i_node-1)+j)
            end do
        end do
    endif
!
end subroutine
