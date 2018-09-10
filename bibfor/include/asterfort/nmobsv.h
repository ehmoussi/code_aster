! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine nmobsv(meshz     , modelz     , sddisc         , sd_obsv  , nume_time,&
                      cara_elemz, ds_material, ds_constitutive, valinc   , ds_inout  )
        use NonLin_Datastructure_type
        character(len=*), intent(in) :: meshz
        character(len=19), intent(in) :: sd_obsv
        integer, intent(in) :: nume_time
        character(len=19), intent(in) :: sddisc
        character(len=*), intent(in) :: cara_elemz
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=*), intent(in) :: modelz
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19), intent(in) :: valinc(*)
        type(NL_DS_InOut), optional, intent(in) :: ds_inout
    end subroutine nmobsv
end interface
