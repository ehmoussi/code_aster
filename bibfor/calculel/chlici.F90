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

subroutine chlici(chaine, long)
! person_in_charge: jacques.pellet at edf.fr
! aslint: disable=
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    character(len=*) :: chaine
    integer :: long
! ----------------------------------------------------------------------
! BUT : VERIFIER QU'UNE CHAINE DE CARACTERES NE CONTIENT QUE
!       DES CARACTERES AUTORISES PAR JEVEUX : (A-Z)(a-z)(0-9)
!       PLUS : PERLUETTE, BLANC, BLANC SOULIGNE ET POINT
!       ON VERIFIE LA CHAINE SUR UNE LONGUEUR : LONG
!       SI CARACTERE ILLICITE : ERREUR FATALE <F>
!
! IN  CHAINE    : CHAINE A VERIFIER
! IN  LONG      : LA CHAINE EST VERIFIEE DE (1:LONG)
! ----------------------------------------------------------------------
    integer :: i, k
    aster_logical :: bool
!-----------------------------------------------------------------------
!
    do i = 1,long
        k = ichar(chaine(i:i))
        bool = (k.eq.32) .or. (k.eq.46) .or. (k.eq.38) .or. (k.eq.95) .or. &
               ((k.ge.48).and. (k.le.57)) .or.&
               ((k.ge.65).and. ( k.le.90)) .or. ((k.ge.97).and. (k.le.122))
        ASSERT(bool)
    end do
end subroutine
