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
    subroutine ircecl(fileUnit    ,&
                      fieldSupport, celd        , realFormat  , cplxFormat  ,&
                      nodeListNb  , nodeListNume,&
                      cellListNb  , cellListNume,&
                      meshCellNb  , meshCellName, meshNodeName,&
                      lMeshCoor   , meshDimeIn  , meshCoor    ,&
                      connex      , connexLen   ,&
                      cmpCataNb   , cmpCataName ,&
                      cmpListNb   , cmpListIndx ,&
                      cmpVariNb   , cmpVariIndx ,&
                      grelNb      , liel        ,&
                      lielLen     , liliName    ,&
                      lmax        , lmin        ,&
                      lsup        , borsup      ,&
                      linf        , borinf      ,&
                      vale)
        integer, intent(in) :: fileUnit
        character(len=4), intent(in) :: fieldSupport
        integer, pointer :: celd(:)
        character(len=8), intent(in) :: realFormat, cplxFormat
        integer, intent(in) :: nodeListNb
        integer, pointer :: nodeListNume(:)
        integer, intent(in) :: cellListNb
        integer, pointer :: cellListNume(:)
        integer, intent(in) :: meshCellNb
        character(len=8), pointer :: meshCellName(:), meshNodeName(:)
        aster_logical, intent(in) :: lMeshCoor
        integer, intent(in) :: meshDimeIn
        real(kind=8), pointer :: meshCoor(:)
        integer, intent(in) :: cmpCataNb
        character(len=8), pointer :: cmpCataName(:)
        integer, intent(in) :: cmpListNb
        integer, pointer :: cmpListIndx(:)
        integer, intent(in) :: cmpVariNb
        integer, pointer :: cmpVariIndx(:)
        integer, intent(in) :: grelNb
        integer, pointer :: liel(:), lielLen(:)
        character(len=19), intent(in) :: liliName
        integer, pointer :: connex(:), connexLen(:) 
        aster_logical, intent(in) :: lsup, linf, lmax, lmin
        real(kind=8),  intent(in) :: borsup, borinf
        complex(kind=8), pointer  :: vale(:)
    end subroutine ircecl
end interface
