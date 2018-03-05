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
    subroutine nmcrob(meshz      , modelz         , sddisc, ds_inout, cara_elemz,&
                      ds_material, ds_constitutive, disp  , strx    , varc      ,&
                      time       , sd_obsv  )
        use NonLin_Datastructure_type
        character(len=*), intent(in) :: meshz
        character(len=*), intent(in) :: modelz
        character(len=19), intent(in) :: sddisc
        type(NL_DS_InOut), intent(in) :: ds_inout
        character(len=*), intent(in) :: cara_elemz
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=*), intent(in) :: disp
        character(len=*), intent(in) :: strx
        character(len=*), intent(in) :: varc
        real(kind=8),  intent(in) :: time
        character(len=19), intent(out) :: sd_obsv
    end subroutine nmcrob
end interface
