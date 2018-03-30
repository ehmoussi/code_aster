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
subroutine nmarch(numins         , modele  , ds_material, carele, fonact   ,&
                  ds_constitutive, ds_print, sddisc     , sdcrit,&
                  ds_measure     , sderro  , sddyna     , sdpilo, ds_energy,&
                  ds_inout       , sdcriq  , ds_algorom_)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/isfonc.h"
#include "asterfort/diinst.h"
#include "asterfort/dinuar.h"
#include "asterfort/nmarc0.h"
#include "asterfort/nmarce.h"
#include "asterfort/nmarpc.h"
#include "asterfort/nmcrpc.h"
#include "asterfort/nmfinp.h"
#include "asterfort/nmleeb.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmtime.h"
#include "asterfort/rsagsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
#include "asterfort/uttcpg.h"
#include "asterfort/romAlgoNLTableSave.h"
!
integer :: fonact(*)
integer :: numins
type(NL_DS_Print), intent(in) :: ds_print
type(NL_DS_InOut), intent(in) :: ds_inout
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Energy), intent(in) :: ds_energy
character(len=19) :: sddisc, sdcrit, sddyna, sdpilo
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=24) :: sderro, sdcriq
character(len=24) :: modele, carele
type(ROM_DS_AlgoPara), optional, intent(in) :: ds_algorom_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Storing results
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_inout         : datastructure for input/output management
! In  ds_print         : datastructure for printing parameters
! IN  NUMINS : NUMERO DE L'INSTANT
! IN  MODELE : NOM DU MODELEE
! In  ds_material      : datastructure for material parameters
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  SDCRIT : VALEUR DES CRITERES DE CONVERGENCE
! IN  SDCRIQ : SD CRITERE QUALITE
! IN  SDERRO : SD ERREUR
! IN  SDDYNA : SD DEDIEE A LA DYNAMIQUE
! IN  SDPILO : SD PILOTAGE
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_energy        : datastructure for energy management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! In  ds_algorom       : datastructure for ROM parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, nume_store
    real(kind=8) :: instan
    character(len=8) :: result
    aster_logical :: force, lprint
    character(len=19) :: k19bid, list_load_resu
    character(len=4) :: etcalc
    integer :: nume_reuse
!
! --------------------------------------------------------------------------------------------------
!
    result         = ds_inout%result
    list_load_resu = ds_inout%list_load_resu
!
! - Loop state.
!
    call nmleeb(sderro, 'CALC', etcalc)
!
! - Last step => storing
!
    force = .false.
    call nmfinp(sddisc, numins, force)
!
! - Storing
!
    if (etcalc .eq. 'CONV') then 
        force = .true.
    endif
    if (etcalc .eq. 'STOP') then
        force = .true.
    endif
!
! - Print timer
!
    call uttcpg('IMPR', 'INCR')
!
! - Get index for storing
!
    call dinuar(result    , sddisc    , numins, force,&
                nume_store, nume_reuse)
!
! - Current time
!
    instan = diinst(sddisc,numins)
!
! - Save energy parameters in output table
!
    if (isfonc(fonact,'ENERGIE')) then
        call nmarpc(ds_energy, nume_reuse, instan)
    else
        call nmcrpc(ds_inout, nume_reuse, instan)
    endif
!
! - Print or not ?
!
    lprint = ds_print%l_print
!
! - Storing
!
    if (nume_store .ge. 0) then
!
! ----- Begin timer
!
        call nmtime(ds_measure, 'Launch', 'Store')
!
! ----- Print head
!
        if (lprint) then
            call utmess('I', 'ARCHIVAGE_5')
        endif
!
! ----- Increased result datastructure if necessary
!
        call rsexch(' ', result, 'DEPL', nume_store, k19bid,&
                    iret)
        if (iret .eq. 110) then
            call rsagsd(result, 0)
        endif
!
! ----- Storing parameters
!
        call nmarc0(result, modele        , ds_material    , carele, fonact,&
                    sdcrit, sddyna        , ds_constitutive, sdcriq,&
                    sdpilo, list_load_resu, nume_store     , instan)
!
! ----- Stroring fields
!
        call nmarce(ds_inout, result  , sddisc, instan, nume_store,&
                    force   , ds_print)
!
! ----- Storing reduced parameters table (ROM)
!
        if (present(ds_algorom_)) then
            if (ds_algorom_%l_rom) then
                if (nume_store .gt. 0) then
                    call romAlgoNLTableSave(nume_store, instan, ds_algorom_)
                endif
            endif
        endif
!
! ----- End timer
!
        call nmtime(ds_measure, 'Stop', 'Store')
        call nmrinc(ds_measure, 'Store')
    endif
!
end subroutine
