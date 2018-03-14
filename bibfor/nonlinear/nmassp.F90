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
subroutine nmassp(modele         , numedd, ds_material, carele    ,&
                  ds_constitutive, fonact, ds_measure , ds_contact,&
                  sddyna         , valinc, solalg     , veelem    , veasse,&
                  ldccvg         , cnpilo, cndonn     , sdnume    ,&
                  ds_algorom)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/ndassp.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nsassp.h"
#include "asterfort/vtzero.h"
!
integer :: ldccvg
integer :: fonact(*)
character(len=19) :: sddyna, sdnume
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24) :: modele, numedd
type(NL_DS_Material), intent(in) :: ds_material
character(len=24) :: carele
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: solalg(*), valinc(*)
character(len=19) :: veasse(*), veelem(*)
character(len=19) :: cnpilo, cndonn
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PREDICTION)
!
! CALCUL DU SECOND MEMBRE POUR LA PREDICTION
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : NOM DU MODELE
! IN  NUMEDD : NOM DE LA NUMEROTATION
! In  ds_material      : datastructure for material parameters
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! In  ds_constitutive  : datastructure for constitutive laws management
! In  ds_contact       : datastructure for contact management
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IO  ds_measure       : datastructure for measure and statistics management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  SDNUME : SD NUMEROTATION
! OUT CNPILO : VECTEUR ASSEMBLE DES FORCES PILOTEES
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
! OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 2 : ERREUR SUR LA NON VERIF. DE CRITERES PHYSIQUES
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_stat, l_dyna
!
! --------------------------------------------------------------------------------------------------
!
    ldccvg = -1
    call vtzero(cnpilo)
    call vtzero(cndonn)
!
! - Active functionnalities
!
    l_stat = ndynlo(sddyna,'STATIQUE')
    l_dyna = ndynlo(sddyna,'DYNAMIQUE')
!
! - Evaluate second member for prediction
!
    if (l_dyna) then
        call ndassp(modele         , numedd, ds_material, carele,&
                    ds_constitutive, ds_measure , fonact, ds_contact,&
                    sddyna         , valinc, solalg     , veelem, veasse    ,&
                    ldccvg         , cndonn, sdnume     )
    else if (l_stat) then
        call nsassp(fonact, ds_material, ds_contact, ds_algorom,&
                    veasse, cnpilo     , cndonn )
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
