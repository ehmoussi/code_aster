! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine irtopo(keywf     , keywfIocc   ,&
                      dsName    , lResu       , lField,&
                      cellListNb, cellListNume,&
                      nodeListNb, nodeListNume,&
                      fileFormat, fileUnit    ,&
                      codret)
        character(len=16), intent(in) :: keywf
        integer, intent(in) :: keywfIocc
        aster_logical, intent(in) :: lField, lResu
        character(len=8), intent(in) :: dsName
        integer, intent(out) :: cellListNb
        integer, pointer :: cellListNume(:)
        integer, intent(out) :: nodeListNb
        integer, pointer :: nodeListNume(:)
        integer, intent(in) :: fileUnit
        character(len=8), intent(in) :: fileFormat
        integer, intent(out) :: codret
    end subroutine irtopo
end interface
