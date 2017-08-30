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

subroutine thmGetParaHydr(hydr, j_mater)
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
character(len=16), intent(in) :: hydr
integer, intent(in) :: j_mater
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get hydraulic parameters (for Mualem-Van Genuchten)
!
! --------------------------------------------------------------------------------------------------
!
! In  hydr         : type of hydraulic law
! In  j_mater      : coded material address
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_para_vgm = 5 
    real(kind=8) :: para_vale_vgm(nb_para_vgm)
    integer :: icodre_vgm(nb_para_vgm)
    character(len=16), parameter :: para_name_vgm(nb_para_vgm) =(/'VG_N    ',&
                                                                  'VG_PR   ',&
                                                                  'VG_SR   ',&
                                                                  'VG_SMAX ',&
                                                                  'VG_SATUR' /)
    integer, parameter :: nb_para = 1 
    real(kind=8) :: para_vale(nb_para)
    integer :: icodre(nb_para)
    character(len=16), parameter :: para_name(nb_para) = (/'EMMAG'/)
!
! --------------------------------------------------------------------------------------------------
!
    para_vale(:)     = 0.d0
    para_vale_vgm(:) = 0.d0
    if ((hydr.eq.'HYDR_VGM') .or. (hydr.eq.'HYDR_VGC')) then
        call rcvala(j_mater    , ' '          , 'THM_DIFFU'  ,&
                    0          , ' '          , [0.d0]       ,&
                    nb_para_vgm, para_name_vgm, para_vale_vgm, icodre_vgm,&
                    1)
        ds_thm%ds_material%hydr%n      = para_vale_vgm(1)
        ds_thm%ds_material%hydr%pr     = para_vale_vgm(2)
        ds_thm%ds_material%hydr%sr     = para_vale_vgm(3)
        ds_thm%ds_material%hydr%smax   = para_vale_vgm(4)
        ds_thm%ds_material%hydr%satuma = para_vale_vgm(5)
        if (icodre_vgm(1) .eq. 1) then
            call utmess('F', 'THM1_94')
        endif
    endif
!
! - For storing coefficient
!
    call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                0      , ' '      , [0.d0]     ,&
                nb_para, para_name, para_vale  , icodre,&
                0      , nan='NON')
    if (icodre(1) .eq. 0) then
        ds_thm%ds_material%hydr%l_emmag = ASTER_TRUE
        if (ds_thm%ds_elem%l_dof_meca) then
            call utmess('F', 'THM1_5')
        endif
        if (ds_thm%ds_elem%l_weak_coupling) then
            call utmess('F', 'CHAINAGE_5')
        endif
    endif
    ds_thm%ds_material%hydr%emmag = para_vale(1)
!
end subroutine
