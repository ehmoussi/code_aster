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
subroutine metaZircGetParameters(jv_mater, temp, metaZircPara)
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
real(kind=8), intent(in) :: temp
type(META_ZircParameters), intent(out) :: metaZircPara
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY - Zircaloy
!
! Get material parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  jv_mater            : coded material address
! Out metaZircPara        : parameters for metallurgy of zircaloy
!
! --------------------------------------------------------------------------------------------------
!
    integer :: kpg, spt
    character(len=8) :: fami, poum
    integer, parameter :: nb_para_zirc = 12 
    real(kind=8) :: para_zirc_vale(nb_para_zirc)
    integer :: icodre_zirc(nb_para_zirc)
    character(len=16), parameter :: para_zirc_name(nb_para_zirc) =(/'TDEQ ',&
                                                                    'K    ',&
                                                                    'N    ',&
                                                                    'T1C  ',&
                                                                    'T2C  ',&
                                                                    'AC   ',&
                                                                    'M    ',&
                                                                    'QSR_K',&
                                                                    'T1R  ',&
                                                                    'T2R  ',&
                                                                    'AR   ',&
                                                                    'BR   '/)
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
    para_zirc_vale(:) = 0.d0
    call rcvalb(fami          , kpg             , spt            , poum,&
                jv_mater      , ' '             , 'META_ZIRC'    ,&
                1             , 'TEMP'          , [temp]         ,&
                nb_para_zirc , para_zirc_name   , para_zirc_vale,&
                icodre_zirc  , iarret = 1)
    metaZircPara%tdeq = para_zirc_vale(1)
    metaZircPara%k    = para_zirc_vale(2)
    metaZircPara%n    = para_zirc_vale(3)
    metaZircPara%t1c  = para_zirc_vale(4)
    metaZircPara%t2c  = para_zirc_vale(5)
    metaZircPara%ac   = para_zirc_vale(6)
    metaZircPara%m    = para_zirc_vale(7)
    metaZircPara%qsrk = para_zirc_vale(8)
    metaZircPara%t1r  = para_zirc_vale(9)
    metaZircPara%t2r  = para_zirc_vale(10)
    metaZircPara%ar   = para_zirc_vale(11)
    metaZircPara%br   = para_zirc_vale(12)
!
end subroutine
