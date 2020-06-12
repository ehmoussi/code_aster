! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine dydome(nomo, mate, mateco, carele)
!
!
    implicit      none
#include "asterfort/ledome.h"
    character(len=8) :: nomo
    character(len=24) :: mate, carele, mateco
!
! ----------------------------------------------------------------------
!
! DYNA_VIBRA//HARM/GENE
!
! LECTURE DONNEES MECANIQUES
!
! ----------------------------------------------------------------------
!
!
! OUT NOMO   : MODELE
! OUT MATE   : MATERIAU CODE
! OUT CARELE : CARACTERISTIQUES ELEMENTAIRES
!
! ----------------------------------------------------------------------
!
! ----------------------------------------------------------------------
!
!
! --- LECTURE DONNNEES MECANIQUES
!
    call ledome('NN', nomo, mate, mateco, carele)
!
end subroutine
