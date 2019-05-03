! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine nzfpri(deuxmu  , trans, rprim , seuil ,&
                      nb_phase, phase, zalpha,&
                      fmel    , eta  , unsurn,&
                      dt      , dp   , &
                      fplas   , fp   , fd    ,&
                      fprim   , fdevi)
        real(kind=8), intent(in) :: deuxmu, trans, rprim, seuil
        integer, intent(in) :: nb_phase
        real(kind=8), intent(in) :: phase(nb_phase), zalpha
        real(kind=8), intent(in) :: fmel, eta(nb_phase), unsurn(nb_phase), dt, dp
        real(kind=8), intent(out) :: fplas, fp(nb_phase), fd(nb_phase), fprim, fdevi
    end subroutine nzfpri
end interface
