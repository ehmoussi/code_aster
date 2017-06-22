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
    subroutine xcrvol(nse, ndim, jcnse, nnose, jpint,&
                      igeom, elrefp, inoloc, nbnoma, jcesd3,&
                      jcesl3, jcesv3, numa2, iheav, nfiss, vhea,&
                      jcesd8, jcesl8, jcesv8, lfiss, vtot)
        integer :: nbnoma
        integer :: ndim
        integer :: nse
        integer :: jcnse
        integer :: nnose
        integer :: jpint
        integer :: igeom
        character(len=8) :: elrefp
        integer :: inoloc
        integer :: jcesd3
        integer :: jcesl3
        integer :: jcesv3
        integer :: numa2
        aster_logical :: lfiss
        integer :: iheav
        integer :: nfiss
        real(kind=8) :: vhea
        integer :: jcesd8
        integer :: jcesl8
        integer :: jcesv8
        real(kind=8) :: vtot
    end subroutine xcrvol
end interface
