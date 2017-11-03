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
!
subroutine thmEvalFickSteam(j_mater,&
                            satur  , pgaz  , psteam , temp,&
                            fick   , dfickt, dfickpg)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/rcvala.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: j_mater
real(kind=8), intent(in) :: satur, pgaz, psteam, temp
real(kind=8), intent(out) :: fick, dfickt, dfickpg
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Evaluate Fick coefficients for steam in gaz
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater          : coded material address
! In  satur            : saturation
! In  temp             : temperature
! In  pgaz             : pressure of gaz
! In  psteam           : pressure of steam
! Out fick             : Fick coefficient for steam in gaz
! Out dfickt           : derivative (by temperature) of Fick coefficient for steam in gaz
! Out dfickpg          : derivative (by pressure of gaz ) of Fick coefficient for steam in gaz
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: fickv_t, fickv_pv, fickv_pg, fickv_s
    real(kind=8) :: dfickv_dt, dfickv_dpg, resu_vale(1)
    integer :: icodret(1)
    integer, parameter :: nb_para1 = 3
    real(kind=8) :: para_vale1(nb_para1)
    character(len=4), parameter :: para_name1(nb_para1)  = (/'SAT ', 'PGAZ', 'PVAP'/)
    integer, parameter :: nb_resu1 = 3
    real(kind=8) :: resu_vale1(nb_resu1)
    character(len=16), parameter :: resu_name1(nb_resu1) = (/'FICKV_PV', 'FICKV_PG', 'FICKV_S '/)
    integer :: icodre1(nb_resu1)
    integer, parameter :: nb_para2 = 2
    real(kind=8) :: para_vale2(nb_para2)
    character(len=4), parameter :: para_name2(nb_para2)  = (/'TEMP', 'PGAZ'/)
    integer, parameter :: nb_resu2 = 2
    real(kind=8) :: resu_vale2(nb_resu2)
    character(len=16), parameter :: resu_name2(nb_resu2) = (/'D_FV_T ', 'D_FV_PG'/)
    integer :: icodre2(nb_resu2)
!
! --------------------------------------------------------------------------------------------------
!
    fick          = r8nnem()
    dfickt        = 0.d0
    dfickpg       = 0.d0
    resu_vale(:)  = r8nnem()
    resu_vale1(:) = 1.d0
    resu_vale2(:) = 0.d0
!
! - Get fick coefficient (depending on temperature)
!
    call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                1      , 'TEMP'   , [temp]     ,&
                1      , 'FICKV_T', resu_vale  ,&
                icodret, 1)
    fickv_t = resu_vale(1)
!
! - Get fick coefficients (depending on pressures and saturation)
!
    para_vale1(1) = satur
    para_vale1(2) = pgaz
    para_vale1(3) = psteam
    call rcvala(j_mater , ' '       , 'THM_DIFFU',&
                nb_para1, para_name1, para_vale1 ,&
                nb_resu1, resu_name1, resu_vale1 ,&
                icodre1 , 0         , nan='NON')
    fickv_pv = resu_vale1(1)
    fickv_pg = resu_vale1(2)
    fickv_s  = resu_vale1(3)
!
! - Get fick derivatives
!
    para_vale2(1) = temp
    para_vale2(2) = pgaz
    call rcvala(j_mater , ' '       , 'THM_DIFFU',&
                nb_para2, para_name2, para_vale2 ,&
                nb_resu2, resu_name2, resu_vale2 ,&
                icodre2 , 0         , nan='NON')
    dfickv_dt  = resu_vale2(1)
    dfickv_dpg = resu_vale2(2)
!
! - Results
!
    fick    = fickv_t * fickv_pv * fickv_pg * fickv_s
    dfickt  = dfickv_dt * fickv_pg * fickv_pv * fickv_s
    dfickpg = fickv_t * dfickv_dpg * fickv_pv * fickv_s
!
end subroutine
