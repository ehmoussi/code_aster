! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
interface
    subroutine calcPrepDataMeca(model          , mate          , mateco,  cara_elem,&
                                disp_prev      , disp_cumu_inst, vari_prev, sigm_prev,&
                                time_prev      , time_curr     ,&
                                ds_constitutive, ds_material   , ds_system,&
                                hval_incr      , hval_algo     ,&
                                vediri         , vefnod        ,&
                                vevarc_prev    , vevarc_curr   )
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model, mate, cara_elem, mateco
        character(len=19), intent(in) :: disp_prev, disp_cumu_inst
        character(len=19), intent(in) :: vari_prev, sigm_prev
        real(kind=8), intent(in) :: time_prev, time_curr
        type(NL_DS_Constitutive), intent(inout) :: ds_constitutive
        type(NL_DS_Material), intent(out) :: ds_material
        type(NL_DS_System), intent(out) :: ds_system
        character(len=19), intent(out) :: hval_incr(:), hval_algo(:)
        character(len=19), intent(out) :: vediri, vefnod
        character(len=19), intent(out) :: vevarc_prev, vevarc_curr
    end subroutine calcPrepDataMeca
end interface
