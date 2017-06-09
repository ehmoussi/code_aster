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
    subroutine resthe(ligrel, evol, chtemm, chtemp, chflum,&
                      chflup, mate, valthe, insold, inst,&
                      resu, niveau, ifm, niv, ma,&
                      cartef, nomgdf, carteh, nomgdh, cartet,&
                      nomgdt, cartes, nomgds, chgeom, chsour,&
                      psourc, iaux)
        character(len=24) :: ligrel
        aster_logical :: evol
        character(len=24) :: chtemm
        character(len=24) :: chtemp
        character(len=24) :: chflum
        character(len=24) :: chflup
        character(len=24) :: mate
        real(kind=8) :: valthe
        real(kind=8) :: insold
        real(kind=8) :: inst
        character(len=24) :: resu
        integer :: niveau
        integer :: ifm
        integer :: niv
        character(len=8) :: ma
        character(len=19) :: cartef
        character(len=19) :: nomgdf
        character(len=19) :: carteh
        character(len=19) :: nomgdh
        character(len=19) :: cartet
        character(len=19) :: nomgdt
        character(len=19) :: cartes
        character(len=19) :: nomgds
        character(len=24) :: chgeom
        character(len=24) :: chsour
        character(len=8) :: psourc
        integer :: iaux
    end subroutine resthe
end interface
