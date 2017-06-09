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

subroutine titre()
    implicit none
!     CREATION D'UN TITRE ATTACHE A UN CONCEPT
!     ------------------------------------------------------------------
#include "asterc/getres.h"
#include "asterfort/titrea.h"
    character(len=8) :: nomcon, cbid
    character(len=24) :: nomobj
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call getres(nomcon, cbid, cbid)
    nomobj = ' '
    nomobj(1:8) = nomcon
    nomobj(20:24) = '.TITR'
    call titrea('T', nomcon, nomcon, nomobj, 'C',&
                ' ', 0, 'G', '(1PE12.5)')
end subroutine
