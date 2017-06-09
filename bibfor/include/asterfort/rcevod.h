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
    subroutine rcevod(csigm, cinst, cnoc, sm, lfatig,&
                      lpmpb, lsn, csno, csne, flexio,&
                      csneo, csnee, cfao, cfae, cspo,&
                      cspe, cresu, kinti, it, jt,&
                      lrocht, symax, cpres, kemixt, cspto,&
                      cspte, cspmo, cspme)
        character(len=24) :: csigm
        character(len=24) :: cinst
        character(len=24) :: cnoc
        real(kind=8) :: sm
        aster_logical :: lfatig
        aster_logical :: lpmpb
        aster_logical :: lsn
        character(len=24) :: csno
        character(len=24) :: csne
        aster_logical :: flexio
        character(len=24) :: csneo
        character(len=24) :: csnee
        character(len=24) :: cfao
        character(len=24) :: cfae
        character(len=24) :: cspo
        character(len=24) :: cspe
        character(len=24) :: cresu
        character(len=16) :: kinti
        integer :: it
        integer :: jt
        aster_logical :: lrocht
        real(kind=8) :: symax
        character(len=24) :: cpres
        aster_logical :: kemixt
        character(len=24) :: cspto
        character(len=24) :: cspte
        character(len=24) :: cspmo
        character(len=24) :: cspme
    end subroutine rcevod
end interface
