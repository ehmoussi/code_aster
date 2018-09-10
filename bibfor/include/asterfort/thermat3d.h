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
#include "asterf_types.h"
interface 
      subroutine thermat3d(teta1,nrjm,tetas,tetar,DT80,&
               dth0,DTH,CTHP,CTHV)
        real(kind=8) :: teta1
        real(kind=8) :: nrjm
        real(kind=8) :: tetas
        real(kind=8) :: tetar
        real(kind=8) :: DT80
        real(kind=8) :: dth0
        real(kind=8) :: DTH
        real(kind=8) :: CTHP
        real(kind=8) :: CTHV
    end subroutine thermat3d
end interface 
