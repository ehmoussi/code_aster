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
      subroutine rag3d(taar,nrjg,tref0,aar0,sr1,&
               srsrag,teta1,dt,vrag00,aar1,&
               vrag1)
        real(kind=8) :: taar
        real(kind=8) :: nrjg
        real(kind=8) :: tref0
        real(kind=8) :: aar0
        real(kind=8) :: sr1
        real(kind=8) :: srsrag
        real(kind=8) :: teta1
        real(kind=8) :: dt
        real(kind=8) :: vrag00
        real(kind=8) :: aar1
        real(kind=8) :: vrag1
    end subroutine rag3d
end interface 
