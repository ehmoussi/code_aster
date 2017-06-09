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
    subroutine GetResi(ds_conv   , type  ,&
                       col_name_ , col_name_locus_, vale_calc_  , locus_calc_, user_para_,&
                       l_conv_   , event_type_    , l_resi_test_)
        use NonLin_Datastructure_type
        type(NL_DS_Conv), intent(in) :: ds_conv
        character(len=*), intent(in) :: type
        character(len=16), optional, intent(out) :: col_name_
        character(len=16), optional, intent(out) :: col_name_locus_
        real(kind=8), optional, intent(out) :: vale_calc_
        character(len=16), optional, intent(out) :: locus_calc_
        real(kind=8), optional, intent(out) :: user_para_
        aster_logical, optional, intent(out) :: l_conv_
        character(len=16), optional, intent(out)  :: event_type_
        aster_logical, optional, intent(out) :: l_resi_test_
    end subroutine GetResi
end interface
