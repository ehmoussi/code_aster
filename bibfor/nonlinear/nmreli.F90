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
subroutine nmreli(modele         , numedd, ds_material, carele    , &
                  ds_constitutive, lischa, fonact     , iterat    , ds_measure,&
                  sdnume         , sddyna, ds_algopara, ds_contact, valinc    ,&
                  solalg         , veelem, veasse     , ds_conv   , ldccvg)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/copisd.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmrelp.h"
!
integer :: fonact(*)
integer :: iterat, ldccvg
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: lischa, sddyna, sdnume
type(NL_DS_Material), intent(in) :: ds_material
character(len=24) :: modele, numedd, carele
character(len=19) :: veelem(*), veasse(*)
character(len=19) :: solalg(*), valinc(*)
type(NL_DS_Conv), intent(inout) :: ds_conv
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! RECHERCHE LINEAIRE DANS LA DIRECTION DE DESCENTE
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : MODELE
! IN  NUMEDD : NUME_DDL
! In  ds_material      : datastructure for material parameters
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  LISCHA : LISTE DES CHARGES
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_contact       : datastructure for contact management
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! IN  SDNUME : SD NUMEROTATION
! In  ds_algopara      : datastructure for algorithm parameters
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  SDDYNA : SD DYNAMIQUE
! OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
! IO  ds_conv          : datastructure for convergence management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: ddepla, deppr1
!
! --------------------------------------------------------------------------------------------------
!
    call nmchex(solalg, 'SOLALG', 'DDEPLA', ddepla)
    call nmchex(solalg, 'SOLALG', 'DEPPR1', deppr1)
!
! --- RECOPIE DE L'INC. PREDICTION EN INC. SOLUTION
!
    call copisd('CHAMP_GD', 'V', deppr1, ddepla)
!
! --- RECHERCHE LINEAIRE DANS LA DIRECTION DE DESCENTE
!
    call nmrelp(modele         , numedd, ds_material, carele    ,&
                ds_constitutive, lischa, fonact     , iterat    , ds_measure,&
                sdnume         , sddyna, ds_algopara, ds_contact, valinc    ,&
                solalg         , veelem, veasse     , ds_conv   , ldccvg)
!
end subroutine
