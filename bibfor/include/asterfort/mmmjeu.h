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
    subroutine mmmjeu(ndim  , iresog, jeusup,&
                      geome , geomm ,&
                      ddeple, ddeplm,&
                      norm  , mprojt,&
                      jeu   , djeu  , djeut )
        integer, intent(in) :: ndim, iresog
        real(kind=8), intent(in) :: jeusup,  norm(3)
        real(kind=8), intent(in):: geomm(3), geome(3)
        real(kind=8), intent(in) :: ddeple(3), ddeplm(3)
        real(kind=8), intent(in) :: mprojt(3, 3)
        real(kind=8), intent(out) :: jeu, djeu(3), djeut(3)
    end subroutine mmmjeu
end interface
