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
subroutine nmdepl(modele         , numedd , ds_material, carele    ,&
                  ds_constitutive, lischa , fonact, ds_measure, ds_algopara,&
                  noma           , numins , iterat, solveu    , matass     ,&
                  sddisc         , sddyna , sdnume, sdpilo    , sderro     ,&
                  ds_contact     , valinc , solalg, veelem    , veasse     ,&
                  eta            , ds_conv, lerrit)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cldual_maj.h"
#include "asterfort/dbgcha.h"
#include "asterfort/diinst.h"
#include "asterfort/GetResi.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmcoun.h"
#include "asterfort/nmcret.h"
#include "asterfort/nmfext.h"
#include "asterfort/nmltev.h"
#include "asterfort/nmmajc.h"
#include "asterfort/nmpich.h"
#include "asterfort/nmpild.h"
#include "asterfort/nmreli.h"
#include "asterfort/nmrepl.h"
#include "asterfort/nmsolm.h"
#include "asterfort/nmsolu.h"
!
integer :: fonact(*)
integer :: iterat, numins
real(kind=8) :: eta
character(len=8) :: noma
type(NL_DS_Conv), intent(inout) :: ds_conv
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
character(len=19) :: sddisc, sdnume, sddyna, sdpilo
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19) :: lischa, matass, solveu
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Material), intent(in) :: ds_material
character(len=24) :: modele, numedd, carele
character(len=24) :: sderro
character(len=19) :: veelem(*), veasse(*)
character(len=19) :: solalg(*), valinc(*)
type(NL_DS_Contact), intent(inout) :: ds_contact
aster_logical :: lerrit
!
! --------------------------------------------------------------------------------------------------
!
! CALCUL DE L'INCREMENT DE DEPLACEMENT A PARTIR DE(S) DIRECTION(S)
! DE DESCENTE
! PRISE EN COMPTE DU PILOTAGE ET DE LA RECHERCHE LINEAIRE
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : MODELE
! IN  NUMEDD : NUME_DDL
! In  ds_material      : datastructure for material parameters
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  LISCHA : LISTE DES CHARGES
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_algopara      : datastructure for algorithm parameters
! IN  NOMA   : NOM DU MAILLAGE
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! IN  NUMINS : NUMERO D'INSTANT
! IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
! IN  SOLVEU : NOM DU SOLVEUR
! IN  SDNUME : SD NUMEROTATION
! IN  SDDISC : SD DISCRETISATION
! IN  SDDYNA : SD DYNAMIQUE
! IN  SDPILO : SD PILOTAGE
! IN  SDERRO : SD GESTION DES ERREURS
! IO  ds_contact       : datastructure for contact management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IO  ds_conv          : datastructure for convergence management
! I/O ETA    : PARAMETRE DE PILOTAGE
! OUT LERRIT : .TRUE. SI ERREUR PENDANT L'ITERATION
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: etan, offset, rho
    real(kind=8) :: instam, instap, deltat, resi_glob_rela
    aster_logical :: lpilo, lreli, lctcd, lunil, l_diri_undead
    character(len=19) :: cnfext, depplu
    integer :: ctccvg, ldccvg, pilcvg
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> CORRECTION INCR. DEPL.'
    endif
!
! --- INITIALISATIONS CODES RETOURS
!
    ldccvg = -1
    ctccvg = -1
    pilcvg = -1
!
! - Active functionnalites
!
    lpilo         = isfonc(fonact,'PILOTAGE')
    lreli         = isfonc(fonact,'RECH_LINE')
    lunil         = isfonc(fonact,'LIAISON_UNILATER')
    lctcd         = isfonc(fonact,'CONT_DISCRET')
    l_diri_undead = isfonc(fonact,'DIRI_UNDEAD')
    call nmchex(valinc, 'VALINC', 'DEPPLU', depplu)
!
! --- INITIALISATIONS
!
    instam = diinst(sddisc,numins-1)
    instap = diinst(sddisc,numins)
    deltat = instap - instam
    etan = eta
    rho = 1.d0
    ds_conv%line_sear_coef = 1.d0
    offset = 0.d0
    eta = 0.d0
    call GetResi(ds_conv, type = 'RESI_GLOB_RELA' , vale_calc_ = resi_glob_rela)
!
! --- CALCUL DE LA RESULTANTE DES EFFORTS EXTERIEURS
!
    call nmchex(veasse, 'VEASSE', 'CNFEXT', cnfext)
    call nmfext(etan, fonact, sddyna, veasse, cnfext, ds_contact)
!
! --- CONVERSION RESULTAT dU VENANT DE K.dU = F SUIVANT SCHEMAS
!
    call nmsolu(sddyna, solalg)
!
! --- PAS DE RECHERCHE LINEAIRE (EN PARTICULIER SUITE A LA PREDICTION)
!
    if (.not.lreli .or. iterat .eq. 0) then
        if (lpilo) then
            call nmpich(modele         , numedd, ds_material, carele    ,&
                        ds_constitutive, lischa, fonact, ds_measure, ds_contact,&
                        sdpilo         , iterat, sdnume, deltat    , valinc    ,&
                        solalg         , veelem, veasse, sddisc    , eta       ,&
                        rho            , offset, ldccvg, pilcvg    , matass)
            ds_conv%line_sear_coef = 1.d0
            ds_conv%line_sear_iter = 0
        endif
    else
!
! --- RECHERCHE LINEAIRE
!
        if (lpilo) then
            call nmrepl(modele         , numedd, ds_material, carele,&
                        ds_constitutive, lischa, ds_algopara, fonact, iterat    ,&
                        ds_measure     , sdpilo, sdnume     , sddyna, ds_contact,&
                        deltat         , valinc, solalg     , veelem, veasse    ,&
                        sddisc         , etan  , ds_conv    , eta   , offset    ,&
                        ldccvg         , pilcvg, matass )
        else
            call nmreli(modele         , numedd, ds_material, carele    ,&
                        ds_constitutive, lischa, fonact     , iterat    , ds_measure,&
                        sdnume         , sddyna, ds_algopara, ds_contact, valinc    ,&
                        solalg         , veelem, veasse     , ds_conv   , ldccvg)
        endif
    endif
!
! --- SI ERREUR PENDANT L'INTEGRATION OU LE PILOTAGE -> ON SORT DIRECT
!
    if ((ldccvg .eq. 1) .or. (pilcvg .eq. 1)) then
        goto 999
    endif
!
! --- AJUSTEMENT DE LA DIRECTION DE DESCENTE (AVEC ETA, RHO ET OFFSET)
!
    rho = ds_conv%line_sear_coef
    call nmpild(numedd, sddyna, solalg, eta, rho,&
                offset)
!
! --- MODIFICATIONS DEPLACEMENTS SI CONTACT DISCRET OU LIAISON_UNILA
!
    if (lunil .or. lctcd) then
        call nmcoun(noma          , fonact, solveu, numedd    , matass,&
                    iterat        , instap, valinc, solalg    , veasse,&
                    resi_glob_rela, ds_measure, ds_contact, ctccvg)
        if (ctccvg .eq. 0) then
            call nmsolm(sddyna, solalg)
        else
            goto 999
        endif
    endif
!
! --- ACTUALISATION DES CHAMPS SOLUTIONS
!
    call nmmajc(fonact, sddyna, sdnume, deltat, numedd,&
                valinc, solalg)
!
! - Update dualized relations for non-linear Dirichlet boundary conditions (undead)
!
    if (l_diri_undead) then
        call cldual_maj(lischa, depplu)
    endif
!
999 continue
!
! --- TRANSFORMATION DES CODES RETOURS EN EVENEMENTS
!
    call nmcret(sderro, 'LDC', ldccvg)
    call nmcret(sderro, 'PIL', pilcvg)
    call nmcret(sderro, 'CTC', ctccvg)
!
! --- EVENEMENT ERREUR ACTIVE ?
!
    call nmltev(sderro, 'ERRI', 'NEWT', lerrit)
!
! --- IMPRESSION D'UN CHAMP POUR DEBUG
!
    call dbgcha(valinc, instap, iterat)
!
end subroutine
