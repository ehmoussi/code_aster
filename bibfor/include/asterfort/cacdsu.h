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
    subroutine cacdsu(maxfa    , parm_alpha,&
                      ndim     , nno       , nface,&
                      elem_coor,&
                      vol      , mface     , dface,&
                      xface    , normfa    , kdiag,&
                      yss      , c         , d    )
        integer, intent(in) :: maxfa
        real(kind=8), intent(in) :: parm_alpha
        integer, intent(in) :: ndim, nno, nface
        real(kind=8), intent(in) :: elem_coor(ndim, nno)
        real(kind=8), intent(in) :: vol
        real(kind=8), intent(in) :: mface(1:maxfa)
        real(kind=8), intent(in) :: dface(1:maxfa)
        real(kind=8), intent(in) :: xface(1:3, 1:maxfa)
        real(kind=8), intent(in) :: normfa(1:3, 1:maxfa)
        real(kind=8), intent(in) :: kdiag(6)
        real(kind=8), intent(out) :: yss(3, maxfa, maxfa)
        real(kind=8), intent(out) :: c(maxfa, maxfa), d(maxfa, maxfa)
    end subroutine cacdsu
end interface
