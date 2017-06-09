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

subroutine nmch6p(measse)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "asterfort/nmcha0.h"
    character(len=19) :: measse(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (INITIALISATION)
!
! CREATION DES VARIABLES CHAPEAUX - MEASSE
!
! ----------------------------------------------------------------------
!
!
! OUT MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
!
! ----------------------------------------------------------------------
!
    character(len=19) :: masse, amort, rigid, sstru
!
    data amort ,masse     /'&&NMCH6P.AMORT','&&NMCH6P.MASSE'/
    data rigid ,sstru     /'&&NMCH6P.RIGID','&&NMCH6P.SSRASS'/
!
! ----------------------------------------------------------------------
!
    call nmcha0('MEASSE', 'ALLINI', ' ', measse)
    call nmcha0('MEASSE', 'MERIGI', rigid, measse)
    call nmcha0('MEASSE', 'MEMASS', masse, measse)
    call nmcha0('MEASSE', 'MEAMOR', amort, measse)
    call nmcha0('MEASSE', 'MESSTR', sstru, measse)
!
end subroutine
