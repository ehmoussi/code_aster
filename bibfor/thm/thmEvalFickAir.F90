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
subroutine thmEvalFickAir(j_mater,&
                          satur  , pair  , pliquid, temp,&
                          fick   , dfickt)
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
real(kind=8), intent(in) :: satur, pair , pliquid, temp
real(kind=8), intent(out) :: fick, dfickt
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Evaluate Fick coefficients for air in liquid
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater          : coded material address
! In  satur            : saturation
! In  temp             : temperature
! In  pair             : pressure of air
! In  pliquid          : pressure of liquid
! Out fick             : Fick coefficient for air in liquid
! Out dfickt           : derivative (by temperature) of Fick coefficient for air in liquid
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: ficka_t, ficka_pa, ficka_pl, ficka_s, dficka_dt 
    integer, parameter :: nb_para = 4
    real(kind=8) :: para_vale(nb_para)
    character(len=4), parameter :: para_name(nb_para)  = (/'TEMP', 'PAD ',&
                                                           'PLIQ', 'SAT '/)
    integer, parameter :: nb_resu = 5
    real(kind=8) :: resu_vale(nb_resu)
    character(len=16), parameter :: resu_name(nb_resu) = (/'FICKA_T ' , 'FICKA_PA',&
                                                           'FICKA_PL' , 'FICKA_S ',&
                                                           'D_FA_T  ' /)
    integer :: icodre(nb_resu)

!
! --------------------------------------------------------------------------------------------------
!
    fick          = 0.d0
    dfickt        = 0.d0
    resu_vale(:)  = 1.d0
    resu_vale(1)  = 0.d0
    resu_vale(5)  = 0.d0
!
! - Get fick coefficients
!
    para_vale(1) = temp
    para_vale(2) = pair
    para_vale(3) = pliquid
    para_vale(4) = satur
    call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                nb_para, para_name, para_vale  ,&
                nb_resu, resu_name, resu_vale  ,&
                icodre , 0        , nan='NON')
    ficka_t   = resu_vale(1)
    ficka_pa  = resu_vale(2)
    ficka_pl  = resu_vale(3)
    ficka_s   = resu_vale(4)
    dficka_dt = resu_vale(5)
!
! - Results
!
   fick   = ficka_t*ficka_pa*ficka_pl*ficka_s
   dfickt = dficka_dt*ficka_pa*ficka_pl*ficka_s
!
end subroutine
