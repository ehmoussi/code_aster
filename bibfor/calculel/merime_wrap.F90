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

subroutine merime_wrap(modelz, nchar, lchar, mater, mateco, carelz,&
                       time, compoz, matelz, nh,&
                       basz)
!
!
    implicit none
#include "asterf_types.h"
#include "asterfort/merime.h"
    integer :: nchar, nh
    real(kind=8) :: time
    character(len=*) :: modelz, carelz, matelz
    character(len=24) :: lchar(nchar)
    character(len=*) :: mater, mateco, basz, compoz
!
! ----------------------------------------------------------------------
!
! APPEL A MERIME
!
! ----------------------------------------------------------------------
!
! IN  MODELE : NOM DU MODELE
! IN  NCHAR  : NOMBRE DE CHARGES
! IN  LCHAR  : LISTE DES CHARGES
! IN  MATECO : CARTE DE MATERIAU CODE
! IN  MATER  : CHAMP MATERIAU
! IN  CARELE : CHAMP DE CARAC_ELEM
! IN  MATELZ : NOM DU MATR_ELEM RESULTAT
! IN  TIME   : INSTANT DE CALCUL
! IN  NH     : NUMERO D'HARMONIQUE DE FOURIER
! IN  BASE   : NOM DE LA BASE
! IN  COMPOR : COMPOR POUR LES MULTIFIBRE (POU_D_EM)
!
! ----------------------------------------------------------------------
!
    call merime(modelz, nchar, lchar, mateco, carelz,&
                time, compoz, matelz, nh,&
                basz, mater)
end subroutine
