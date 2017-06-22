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
    subroutine get_elas_para(fami     , j_mater, poum, ipg, ispg, &
                             elas_id,&
                             time     , temp,&
                             e   , nu  , g,&
                             e1  , e2  , e3,&
                             nu12, nu13, nu23,&
                             g1  , g2  , g3)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: j_mater
        character(len=*), intent(in) :: poum
        integer, intent(in) :: ipg
        integer, intent(in) :: ispg
        integer, intent(out) :: elas_id
        real(kind=8), optional, intent(in) :: time
        real(kind=8), optional, intent(in) :: temp
        real(kind=8), optional, intent(out) :: e
        real(kind=8), optional, intent(out) :: nu
        real(kind=8), optional, intent(out) :: e1
        real(kind=8), optional, intent(out) :: e2
        real(kind=8), optional, intent(out) :: e3
        real(kind=8), optional, intent(out) :: nu12
        real(kind=8), optional, intent(out) :: nu13
        real(kind=8), optional, intent(out) :: nu23
        real(kind=8), optional, intent(out) :: g1
        real(kind=8), optional, intent(out) :: g2
        real(kind=8), optional, intent(out) :: g3
        real(kind=8), optional, intent(out) :: g
    end subroutine get_elas_para
end interface
