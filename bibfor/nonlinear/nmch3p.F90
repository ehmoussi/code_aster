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

subroutine nmch3p(meelem)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "asterfort/nmcha0.h"
    character(len=19) :: meelem(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (INITIALISATION)
!
! CREATION DES VARIABLES CHAPEAUX - MEELEM
!
! ----------------------------------------------------------------------
!
!
! OUT MEELEM : VARIABLE CHAPEAU POUR NOM DES MATR_ELEM
!
! ----------------------------------------------------------------------
!
    character(len=19) :: memass, meamor, merigi, mediri, mesuiv
    character(len=19) :: messtr, megeom
    character(len=19) :: meeltc, meeltf
!
    data memass,mediri    /'&&NMCH3P.MEMASS','&&NMCH3P.MEDIRI'/
    data merigi,meamor    /'&&NMCH3P.MERIGI','&&NMCH3P.MEAMOR'/
    data mesuiv,messtr    /'&&NMCH3P.MATGME','&&NMCH3P.SSRELE'/
    data megeom           /'&&NMCH3P.MEGEOM'/
    data meeltc,meeltf    /'&&NMCH3P.MEELTC','&&NMCH3P.MEELTF'/
!
! ----------------------------------------------------------------------
!
    call nmcha0('MEELEM', 'ALLINI', ' ', meelem)
    call nmcha0('MEELEM', 'MERIGI', merigi, meelem)
    call nmcha0('MEELEM', 'MEDIRI', mediri, meelem)
    call nmcha0('MEELEM', 'MEMASS', memass, meelem)
    call nmcha0('MEELEM', 'MEAMOR', meamor, meelem)
    call nmcha0('MEELEM', 'MESUIV', mesuiv, meelem)
    call nmcha0('MEELEM', 'MESSTR', messtr, meelem)
    call nmcha0('MEELEM', 'MEGEOM', megeom, meelem)
    call nmcha0('MEELEM', 'MEELTC', meeltc, meelem)
    call nmcha0('MEELEM', 'MEELTF', meeltf, meelem)
!
end subroutine
