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
    subroutine nmobse(meshz     , sd_obsv  , time,&
                      cara_elemz, modelz   , matez    , ds_constitutive, disp_curr,&
                      strx_curr , varc_curr, varc_refe)
        use NonLin_Datastructure_type
        character(len=*), intent(in) :: meshz
        character(len=19), intent(in) :: sd_obsv
        real(kind=8), intent(in) :: time
        character(len=*), optional, intent(in) :: modelz
        character(len=*), optional, intent(in) :: cara_elemz
        character(len=*), optional, intent(in) :: matez
        type(NL_DS_Constitutive), optional, intent(in) :: ds_constitutive
        character(len=*), optional, intent(in) :: disp_curr
        character(len=*), optional, intent(in) :: strx_curr
        character(len=*), optional, intent(in) :: varc_curr
        character(len=*), optional, intent(in) :: varc_refe
    end subroutine nmobse
end interface
