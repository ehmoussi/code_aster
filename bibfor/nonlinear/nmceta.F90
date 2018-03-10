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
subroutine nmceta(modele         , numedd, ds_material, carele    ,&
                  ds_constitutive, ds_contact, lischa, fonact, ds_measure,&
                  sdpilo         , iterat, sdnume, valinc    , solalg    ,&
                  veelem         , veasse, sddisc, nbeffe    , irecli    ,&
                  proeta         , offset, rho   , etaf      , ldccvg    ,&
                  pilcvg         , residu, matass)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8maem.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmcere.h"
#include "asterfort/nmcese.h"
!
integer :: fonact(*)
aster_logical :: irecli
integer :: iterat, nbeffe
integer :: ldccvg, pilcvg
real(kind=8) :: etaf, proeta(2), rho, offset, residu
character(len=19) :: lischa, sdnume, sdpilo, matass
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
! CHOIX DU PARAMETRE DE PILOTAGE
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : MODELE
! IN  NUMEDD : NUME_DDL
! In  ds_material      : datastructure for material parameters
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! In  ds_constitutive  : datastructure for constitutive laws management
! In  ds_contact       : datastructure for contact management
! IN  LISCHA : LISTE DES CHARGES
! IN  SDPILO : SD PILOTAGE
! IN  SDNUME : SD NUMEROTATION
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  OFFSET : DECALAGE DE ETA_PILOTAGE EN FONCTION DE RHO
! IN  IRECLI : VRAI SI RECH LIN (ON VEUT LE RESIDU)
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDDISC : SD DISCRETISATION
! OUT ETAF   : PARAMETRE DE PILOTAGE
! I/O PILCVG : CODE DE CONVERGENCE POUR LE PILOTAGE
!                -1 : PAS DE CALCUL DU PILOTAGE
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : PAS DE SOLUTION
!                 2 : BORNE ATTEINTE -> FIN DU CALCUL
! OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
! OUT RESIDU : RESIDU OPTIMAL SI L'ON A CHOISI LE RESIDU
! IN  MATASS : SD MATRICE ASSEMBLEE
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: bormin, bormax
    integer :: j, i
    integer :: licite(2)
    real(kind=8) :: infini
    real(kind=8) :: etamin, etamax, conmin, conmax
    real(kind=8) :: eta(2)
    character(len=24) :: projbo, typsel
    character(len=19) :: sddisc
    integer :: ifm, niv
    real(kind=8), pointer :: plir(:) => null()
    character(len=24), pointer :: pltk(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('PILOTAGE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<PILOTAGE> ...... SELECTION DU ETA_PILOTAGE'
    endif
!
! --- LE CALCUL DE PILOTAGE A FORCEMENT ETE REALISE
!
    ASSERT(pilcvg.ge.0)
!
! --- INITIALISATIONS
!
    licite(1) = 0
    licite(2) = 0
    infini = r8maem()
!
! --- LECTURE DONNEES PILOTAGE
!
    call jeveuo(sdpilo(1:19)//'.PLTK', 'L', vk24=pltk)
    call jeveuo(sdpilo(1:19)//'.PLIR', 'L', vr=plir)
    projbo = pltk(5)
    typsel = pltk(6)
!
    if (plir(2) .ne. r8vide()) then
        etamax = plir(2)
        bormax = .true.
    else
        etamax = r8vide()
        bormax = .false.
    endif
!
    if (plir(3) .ne. r8vide()) then
        etamin = plir(3)
        bormin = .true.
    else
        etamin = r8vide()
        bormin = .false.
    endif
!
    if (plir(4) .ne. r8vide()) then
        conmax = plir(4)
    else
        conmax = infini
    endif
!
    if (plir(5) .ne. r8vide()) then
        conmin = plir(5)
    else
        conmin = -infini
    endif
!
! --- INTERSECTION AVEC L'INTERVALLE DE CONTROLE ETA_PILO_R_*
!
    j=0
    do i = 1, nbeffe
        if (proeta(i) .ge. conmin .and. proeta(i) .le. conmax) then
            j = j+1
            eta(j) = proeta(i)
            licite(j) = licite(i)
        endif
    end do
    nbeffe = j
!
    if (nbeffe .eq. 0) then
        pilcvg = 1
        goto 999
    endif
!
! --- INTERSECTION AVEC L'INTERVALLE ETA_PILO_*
!      - SI PROJ_BORNE = 'OUI', ON PROJETE ETA SUR L'INTERVALLE
!      - DANS TOUS LES CAS, LICITE = -1 INDIQUE QU'ON A FRANCHI LES
!        BORNES
!
    do i = 1, nbeffe
        if (bormax) then
            if (eta(i) .gt. etamax) then
                if (projbo .eq. 'OUI') eta(i) = etamax
                licite(i) = 2
            endif
        endif
        if (bormin) then
            if (eta(i) .lt. etamin) then
                if (projbo .eq. 'OUI') eta(i) = etamin
                licite(i) = 2
            endif
        endif
    end do
!
! --- SELECTION DU PARAMETRE DE PILOTAGE ETAF
!     S'IL EXISTE DEUX ETA SOLUTIONS :
!        - ON DEMANDE A NMCESE DE CHOISIR
    if (nbeffe .eq. 2) then
        call nmcese(modele         , numedd, ds_material, carele    ,&
                    ds_constitutive, ds_contact, lischa, fonact, ds_measure,&
                    iterat         , sdnume, sdpilo, valinc    , solalg    ,&
                    veelem         , veasse, offset, typsel    , sddisc    ,&
                    licite         , rho   , eta   , etaf      , residu    ,&
                    ldccvg         , pilcvg, matass)
    else if (nbeffe.eq.1) then
        etaf = eta(1)
        pilcvg = licite(1)
    else
        ASSERT(.false.)
    endif
!
! --- CALCUL DU RESIDU POUR LA RECHERCHE LINEAIRE
!
    if (irecli) then
! ----- CETTE ETAPE EST SAUTEE SI LE RESIDU EST DEJA CALCULE DANS NMCESE
        if (typsel .eq. 'RESIDU' .and. nbeffe .eq. 2)     continue
        call nmcere(modele         , numedd, ds_material, carele    , &
                    ds_constitutive, ds_contact, lischa, fonact, ds_measure,&
                    iterat         , sdnume, valinc, solalg    , veelem    ,&
                    veasse         , offset, rho   , etaf      , residu    ,&
                    ldccvg         , matass)
    endif
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<PILOTAGE> ...... ETA_PILOTAGE: ',etaf
        write (ifm,*) '<PILOTAGE> ...... RESIDU OPTI.: ',residu
    endif
!
999 continue
!
! --- LE CALCUL DE PILOTAGE A FORCEMENT ETE REALISE
!
    ASSERT(pilcvg.ge.0)
!
end subroutine
