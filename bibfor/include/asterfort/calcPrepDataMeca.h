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
!
interface
    subroutine calcPrepDataMeca(model          , mate          , cara_elem,&
                                disp_prev      , disp_cumu_inst, vari_prev, sigm_prev,&
                                time_prev      , time_curr     ,&
                                ds_constitutive, varc_refe     ,&
                                hval_incr      , hval_algo     ,&
                                merigi         , vediri        , vefint   , veforc   ,&
                                vevarc_prev    , vevarc_curr   )
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        character(len=19), intent(in) :: disp_prev
        character(len=19), intent(in) :: disp_cumu_inst
        character(len=19), intent(in) :: vari_prev
        character(len=19), intent(in) :: sigm_prev
        real(kind=8), intent(in) :: time_prev
        real(kind=8), intent(in) :: time_curr
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=24), intent(out) :: varc_refe
        character(len=19), intent(out) :: hval_incr(:)
        character(len=19), intent(out) :: hval_algo(:)
        character(len=19), intent(out) :: merigi
        character(len=19), intent(out) :: vediri
        character(len=19), intent(out) :: vefint
        character(len=19), intent(out) :: veforc
        character(len=19), intent(out) :: vevarc_prev
        character(len=19), intent(out) :: vevarc_curr
    end subroutine calcPrepDataMeca
end interface
