! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmchap(valinc, solalg, meelem, veelem, veasse,&
                  measse)
!
implicit none
!
#include "asterfort/infdbg.h"
#include "asterfort/nmch1p.h"
#include "asterfort/nmch2p.h"
#include "asterfort/nmch3p.h"
#include "asterfort/nmch4p.h"
#include "asterfort/nmch5p.h"
#include "asterfort/nmch6p.h"
!
character(len=19) :: veelem(*), meelem(*)
character(len=19) :: veasse(*), measse(*)
character(len=19) :: solalg(*), valinc(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (INITIALISATION)
!
! CREATION DES VARIABLES CHAPEAUX
!
! ----------------------------------------------------------------------
!
!
! ON NE FAIT QUE REMPLIR LES VARIABLES CHAPEAUX AVEC LES NOMS
! LA CREATION DES SD EST FAITE PRINCIPALEMENT DANS NMCRCH
!
! OUT VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! OUT SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! OUT VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! OUT MEELEM : VARIABLE CHAPEAU POUR NOM DES MATR_ELEM
! OUT VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! OUT MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
!
! ----------------------------------------------------------------------
!
!
! --- VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
!
    call nmch1p(valinc)
!
! --- VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
!
    call nmch2p(solalg)
!
! --- VARIABLE CHAPEAU POUR NOM DES MATR_ELEM
!
    call nmch3p(meelem)
!
! --- VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
!
    call nmch4p(veelem)
!
! --- VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
!
    call nmch5p(veasse)
!
! --- VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
!
    call nmch6p(measse)
!
end subroutine
