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
    subroutine rcevfa(nommat, para, sm, cnoc, csno,&
                      csne, cspo, cspe, kemixt, cspto,&
                      cspte, cspmo, cspme, cfao, cfae)
        character(len=8) :: nommat
        real(kind=8) :: para(3)
        real(kind=8) :: sm
        character(len=24) :: cnoc
        character(len=24) :: csno
        character(len=24) :: csne
        character(len=24) :: cspo
        character(len=24) :: cspe
        aster_logical :: kemixt
        character(len=24) :: cspto
        character(len=24) :: cspte
        character(len=24) :: cspmo
        character(len=24) :: cspme
        character(len=24) :: cfao
        character(len=24) :: cfae
    end subroutine rcevfa
end interface
