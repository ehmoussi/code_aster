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
    subroutine irdepl(fileUnit   ,&
                      fieldTypeZ , fieldNameZ  ,&
                      cmpUserNb  , cmpUserName ,&
                      nodeUserNb , nodeUserNume,&
                      lMeshCoor_ , lmax_       , lmin_,&
                      lsup_      , borsup_     ,&
                      linf_      , borinf_     ,&
                      realFormat_, cplxFormat_)
        integer, intent(in) :: fileUnit
        character(len=*), intent(in) :: fieldNameZ, fieldTypeZ
        integer, intent(in) :: cmpUserNb
        character(len=8), pointer :: cmpUserName(:)
        integer, intent(in) :: nodeUserNb
        integer, pointer :: nodeUserNume(:)
        aster_logical, optional, intent(in) :: lMeshCoor_
        aster_logical, optional, intent(in) :: lsup_, linf_, lmax_, lmin_
        real(kind=8),  optional, intent(in) :: borsup_, borinf_
        character(len=*),  optional, intent(in) :: realFormat_, cplxFormat_
    end subroutine irdepl
end interface
