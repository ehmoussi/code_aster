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
interface
    subroutine nonlinDSColumnWriteValue(length      , output_string_,&
                                        output_unit_,&
                                        value_r_    ,&
                                        value_i_    ,&
                                        value_k_    ,&
                                        time_   )
        use NonLin_Datastructure_type
        integer, intent(in) :: length
        character(len=*), optional, intent(out) :: output_string_
        integer, optional, intent(in) :: output_unit_
        real(kind=8), optional, intent(in) :: value_r_
        integer, optional, intent(in) :: value_i_
        character(len=*), optional, intent(in) :: value_k_
        real(kind=8), optional, intent(in) :: time_
    end subroutine nonlinDSColumnWriteValue
end interface
