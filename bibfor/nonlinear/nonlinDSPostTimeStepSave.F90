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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nonlinDSPostTimeStepSave(mod45       , sdmode         , sdstab ,&
                                    inst        , nume_inst      , nb_freq,&
                                    nfreq_calibr, ds_posttimestep)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/rsexch.h"
#include "asterfort/tbajli.h"
#include "asterfort/gcncon.h"
#include "asterfort/rsadpa.h"
#include "asterfort/copisd.h"
!
character(len=4), intent(in) :: mod45
character(len=8), intent(in) :: sdmode, sdstab
integer, intent(in) :: nume_inst, nb_freq, nfreq_calibr
real(kind=8), intent(in) :: inst
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Post-treatment management
!
! Save eigen values/vectors
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: field
    integer :: iret, nb_dof_stab, nb_freq_save, i_freq, jv_para
    integer :: vali(3)
    complex(kind=8), parameter :: c16bid =(0.d0,0.d0)
    real(kind=8) :: valr(4)
    character(len=24) :: ds_name, valk(3)
    character(len=16) :: mode_type, object_type
    aster_logical :: l_savefield
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... Stores for post-treatment at each time step'
    endif
!
! - Type of object
!
    nb_dof_stab = ds_posttimestep%stab_para%nb_dof_stab
    object_type = 'CHAM_NO_SDASTER'
    l_savefield = ds_posttimestep%mode_vibr%level .ne. 'CALIBRATION'
!
! - Loop on modes
!
    if (l_savefield) then
        nb_freq_save = nb_freq
    else
        nb_freq_save = 1
    endif
!
    do i_freq = 1, nb_freq_save
        if (mod45 .eq. 'VIBR') then
            mode_type = 'DEPL_VIBR'
            if (l_savefield) then
                call rsadpa(sdmode, 'L', 1, 'FREQ', i_freq, 0, sjv=jv_para)
                call rsexch('F', sdmode, 'DEPL', i_freq, field, iret)
                call gcncon('_', ds_name)
                call copisd('CHAMP_GD', 'G', field, ds_name)
                vali(1) = nume_inst
                vali(2) = nb_freq
                vali(3) = i_freq
                valr(1) = inst
                valr(2) = zr(jv_para)
                valr(3) = r8vide()
                valr(4) = r8vide()
                valk(1) = mode_type
                valk(2) = object_type
                valk(3) = ds_name
            else
                vali(1) = nume_inst
                vali(2) = nfreq_calibr
                vali(3) = 1
                valr(1) = inst
                valr(2) = r8vide()
                valr(3) = r8vide()
                valr(4) = r8vide()
                valk(1) = mode_type
                valk(2) = ' '
                valk(3) = ' '
            endif
            call tbajli(ds_posttimestep%table_io%table_name,&
                        ds_posttimestep%table_io%nb_para,&
                        ds_posttimestep%table_io%list_para,&
                        vali, valr, [c16bid], valk, 0)
        else if (mod45 .eq. 'FLAM') then
            if (nb_dof_stab .eq. 0) then
                mode_type = 'MODE_FLAMB'
                if (l_savefield) then 
                    call rsadpa(sdmode, 'L', 1, 'CHAR_CRIT', i_freq, 0, sjv=jv_para)
                    call rsexch('F', sdmode, 'DEPL', i_freq, field, iret)
                    call gcncon('_', ds_name)
                    call copisd('CHAMP_GD', 'G', field, ds_name)
                    vali(1) = nume_inst
                    vali(2) = nb_freq
                    vali(3) = i_freq
                    valr(1) = inst
                    valr(2) = r8vide()
                    valr(3) = zr(jv_para)
                    valr(4) = r8vide()
                    valk(1) = mode_type
                    valk(2) = object_type
                    valk(3) = ds_name
                else
                    vali(1) = nume_inst
                    vali(2) = nfreq_calibr
                    vali(3) = 1
                    valr(1) = r8vide()
                    valr(2) = r8vide()
                    valr(3) = r8vide()
                    valr(4) = r8vide()
                    valk(1) = mode_type
                    valk(2) = ' '
                    valk(3) = ' '
                endif
                call tbajli(ds_posttimestep%table_io%table_name,&
                            ds_posttimestep%table_io%nb_para,&
                            ds_posttimestep%table_io%list_para,&
                            vali, valr, [c16bid], valk, 0)
            endif
        endif
    end do
!
! - For stability
!
    i_freq = 1
    if (mod45 .eq. 'FLAM') then
        if (nb_dof_stab .ne. 0) then
            mode_type = 'MODE_STAB'
            if (l_savefield) then 
                call rsadpa(sdstab, 'L', 1, 'CHAR_STAB', i_freq, 0, sjv=jv_para)
                call rsexch('F', sdstab, 'DEPL', i_freq, field, iret)
                call gcncon('_', ds_name)
                call copisd('CHAMP_GD', 'G', field, ds_name)
                vali(1) = nume_inst
                vali(2) = nb_freq
                vali(3) = i_freq
                valr(1) = inst
                valr(2) = r8vide()
                valr(3) = r8vide()
                valr(4) = zr(jv_para)
                valk(1) = mode_type
                valk(2) = object_type
                valk(3) = ds_name
            else
                vali(1) = nume_inst
                vali(2) = nfreq_calibr
                vali(3) = i_freq
                valr(1) = inst
                valr(2) = r8vide()
                valr(3) = r8vide()
                valr(4) = r8vide()
                valk(1) = mode_type
                valk(2) = ' '
                valk(3) = ' '
            endif
            call tbajli(ds_posttimestep%table_io%table_name,&
                        ds_posttimestep%table_io%nb_para,&
                        ds_posttimestep%table_io%list_para,&
                        vali, valr, [c16bid], valk, 0)
        endif
    endif
!
end subroutine
