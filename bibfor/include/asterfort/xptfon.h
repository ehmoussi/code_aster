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
    subroutine xptfon(noma, ndim, nmafon, cnslt, cnsln,&
                      cnxinv, jmafon, nxptff, jfon, nfon,&
                      jbas, jtail, fiss, goinop, listpt,&
                      orient, typdis, nbmai, operation_opt)
        character(len=8) :: noma
        integer :: ndim
        integer :: nmafon
        character(len=19) :: cnslt
        character(len=19) :: cnsln
        character(len=19) :: cnxinv
        integer :: jmafon
        integer :: nxptff
        integer :: jfon
        integer :: nfon
        integer :: jbas
        integer :: jtail
        character(len=8) :: fiss
        aster_logical :: goinop
        character(len=19) :: listpt
        aster_logical :: orient
        character(len=16) :: typdis
        integer :: nbmai
        character(len=16), intent(in), optional :: operation_opt
    end subroutine xptfon
end interface
