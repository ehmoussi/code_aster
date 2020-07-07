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
! person_in_charge: tanguy.mathieu at edf.fr
!
subroutine op0027()
!
use calcG_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cgComputeTheta.h"
#include "asterfort/cgTableG.h"
#include "asterfort/cgVerification.h"
#include "asterfort/deprecated_algom.h"
#include "asterfort/infmaj.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
!      OPERATEUR :     CALC_H
!
!      BUT:CALCUL DU TAUX DE RESTITUTION D'ENERGIE PAR LA METHODE THETA
!          CALCUL DES FACTEURS D'INTENSITE DE CONTRAINTES
!
!---------------------------------------------------------------------------------------------------
!
    type(CalcG_field) :: cgField
    type(CalcG_theta) :: cgTheta
    type(CalcG_study) :: cgStudy
!
    integer :: iopt, istore, nume_ordre
    character(len=8) :: option
    character(len=24) :: law
    aster_logical :: l_comput_stress
!
    call infmaj()
    call deprecated_algom('CALC_H')
!
! Fiches concernées par le chantier (A supprimer à la fin)
!
! A Faire: #29573, #27931, #29703
!
! Faite :
!
! --- Initialization
!
    call cgField%initialize()
    call cgTheta%initialize()
!
!
    if(cgField%level_info > 1) then
        call cgField%print()
        call cgTheta%print()
    end if
!
! --- Verification
!
    call cgVerification(cgField, cgTheta)
!
! --- Compute Theta
!
    call cgComputeTheta(cgField, cgTheta)
!
! --- Loop on option
!
    do iopt = 1, cgField%nb_option
        option = cgField%list_option(iopt)
        law = "ELAS"
        l_comput_stress = ASTER_TRUE
        call cgStudy%setOption(option, law, l_comput_stress)
!
        if(cgField%level_info > 1) then
            call utmess("I", "RUPTURE3_5", sk=option)
        end if
!
! ------ Loop on nume_store
!
        do istore = 1, cgField%nb_nume
            nume_ordre = cgField%list_nume(istore)
            call cgStudy%initialize(cgField%result_in, nume_ordre)
            ASSERT(cgTheta%mesh == cgStudy%mesh)
!
            if(cgField%level_info > 1) then
                call cgStudy%print()
            end if
! TODO ADD TE
        end do
!
    end do
!
! --- Create Table for G (temporary)
!
    call cgTableG(cgField, cgTheta)
!
end subroutine
