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
    subroutine cfapno(noma, newgeo, ds_contact, lctfd,&
                      ndimg, izone, posnoe, numnoe,&
                      coorne, posnom, tau1m, tau2m, iliai)
        use NonLin_Datastructure_type
        character(len=8), intent(in) :: noma
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19), intent(in) :: newgeo
        real(kind=8), intent(in) :: coorne(3)
        real(kind=8), intent(out) :: tau1m(3)
        real(kind=8), intent(out) :: tau2m(3)
        integer, intent(in) :: izone
        integer, intent(in) :: ndimg
        integer, intent(in) :: posnom(1)
        integer, intent(in) :: posnoe
        integer, intent(in) :: numnoe
        integer, intent(in) :: iliai
        aster_logical, intent(in) :: lctfd
    end subroutine cfapno
end interface
