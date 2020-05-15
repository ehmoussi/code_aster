! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine get_elas_para(fami    , j_mater     , poum, ipg, ispg, &
                             elas_id , elas_keyword,&
                             time    , temp        ,&
                             e_      , nu_  , g_   ,&
                             e1_     , e2_  , e3_  ,&
                             nu12_   , nu13_, nu23_,&
                             g1_     , g2_  , g3_  ,&
                             BEHinteg, xyzgau_)
        use Behaviour_type
        character(len=*), intent(in) :: fami
        integer, intent(in) :: j_mater
        character(len=*), intent(in) :: poum
        integer, intent(in) :: ipg, ispg
        integer, intent(in) :: elas_id
        character(len=16), intent(in) :: elas_keyword
        real(kind=8), optional, intent(in) :: time
        real(kind=8), optional, intent(in) :: temp
        real(kind=8), optional, intent(in) :: xyzgau_(3)
        real(kind=8), optional, intent(out) :: e_, nu_, g_
        real(kind=8), optional, intent(out) :: e1_,e2_, e3_
        real(kind=8), optional, intent(out) :: nu12_, nu13_, nu23_
        real(kind=8), optional, intent(out) :: g1_, g2_, g3_
        type(Behaviour_Integ), optional, intent(in) :: BEHinteg
    end subroutine get_elas_para
end interface
