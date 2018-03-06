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
! aslint: disable=W1504
!
subroutine nmpich(modele         , numedd, ds_material, carele    ,&
                  ds_constitutive, lischa, fonact, ds_measure, ds_contact,&
                  sdpilo         , iterat, sdnume, deltat    , valinc    ,&
                  solalg         , veelem, veasse, sddisc    , eta       ,&
                  rho            , offset, ldccvg, pilcvg    , matass)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/nmceta.h"
#include "asterfort/nmpilo.h"
!
integer :: fonact(*)
integer :: iterat, pilcvg, ldccvg
real(kind=8) :: deltat, eta, rho, offset
character(len=19) :: lischa, sdnume, sdpilo, sddisc, matass
character(len=24) :: modele, numedd, carele
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Contact), intent(in) :: ds_contact
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19) :: veelem(*), veasse(*)
character(len=19) :: solalg(*), valinc(*)
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE)
!
! CALCUL DU ETA DE PILOTAGE ET CALCUL DE LA CORRECTION
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : MODELE
! IN  NUMEDD : NUME_DDL
! In  ds_material      : datastructure for material parameters
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! IN  SDNUME : SD NUMEROTATION
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  LISCHA : LISTE DES CHARGES
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDPILO : SD PILOTAGE
! IN  FONACT : FONCTIONNALITES ACTIVEES
! In  ds_contact       : datastructure for contact management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! IN  DELTAT : INCREMENT DE TEMPS
! IN  NBEFFE : NOMBRE DE VALEURS DE PILOTAGE ENTRANTES
! IN  SDDISC : SD DISCRETISATION
! OUT ETA    : PARAMETRE DE PILOTAGE
! OUT RHO    : PARAMETRE DE RECHERCHE_LINEAIRE
! OUT OFFSET : DECALAGE DE ETA_PILOTAGE EN FONCTION DE RHO
! OUT PILCVG : CODE DE CONVERGENCE POUR LE PILOTAGE
!                -1 : PAS DE CALCUL DU PILOTAGE
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : PAS DE SOLUTION
!                 2 : BORNE ATTEINTE -> FIN DU CALCUL
! OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 2 : ERREUR SUR LA NON VERIF. DE CRITERES PHYSIQUES
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
! IN  MATASS : SD MATRICE ASSEMBLEE
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbeffe, nbatte
    real(kind=8) :: proeta(2), residu
    integer :: ifm, niv
    aster_logical :: irecli
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('PILOTAGE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<PILOTAGE> ... PILOTAGE SANS RECH_LINE'
    endif
!
! --- INITIALISATIONS
!
    pilcvg = -1
    rho = 1.d0
    offset = 0.d0
    nbatte = 2
    irecli = ASTER_FALSE
!
! --- RESOLUTION DE L'EQUATION DE PILOTAGE
!
    call nmpilo(sdpilo, deltat, rho            , solalg    , veasse,&
                modele, ds_material, ds_constitutive, ds_contact, valinc,&
                nbatte, numedd, nbeffe         , proeta    , pilcvg,&
                carele)
!
! - CHOIX DE ETA_PILOTAGE
!
    if (pilcvg .ne. 1) then
        call nmceta(modele         , numedd, ds_material, carele    ,&
                    ds_constitutive, lischa, fonact, ds_measure,&
                    sdpilo         , iterat, sdnume, valinc    , solalg    ,&
                    veelem         , veasse, sddisc, nbeffe    , irecli    ,&
                    proeta         , offset, rho   , eta       , ldccvg    ,&
                    pilcvg         , residu, matass)
    endif
!
! --- LE CALCUL DE PILOTAGE A FORCEMENT ETE REALISE
!
    ASSERT(pilcvg.ge.0)
!
end subroutine
