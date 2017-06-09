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
    subroutine verift(fami      , kpg       , ksp       , poum       , j_mater    ,&
                      materi_   , iret_     , epsth_    , epsth_anis_, epsth_meta_,&
                      temp_prev_, temp_curr_, temp_refe_)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        character(len=*), intent(in) :: poum
        integer, intent(in) :: j_mater
        character(len=8), optional, intent(in) :: materi_
        integer, optional, intent(out) :: iret_
        real(kind=8), optional, intent(out) :: epsth_
        real(kind=8), optional, intent(out) :: epsth_anis_(3)
        real(kind=8), optional, intent(out) :: epsth_meta_
        real(kind=8), optional, intent(out) :: temp_prev_
        real(kind=8), optional, intent(out) :: temp_curr_
        real(kind=8), optional, intent(out) :: temp_refe_
    end subroutine verift
end interface
