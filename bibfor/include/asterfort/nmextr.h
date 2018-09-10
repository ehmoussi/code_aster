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
    subroutine nmextr(meshz       , modelz     , sdextrz   , ds_inout , keyw_fact,&
                      nb_keyw_fact, nb_extr    ,&
                      cara_elemz  , ds_material, ds_constitutive, disp_curr, strx_curr,&
                      varc_curr   , time      )
        use NonLin_Datastructure_type
        character(len=*), intent(in) :: meshz
        character(len=*), intent(in) :: modelz
        character(len=*), intent(in) :: sdextrz
        type(NL_DS_InOut), intent(in) :: ds_inout
        integer, intent(in) :: nb_keyw_fact
        character(len=16), intent(in) :: keyw_fact
        integer, intent(out) :: nb_extr  
        character(len=*), optional, intent(in) :: cara_elemz
        type(NL_DS_Material), optional, intent(in) :: ds_material
        type(NL_DS_Constitutive), optional, intent(in) :: ds_constitutive
        character(len=*), optional, intent(in) :: disp_curr
        character(len=*), optional, intent(in) :: strx_curr
        character(len=*), optional, intent(in) :: varc_curr
        real(kind=8), optional, intent(in) :: time
    end subroutine nmextr
end interface
