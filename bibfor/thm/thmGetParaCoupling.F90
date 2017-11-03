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

subroutine thmGetParaCoupling(j_mater, temp)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/rcvala.h"
!
integer, intent(in) :: j_mater
real(kind=8), intent(in) :: temp
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get coupling parameters 
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater      : coded material address
! In  temp         : current temperature
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_para_l1 = 4 
    real(kind=8) :: para_vale_l1(nb_para_l1)
    integer :: icodre_l1(nb_para_l1)
    character(len=16), parameter :: para_name_l1(nb_para_l1) =(/'RHO        ', 'UN_SUR_K   ',&
                                                                'VISC       ', 'D_VISC_TEMP'/)
    integer, parameter :: nb_para_l2 = 6 
    real(kind=8) :: para_vale_l2(nb_para_l2)
    integer :: icodre_l2(nb_para_l2)
    character(len=16), parameter :: para_name_l2(nb_para_l2) =(/'RHO        ', 'UN_SUR_K   ',&
                                                                'ALPHA      ', 'CP         ',&
                                                                'VISC       ', 'D_VISC_TEMP'/)
    integer, parameter :: nb_para_g1 = 3 
    real(kind=8) :: para_vale_g1(nb_para_g1)
    integer :: icodre_g1(nb_para_g1)
    character(len=16), parameter :: para_name_g1(nb_para_g1) =(/'MASS_MOL   ',&
                                                                'VISC       ', 'D_VISC_TEMP'/)
    integer, parameter :: nb_para_g2 = 4 
    real(kind=8) :: para_vale_g2(nb_para_g2)
    integer :: icodre_g2(nb_para_g2)
    character(len=16), parameter :: para_name_g2(nb_para_g2) =(/'MASS_MOL   ', 'CP         ',&
                                                                'VISC       ', 'D_VISC_TEMP'/)
    integer, parameter :: nb_para_s = 4
    real(kind=8) :: para_vale_s(nb_para_s)
    integer :: icodre_s(nb_para_s)
    character(len=16), parameter :: para_name_s(nb_para_s)   =(/'MASS_MOL   ', 'CP         ',&
                                                                'VISC       ', 'D_VISC_TEMP'/)
    integer, parameter :: nb_para_ad = 2 
    real(kind=8) :: para_vale_ad(nb_para_ad)
    integer :: icodre_ad(nb_para_ad)
    character(len=16), parameter :: para_name_ad(nb_para_ad) =(/'COEF_HENRY ', 'CP         '/)
    integer, parameter :: nb_para_s1 = 1
    real(kind=8) :: para_vale_s1(nb_para_s1)
    integer :: icodre_s1(nb_para_s1)
    character(len=16), parameter :: para_name_s1(nb_para_s1) =(/'RHO        '/)
    integer, parameter :: nb_para_s2 = 2
    real(kind=8) :: para_vale_s2(nb_para_s2)
    integer :: icodre_s2(nb_para_s2)
    character(len=16), parameter :: para_name_s2(nb_para_s2) =(/'RHO        ', 'R_GAZ      '/)
    integer, parameter :: nb_para_s3 = 1
    real(kind=8) :: para_vale_s3(nb_para_s3)
    integer :: icodre_s3(nb_para_s3)
    character(len=16), parameter :: para_name_s3(nb_para_s3) =(/'CP         '/)
!
! --------------------------------------------------------------------------------------------------
!
    para_vale_l1(:) = 0.d0
    para_vale_l2(:) = 0.d0
    para_vale_g1(:) = 0.d0
    para_vale_g2(:) = 0.d0
    para_vale_s(:)  = 0.d0
    para_vale_ad(:) = 0.d0
    para_vale_s1(:) = 0.d0
    para_vale_s2(:) = 0.d0
!
    if (ds_thm%ds_material%l_liquid) then
        if (ds_thm%ds_behaviour%l_temp) then
            call rcvala(j_mater   , ' '         , 'THM_LIQU'  ,&
                        1         , 'TEMP'      , [temp]      ,&
                        nb_para_l2, para_name_l2, para_vale_l2,&
                        icodre_l2 , 1           , nan='NON')
            ds_thm%ds_material%liquid%rho         = para_vale_l2(1)
            ds_thm%ds_material%liquid%unsurk      = para_vale_l2(2)
            ds_thm%ds_material%liquid%alpha       = para_vale_l2(3)
            ds_thm%ds_material%liquid%cp          = para_vale_l2(4)
            ds_thm%ds_material%liquid%visc        = para_vale_l2(5)
            ds_thm%ds_material%liquid%dvisc_dtemp = para_vale_l2(6)
        else
            call rcvala(j_mater   , ' '         , 'THM_LIQU'  ,&
                        0         , ' '         , [0.d0]      ,&
                        nb_para_l1, para_name_l1, para_vale_l1,&
                        icodre_l1 , 1           , nan='NON')
            ds_thm%ds_material%liquid%rho         = para_vale_l1(1)
            ds_thm%ds_material%liquid%unsurk      = para_vale_l1(2)
            ds_thm%ds_material%liquid%visc        = para_vale_l1(3)
            ds_thm%ds_material%liquid%dvisc_dtemp = para_vale_l1(4)
        endif
    endif
    if (ds_thm%ds_material%l_gaz) then
        if (ds_thm%ds_behaviour%l_temp) then
            call rcvala(j_mater   , ' '         , 'THM_GAZ'   ,&
                        1         , 'TEMP'      , [temp]      ,&
                        nb_para_g2, para_name_g2, para_vale_g2,&
                        icodre_g2 , 1           , nan='NON')
            ds_thm%ds_material%gaz%mass_mol      = para_vale_g2(1)
            ds_thm%ds_material%gaz%cp            = para_vale_g2(2)
            ds_thm%ds_material%gaz%visc          = para_vale_g2(3)
            ds_thm%ds_material%gaz%dvisc_dtemp   = para_vale_g2(4)
        else
            call rcvala(j_mater   , ' '         , 'THM_GAZ'   ,&
                        0         , ' '         , [0.d0]      ,&
                        nb_para_g1, para_name_g1, para_vale_g1,&
                        icodre_g1 , 1           , nan='NON')
            ds_thm%ds_material%gaz%mass_mol      = para_vale_g1(1)
            ds_thm%ds_material%gaz%visc          = para_vale_g1(2)
            ds_thm%ds_material%gaz%dvisc_dtemp   = para_vale_g1(3)
        endif
    endif
    if (ds_thm%ds_material%l_steam) then
        call rcvala(j_mater   , ' '         , 'THM_VAPE_GAZ',&
                    0         , ' '         , [0.d0]        ,&
                    nb_para_s , para_name_s , para_vale_s   ,&
                    icodre_s  , 1           , nan='NON')
        ds_thm%ds_material%steam%mass_mol   = para_vale_s(1)
        ds_thm%ds_material%steam%cp         = para_vale_s(2)
        ds_thm%ds_material%steam%visc        = para_vale_s(3)
        ds_thm%ds_material%steam%dvisc_dtemp = para_vale_s(4)
    endif
    if (ds_thm%ds_material%l_ad) then
        call rcvala(j_mater   , ' '         , 'THM_AIR_DISS',&
                    1         , 'TEMP'      , [temp]        ,&
                    nb_para_ad, para_name_ad, para_vale_ad  ,&
                    icodre_ad , 1           , nan='NON')
        ds_thm%ds_material%ad%coef_henry    = para_vale_ad(1)
        ds_thm%ds_material%ad%cp            = para_vale_ad(2)
    endif
    if (ds_thm%ds_material%l_r_gaz) then
        call rcvala(j_mater   , ' '         , 'THM_DIFFU'   ,&
                    1         , 'TEMP'      , [temp]        ,&
                    nb_para_s2, para_name_s2, para_vale_s2  ,&
                    icodre_s2 , 1           , nan='NON')
        ds_thm%ds_material%solid%rho    = para_vale_s2(1)
        ds_thm%ds_material%solid%r_gaz  = para_vale_s2(2)
    else
        call rcvala(j_mater   , ' '         , 'THM_DIFFU'   ,&
                    1         , 'TEMP'      , [temp]        ,&
                    nb_para_s1, para_name_s1, para_vale_s1  ,&
                    icodre_s1 , 1           , nan='NON')
        ds_thm%ds_material%solid%rho    = para_vale_s1(1)
    endif
    if (ds_thm%ds_behaviour%l_temp) then
        call rcvala(j_mater   , ' '         , 'THM_DIFFU'   ,&
                    1         , 'TEMP'      , [temp]        ,&
                    nb_para_s3, para_name_s3, para_vale_s3  ,&
                    icodre_s3 , 1           , nan='NON')
        ds_thm%ds_material%solid%cp     = para_vale_s3(1)
    endif
!
end subroutine
