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
subroutine thmEvalPermLiquGaz(hydr, j_mater    , satur, p2, temp,&
                              krl , dkrl_dsatur,&
                              krg_, dkrg_dsatur_, dkrg_dp2_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rcvala.h"
#include "asterfort/utmess.h"
#include "asterfort/permvc.h"
#include "asterfort/permvg.h"
!
character(len=16), intent(in) :: hydr
integer, intent(in) :: j_mater
real(kind=8), intent(in) :: satur, p2, temp
real(kind=8), intent(out) :: krl, dkrl_dsatur
real(kind=8), optional, intent(out) :: krg_, dkrg_dsatur_, dkrg_dp2_
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Evaluate permeability for liquid and gaz
!
! --------------------------------------------------------------------------------------------------
!
! In  hydr             : type of hydraulic law
! In  j_mater          : coded material address
! In  satur            : saturation
! In  temp             : temperature
! In  p2               : second pressure (gaz)
! Out krl              : value of kr(liquid)
! Out dkrl_dsatur      : value of d(kr(liquid))/dSatur
! Out krg              : value of kr(gaz)
! Out dkrg_dsatur      : value of d(kr(gaz))/dSatur
! Out dkrg_dp2         : value of d(kr(gaz))/dp1
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: krg, dkrg_dsatur, dkrg_dp2
    integer, parameter :: nb_para = 3
    real(kind=8) :: para_vale(nb_para)
    character(len=4), parameter :: para_name(nb_para) = (/'SAT ', 'PGAZ', 'TEMP'/)
    integer, parameter :: nb_resu = 5
    integer :: icodre(nb_resu)
    real(kind=8) :: resu_vale(nb_resu)
    character(len=16), parameter :: resu_name(nb_resu) = (/'PERM_LIQU       ','D_PERM_LIQU_SATU',&
                                                           'PERM_GAZ        ','D_PERM_SATU_GAZ ',&
                                                           'D_PERM_PRES_GAZ '/)
!
! --------------------------------------------------------------------------------------------------
!
    krl          = 0.d0
    dkrl_dsatur  = 0.d0
    krg          = 0.d0
    dkrg_dsatur  = 0.d0
    dkrg_dp2     = 0.d0
    resu_vale(:) = 0.d0
    para_vale(:) = 0.d0
!
    if (hydr .eq. 'HYDR_VGM') then
        call permvg(satur,&
                    krl  , dkrl_dsatur, krg_, dkrg_dsatur_)
        dkrg_dp2_ = 0.d0
    else if (hydr .eq. 'HYDR_VGC') then
        call permvc(satur,&
                    krl  , dkrl_dsatur, krg_, dkrg_dsatur_)
        dkrg_dp2_ = 0.d0
    else if (hydr .eq. 'HYDR_UTIL') then
        para_vale(1) = satur
        para_vale(2) = p2
        para_vale(3) = temp
        if (present(krg_)) then
            call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                        nb_para, para_name, para_vale  ,&
                        nb_resu, resu_name, resu_vale  ,&
                        icodre , 1        )
            krl          = resu_vale(1)
            dkrl_dsatur  = resu_vale(2)
            krg_         = resu_vale(3)
            dkrg_dsatur_ = resu_vale(4)
            dkrg_dp2_     = resu_vale(5)
        else
            call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                        nb_para, para_name, para_vale  ,&
                        2      , resu_name, resu_vale  ,&
                        icodre , 1        )
            krl          = resu_vale(1)
            dkrl_dsatur  = resu_vale(2)
        endif
    else if (hydr .eq. 'HYDR_ENDO') then
        para_vale(1) = satur
        para_vale(2) = p2
        para_vale(3) = temp
        if (present(krg_)) then
            call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                        nb_para, para_name, para_vale  ,&
                        nb_resu, resu_name, resu_vale  ,&
                        icodre , 1        )
            krl          = resu_vale(1)
            dkrl_dsatur  = resu_vale(2)
            krg_         = resu_vale(3)
            dkrg_dsatur_ = resu_vale(4)
            dkrg_dp2_    = resu_vale(5)
        else
            call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                        nb_para, para_name, para_vale  ,&
                        2      , resu_name, resu_vale  ,&
                        icodre , 1        )
            krl          = resu_vale(1)
            dkrl_dsatur  = resu_vale(2)
        endif
    else
        ASSERT(.false.)     
    endif
!
end subroutine
