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
#include "asterf_types.h"
!
interface
    subroutine nmsstg(shb6, geom, idfde, ipoids, icoopg, pgl, para,&
                      ndim, nno, poids, kpg,&
                      dfdi, option,&
                      dsidep, sign,&
                      sigma, matsym, matuu)
        aster_logical, intent(in) :: shb6
        real(kind=8), intent(in) :: geom(3, nno)
        integer, intent(in) :: idfde
        integer, intent(in) :: ipoids
        integer, intent(in) :: icoopg
        real(kind=8), intent(in) :: pgl(3,3)
        real(kind=8), intent(in) :: para(2)
        integer, intent(in) :: ndim
        integer, intent(in) :: nno
        real(kind=8), intent(inout) :: poids
        integer, intent(in) :: kpg
        real(kind=8), intent(in) :: dfdi(nno, 3)
        character(len=16), intent(in) :: option
        real(kind=8), intent(inout) :: dsidep(6, 6)
        real(kind=8), intent(inout) ::  sign(6)
        real(kind=8), intent(in) ::  sigma(6)
        aster_logical, intent(in) :: matsym
        real(kind=8), intent(inout) :: matuu(*)
    end subroutine nmsstg
end interface
