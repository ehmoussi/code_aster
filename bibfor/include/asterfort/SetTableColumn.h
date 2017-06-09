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
    subroutine SetTableColumn(table     , name_ , flag_acti_,&
                              flag_affe_, valer_, valei_    , valek_, mark_)
        use NonLin_Datastructure_type
        type(NL_DS_Table), intent(inout) :: table
        character(len=*), optional, intent(in) :: name_
        aster_logical, optional, intent(in) :: flag_acti_
        aster_logical, optional, intent(in) :: flag_affe_
        real(kind=8), optional, intent(in) :: valer_
        integer, optional, intent(in) :: valei_
        character(len=*), optional, intent(in) :: valek_
        character(len=1), optional, intent(in) :: mark_
    end subroutine SetTableColumn
end interface
