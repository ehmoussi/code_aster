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
subroutine metaSteelGetParameters(jv_mater, metaSteelPara)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: jv_mater
type(META_SteelParameters), intent(out) :: metaSteelPara
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY - Steel
!
! Get material parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  jv_mater            : coded material address
! Out metaSteelPara       : parameters for metallurgy of steel
!
! --------------------------------------------------------------------------------------------------
!
    integer :: kpg, spt
    character(len=8) :: fami, poum
    integer, parameter :: nb_para_steel = 7 
    real(kind=8) :: para_steel_vale(nb_para_steel)
    integer :: icodre_steel(nb_para_steel)
    character(len=16), parameter :: para_steel_name(nb_para_steel) =(/'AR3   ',&
                                                                      'ALPHA ',&
                                                                      'MS0   ',&
                                                                      'AC1   ',&
                                                                      'AC3   ',&
                                                                      'TAUX_1',&
                                                                      'TAUX_3'/)
    integer, parameter :: nb_para_auste = 4
    real(kind=8) :: para_auste_vale(nb_para_auste)
    integer :: icodre_auste(nb_para_auste)
    character(len=16), parameter :: para_auste_name(nb_para_auste) =(/'LAMBDA0',&
                                                                      'QSR_K  ',&
                                                                      'D10    ',&
                                                                      'WSR_K  '/)
!            
! --------------------------------------------------------------------------------------------------
!
    fami = 'FPG1'
    kpg  = 1
    spt  = 1
    poum = '+'
!
! - Get parameters for behaviour law of steel
!
    para_steel_vale(:) = 0.d0
    call rcvalb(fami          , kpg             , spt            , poum,&
                jv_mater      , ' '             , 'META_ACIER'   ,&
                1             , 'INST'          , [0.d0]         ,&
                nb_para_steel , para_steel_name , para_steel_vale,&
                icodre_steel , iarret = 1)
    metaSteelPara%ar3    = para_steel_vale(1)
    metaSteelPara%alpha  = para_steel_vale(2)
    metaSteelPara%ms0    = para_steel_vale(3)
    metaSteelPara%ac1    = para_steel_vale(4)
    metaSteelPara%ac3    = para_steel_vale(5)
    metaSteelPara%taux_1 = para_steel_vale(6)
    metaSteelPara%taux_3 = para_steel_vale(7)
!
! - Get parameters for austenite grain
!
    para_auste_vale(:) = 0.d0
    call rcvalb(fami          , kpg             , spt            , poum,&
                jv_mater      , ' '             , 'META_ACIER'   ,&
                1             , 'INST'          , [0.d0]         ,&
                nb_para_auste , para_auste_name , para_auste_vale,&
                icodre_auste  , iarret = 0      , nan = 'NON')
    metaSteelPara%austenite%lambda0 = para_auste_vale(1)
    metaSteelPara%austenite%qsr_k   = para_auste_vale(2)
    metaSteelPara%austenite%d10     = para_auste_vale(3)
    metaSteelPara%austenite%wsr_k   = para_auste_vale(4)
    if ((icodre_auste(1) .eq. 0) .and. (icodre_auste(3) .eq. 1)) then
        call utmess('F', 'METALLURGY1_73')
    endif
!
! - Upadate size of martensite grain ?
!
    if (icodre_auste(1) .eq. 0) then
        metaSteelPara%l_grain_size = ASTER_TRUE
        if (metaSteelPara%austenite%lambda0 .le. r8prem()) then
            metaSteelPara%l_grain_size = ASTER_FALSE
        endif
    else
        metaSteelPara%l_grain_size = ASTER_FALSE
    endif
!
end subroutine
