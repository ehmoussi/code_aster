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
! person_in_charge: mickael.abbas at edf.fr
! aslint: disable=W1504
!
subroutine nmpost(modele , mesh    , numedd, numfix     , carele  ,&
                  ds_constitutive , numins  , mate  , comref     , ds_inout,&
                  ds_contact, ds_algopara, fonact  ,&
                  ds_print, ds_measure, sddisc     , &
                  sd_obsv, sderro  , sddyna, ds_posttimestep, valinc  ,&
                  solalg , meelem  , measse, veelem     , veasse  ,&
                  ds_energy, sdcriq  , eta   , lischa)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfmxpo.h"
#include "asterfort/isfonc.h"
#include "asterfort/lobs.h"
#include "asterfort/diinst.h"
#include "asterfort/nmener.h"
#include "asterfort/nmetca.h"
#include "asterfort/nmleeb.h"
#include "asterfort/nmobsv.h"
#include "asterfort/nmspec.h"
#include "asterfort/nmtime.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmrest_ecro.h"
!
integer :: numins
character(len=8), intent(in) :: mesh
real(kind=8) :: eta
type(NL_DS_InOut), intent(in) :: ds_inout
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
character(len=19) :: meelem(*)
type(NL_DS_Contact), intent(inout) :: ds_contact
type(NL_DS_Energy), intent(inout) :: ds_energy
character(len=19) :: lischa
character(len=19) :: sddisc, sddyna
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
character(len=19), intent(in) :: sd_obsv
type(NL_DS_Print), intent(in) :: ds_print
character(len=24) :: modele, numedd, numfix
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=19) :: veelem(*), measse(*), veasse(*)
character(len=19) :: solalg(*), valinc(*)
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24) :: sderro, sdcriq
character(len=24) :: mate, carele
character(len=24) :: comref
integer :: fonact(*)
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! CALCULS DE POST-TRAITEMENT
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : MODELE
! IN  NUMEDD : NUME_DDL
! IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
! IN  MATE   : CHAMP MATERIAU
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! IN  COMREF : VARI_COM DE REFERENCE
! In  ds_constitutive  : datastructure for constitutive laws management
! In  ds_inout         : datastructure for input/output management
! In  ds_print         : datastructure for printing parameters
! IO  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDDYNA : SD POUR LA DYNAMIQUE
! IO  ds_energy        : datastructure for energy management
! In  ds_algopara      : datastructure for algorithm parameters
! IN  NUMINS : NUMERO D'INSTANT
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
! IN  SDCRIQ : SD CRITERE QUALITE
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: lmvib, lflam, lerrt, lcont, lener, l_post_incr, l_obsv, l_post
    character(len=4) :: etfixe
    real(kind=8) :: time
!
! --------------------------------------------------------------------------------------------------
!
    lcont       = isfonc(fonact,'CONTACT')
    lerrt       = isfonc(fonact,'ERRE_TEMPS_THM')
    lmvib       = isfonc(fonact,'MODE_VIBR')
    lflam       = isfonc(fonact,'CRIT_STAB')
    lener       = isfonc(fonact,'ENERGIE')
    l_post_incr = isfonc(fonact,'POST_INCR')
!
! - Observation ?
!
    l_obsv = .false.
    time   = diinst(sddisc, numins)
    call lobs(sd_obsv, numins, time, l_obsv)
!
! - State of time loop
!
    call nmleeb(sderro, 'FIXE', etfixe)
!
! - Post-treatment ?
!
    l_post = (lerrt .or. lcont .or. lmvib .or. lflam .or. lener .or. l_obsv .or. l_post_incr).and.&
             etfixe .eq. 'CONV'
!
    if (.not.l_post) then
        goto 99
    endif
!
! - Launch timer for post-treatment
!
    call nmtime(ds_measure, 'Init'  , 'Post')
    call nmtime(ds_measure, 'Launch', 'Post')
!
! --- CALCUL EVENTUEL DE L'INDICATEUR D'ERREUR TEMPORELLE THM
!
    if (lerrt) then
        call nmetca(modele, mesh, mate, sddisc, sdcriq,&
                    numins, valinc)
    endif
!
! --- POST_TRAITEMENT DU CONTACT
!
    if (lcont) then
        call cfmxpo(mesh      , modele, ds_contact, numins, sddisc,&
                    ds_measure, solalg, valinc    , veasse)
    endif
!
! --- CALCUL DE POST-TRAITEMENT: STABILITE ET MODES VIBRATOIRES
!!
!    if (lmvib .or. lflam) then
!        call nmspec(modele     , numedd         , numfix  , carele    , ds_constitutive,&
!                    numins     , mate           , comref  , lischa    , ds_contact     ,&
!                    ds_algopara, fonact         , ds_print, ds_measure, sddisc         ,&
!                    valinc     , solalg         , meelem  , measse    , veelem         ,&
!                    sddyna     , ds_posttimestep, sderro)
!    endif
!
! --- CALCUL DES ENERGIES
!
    if (lener) then
        call nmener(valinc, veasse, measse, sddyna, eta        ,&
                    ds_energy, fonact, numedd, numfix, ds_algopara,&
                    meelem, numins, modele, mate  , carele     ,&
                    ds_constitutive, ds_measure, sddisc, solalg, lischa     ,&
                    comref, veelem, ds_inout)
    endif
!
! - Post-treatment for behavior laws.
!
    if (l_post_incr) then
        call nmrest_ecro(modele, mate, ds_constitutive, valinc)
    endif
!
! - Make observation
!
    if (l_obsv) then
        call nmobsv(mesh  , modele, sddisc         , sd_obsv, numins,&
                    carele, mate  , ds_constitutive, comref , valinc)
    endif
!
! - End of timer for post-treatment
!
    call nmtime(ds_measure, 'Stop', 'Post')
    call nmrinc(ds_measure, 'Post')
!
99  continue
!
end subroutine
