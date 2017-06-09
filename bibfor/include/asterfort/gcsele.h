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
    subroutine gcsele(motcle, chvolu, ch1d2d, ch2d3d, chpres,&
                      chepsi, chpesa, chrota, lvolu , l1d2d ,&
                      l2d3d , lpres , lepsi , lpesa , lrota ,&
                      lfvolu, lf1d2d, lf2d3d, lfpres, lfepsi,&
                      lfpesa, lfrota, carte0, lformu, lpchar,&
                      lccomb)
        character(len=16) :: motcle
        character(len=19) :: carte0
        aster_logical :: lformu, lpchar, lccomb
        character(len=19) :: chvolu, ch1d2d, ch2d3d, chpres
        character(len=19) :: chepsi, chpesa, chrota
        aster_logical :: lvolu, l1d2d, l2d3d, lpres
        aster_logical :: lepsi, lpesa, lrota
        aster_logical :: lfvolu, lf1d2d, lf2d3d, lfpres
        aster_logical :: lfepsi, lfpesa, lfrota
    end subroutine gcsele
end interface
