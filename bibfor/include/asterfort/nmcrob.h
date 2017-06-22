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
    subroutine nmcrob(meshz     , modelz         , sddisc   , ds_inout , cara_elemz,&
                      matez     , ds_constitutive, disp_curr, strx_curr, varc_curr ,&
                      varc_refe , time           , sd_obsv  )
        use NonLin_Datastructure_type
        character(len=*), intent(in) :: meshz
        character(len=*), intent(in) :: modelz
        character(len=19), intent(in) :: sddisc
        type(NL_DS_InOut), intent(in) :: ds_inout
        character(len=*), intent(in) :: cara_elemz
        character(len=*), intent(in) :: matez
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=*), intent(in) :: disp_curr
        character(len=*), intent(in) :: strx_curr
        character(len=*), intent(in) :: varc_curr
        character(len=*), intent(in) :: varc_refe
        real(kind=8),  intent(in) :: time
        character(len=19), intent(out) :: sd_obsv
    end subroutine nmcrob
end interface
