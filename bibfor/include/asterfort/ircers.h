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
    subroutine ircers(ifi, ligrel, nbgrel, longr, ncmpmx,&
                      vale, nomgd, nomcmp, titr, nomel,&
                      loc, celd, nbnoma, permut, maxnod,&
                      typma, nomsd, nomsym, ir, nbmat,&
                      nummai, lmasu, ncmpu, nucmp, nbcmp,&
                      ncmps, nocmpl)
        integer :: maxnod
        integer :: ifi
        integer :: ligrel(*)
        integer :: nbgrel
        integer :: longr(*)
        integer :: ncmpmx
        real(kind=8) :: vale(*)
        character(len=*) :: nomgd
        character(len=*) :: nomcmp(*)
        character(len=*) :: titr
        character(len=*) :: nomel(*)
        character(len=*) :: loc
        integer :: celd(*)
        integer :: nbnoma(*)
        integer :: permut(maxnod, *)
        integer :: typma(*)
        character(len=*) :: nomsd
        character(len=*) :: nomsym
        integer :: ir
        integer :: nbmat
        integer :: nummai(*)
        aster_logical :: lmasu
        integer :: ncmpu
        integer :: nucmp(*)
        integer :: nbcmp
        integer :: ncmps(*)
        character(len=*) :: nocmpl(*)
    end subroutine ircers
end interface
