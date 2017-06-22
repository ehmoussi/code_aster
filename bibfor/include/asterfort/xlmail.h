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
    subroutine xlmail(fiss, nmaen1, nmaen2, nmaen3, nmafon,&
                      jmaen1, jmaen2, jmaen3, jmafon, nfon,&
                      jfon, jnofaf, nbfond, jbas, jtail, jfonmu,&
                      ndim, goinop)
        character(len=8) :: fiss
        integer :: nmaen1
        integer :: nmaen2
        integer :: nmaen3
        integer :: nmafon
        integer :: jmaen1
        integer :: jmaen2
        integer :: jmaen3
        integer :: jmafon
        integer :: nfon
        integer :: jfon
        integer :: jnofaf
        integer :: nbfond
        integer :: jbas
        integer :: jtail
        integer :: jfonmu
        integer :: ndim
        aster_logical :: goinop
    end subroutine xlmail
end interface
