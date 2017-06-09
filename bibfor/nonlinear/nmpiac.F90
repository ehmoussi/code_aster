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

subroutine nmpiac(sdpilo, eta)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/jeveuo.h"
    character(len=19) :: sdpilo
    real(kind=8) :: eta
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE)
!
! REACTUALISATION DES BORNES DE PILOTAGE SI DEMANDE
!
! ----------------------------------------------------------------------
!
!
! IN  SDPILO : SD PILOTAGE
! IN  ETA    : PARAMETRE DE PILOTAGE
!
!
!
!
    character(len=24) :: evolpa, typsel, typpil
    real(kind=8), pointer :: plir(:) => null()
    character(len=24), pointer :: pltk(:) => null()
!
! ----------------------------------------------------------------------
!
    call jeveuo(sdpilo(1:19)// '.PLTK', 'L', vk24=pltk)
    typpil = pltk(1)
    typsel = pltk(6)
    evolpa = pltk(7)
    call jeveuo(sdpilo(1:19)// '.PLIR', 'E', vr=plir)
    if (typsel .eq. 'ANGL_INCR_DEPL' .and.&
        (typpil.eq.'LONG_ARC' .or.typpil.eq.'SAUT_LONG_ARC')) then
        plir(6)=plir(1)
    endif
!
!
    if (evolpa .eq. 'SANS') goto 9999
    if (evolpa .eq. 'CROISSANT') then
        plir(5) = eta
    else
        plir(4) = eta
    endif
!
9999  continue
end subroutine
