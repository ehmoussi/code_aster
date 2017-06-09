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
    subroutine cfchno(noma, ds_contact, ndimg, posnoe, typenm,&
                      numenm, lmait, lescl, lmfixe, lefixe,&
                      tau1m, tau2m, tau1e, tau2e, tau1,&
                      tau2)
        use NonLin_Datastructure_type
        character(len=8) :: noma
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer :: ndimg
        integer :: posnoe
        character(len=4) :: typenm
        integer :: numenm
        aster_logical :: lmait
        aster_logical :: lescl
        aster_logical :: lmfixe
        aster_logical :: lefixe
        real(kind=8) :: tau1m(3)
        real(kind=8) :: tau2m(3)
        real(kind=8) :: tau1e(3)
        real(kind=8) :: tau2e(3)
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
    end subroutine cfchno
end interface
