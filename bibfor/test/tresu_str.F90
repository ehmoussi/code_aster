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

subroutine tresu_str(tbtxt, refk, valk, ific, llab)
    implicit none
#include "asterf_types.h"
    character(len=16), intent(in) :: tbtxt(2)
    character(len=80), intent(in) :: refk
    character(len=80), intent(in) :: valk
    integer, intent(in) :: ific
    aster_logical, intent(in) :: llab
!     Entrées:
!        tbtxt  : (1) : reference
!                 (2) : legende
!        refk   : chaine attendue
!        valk   : chaine obtenue
!        ific   : numero logique du fichier de sortie
!        llab   : flag d impression des labels
!     sorties:
!      listing ...
! ----------------------------------------------------------------------
    integer :: i
    character(len=4) :: testok
    integer, parameter :: nl=4
    character(len=24) :: lign2(nl)
    data lign2 /'REFERENCE', 'LEGENDE', 'VALE_REFE', 'VALE_CALC'/
!
    testok = 'NOOK'
    if (refk .eq. valk) then
        testok = ' OK '
    endif
    if (llab) then
        write(ific,100) (lign2(i),i=1,nl)
    endif
    write(ific,101) testok, tbtxt(1), tbtxt(2), refk, valk
!
    100 format(5x,2(1x,a16),2(1x,a24))
    101 format(a4,1x,2(1x,a16),2(1x,a24))
!
end subroutine
