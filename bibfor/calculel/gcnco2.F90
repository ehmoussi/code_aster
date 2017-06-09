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

subroutine gcnco2(nomk8)
    implicit none
#include "asterfort/codent.h"
    character(len=8) :: nomk8
!     ------------------------------------------------------------------
!     CALCUL D'UN NOUVEAU NOM PAR INCREMENTATION DU NOM DE +1
!     REMARQUE : ON IGNORE LE PREMIER CARACTERE DE NOMK8
!
! EXEMPLE D'UTILISATION :
!      CHARACTER*8 NEWNOM
!      NEWNOM='.0000123'
!      CALL GCNCO2(NEWNOM)
!      CALL GCNCO2(NEWNOM)
!      PRINT NEWNOM => '.0000125'
!
!     ------------------------------------------------------------------
! IN/OUT NOMK8 : K8 : NOM A INCREMENTER :
! person_in_charge: jacques.pellet at edf.fr
!     ------------------------------------------------------------------
    integer :: num
!     ------------------------------------------------------------------
    read (nomk8(2:8),'(I7)') num
    call codent(num+1, 'D0', nomk8(2:8))
end subroutine
