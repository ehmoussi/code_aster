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

subroutine cfdeco(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/cfsvmu.h"
#include "asterfort/jedupo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE DISCRETE - POST-TRAITEMENT)
!
! SAUVEGARDE DES VECTEURS DE JEU
!
! ----------------------------------------------------------------------
!
! ON SAUVEGARDE LE JEU POUR PERMETTRE LA SUBDIVISION DU PAS DE TEMPS
! EN GEOMETRIE INITIALE (REAC_GEOM='SANS')
!
! RECUPERATION ULTERIEURE EVENTUELLE DANS REAJEU
!
! ON SAUVEGARDE LE LAGRANGE DE CONTACT POUR PERMETTRE SA RESTAURATION
! EN CAS DE DECOUPE EN GCP (ALGO_CONT='GCP')
!
! RECUPERATION ULTERIEURE DANS CFRSMU
!
! ON SAUVEGARDE LE STATUT DE FROTTEMENT POUR PERMETTRE SA RESTAURATION
! EN CAS DE DECOUPE EN LAGRANGIEN (ALGO_FROT='LAGRANGIEN')
!
! RECUPERATION ULTERIEURE DANS CFINAL
!
! In  ds_contact       : datastructure for contact management
!
! ----------------------------------------------------------------------
!
    character(len=24) :: jeuite, jeusav
!
! ----------------------------------------------------------------------
!
! --- SAUVEGARDE DU JEU POUR REAC_GEOM='SANS'
!
    jeuite = ds_contact%sdcont_solv(1:14)//'.JEUITE'
    jeusav = ds_contact%sdcont_solv(1:14)//'.JEUSAV'
    call jedupo(jeuite, 'V', jeusav, .false._1)
!
! --- SAUVEGARDE DU LAGRANGE DE CONTACT POUR ALGO_CONT='GCP'
!
    call cfsvmu(ds_contact, .true._1)
!
end subroutine
