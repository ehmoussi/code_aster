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
    subroutine nmevac(sddisc, sderro   , i_echec_acti, nume_inst   , iterat,&
                      retact, ds_print_, ds_contact_)
        use NonLin_Datastructure_type
        character(len=19), intent(in) :: sddisc
        character(len=24), intent(in) :: sderro
        integer, intent(in) :: i_echec_acti
        integer, intent(in) :: nume_inst
        integer, intent(in) :: iterat
        integer, intent(out) :: retact
        type(NL_DS_Print), optional, intent(in) :: ds_print_
        type(NL_DS_Contact), optional, intent(in) :: ds_contact_
    end subroutine nmevac
end interface
