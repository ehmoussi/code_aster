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
    subroutine mmvitm(nbdm , ndim , nne  , nnm  ,&
                      ffe  , ffm  ,&
                      vitme, vitmm, vitpe, vitpm,&
                      accme, accmm)
        integer, intent(in) :: nbdm, ndim, nne, nnm
        real(kind=8), intent(in) :: ffe(9), ffm(9)
        real(kind=8), intent(out) :: accme(3), vitme(3), accmm(3), vitmm(3)
        real(kind=8), intent(out) :: vitpe(3), vitpm(3)
    end subroutine mmvitm
end interface
