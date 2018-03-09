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
subroutine nmfcon(modele    , numedd, ds_material, fonact         , ds_contact,&
                  ds_measure, valinc, solalg     , ds_constitutive)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmfocc.h"
!
integer :: fonact(*)
character(len=24) :: modele, numedd
character(len=19) :: solalg(*), valinc(*)
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Contact), intent(in) :: ds_contact
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! MISE A JOUR DES EFFORTS DE CONTACT
!
! ----------------------------------------------------------------------
!
! IN  MODELE : MODELE
! IN  NUMEDD : NUME_DDL
! In  ds_material      : datastructure for material parameters
! IN  FONACT : FONCTIONNALITES ACTIVEES
! In  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! In  ds_constitutive  : datastructure for constitutive laws management
!
! ----------------------------------------------------------------------
!
    aster_logical :: leltc
!
! ----------------------------------------------------------------------
!
    leltc = isfonc(fonact,'ELT_CONTACT')
!
! --- CALCUL DU SECOND MEMBRE POUR CONTACT/XFEM
!
    if (leltc) then
        call nmfocc('CORRECTION', modele    , ds_material, numedd, fonact,&
                    ds_contact  , ds_measure, solalg,valinc, ds_constitutive)
    endif
!
end subroutine
