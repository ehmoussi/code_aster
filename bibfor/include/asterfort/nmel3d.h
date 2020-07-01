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
    subroutine nmel3d(fami  , poum  , nno   , npg  ,&
                      ipoids, ivf   , idfde ,&
                      geom  , typmod, option, imate,&
                      compor, lgpg  , carcri, depl ,&
                      angmas, sig   , vi    ,&
                      matuu , vectu , codret)
        character(len=*), intent(in) :: fami
        character(len=*), intent(in) :: poum
        integer, intent(in) :: nno, npg
        integer, intent(in) :: ipoids, ivf, idfde
        real(kind=8), intent(in) :: geom(3, nno)
        character(len=8), intent(in) :: typmod(*)
        character(len=16), intent(in) :: option
        integer, intent(in) :: imate
        character(len=16), intent(in) :: compor(*)
        real(kind=8), intent(in) :: carcri(*)
        integer, intent(in) :: lgpg
        real(kind=8), intent(inout) :: depl(3, nno)
        real(kind=8), intent(in) :: angmas(*)
        real(kind=8), intent(inout)  :: sig(6, npg), vi(lgpg, npg)
        real(kind=8), intent(inout) :: matuu(*), vectu(3, nno)
        integer, intent(inout) :: codret
    end subroutine nmel3d
end interface
