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

subroutine nmnoli(sddisc, sderro, ds_constitutive, ds_print , sdcrit  ,&
                  fonact, sddyna, sdpost         , modele   , mate    ,&
                  carele, sdpilo, ds_measure     , ds_energy, ds_inout,&
                  sdcriq)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmarch.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsrusd.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19) :: sddisc, sdcrit, sddyna, sdpost, sdpilo
    type(NL_DS_Constitutive), intent(in) :: ds_constitutive
    type(NL_DS_Energy), intent(in) :: ds_energy
    character(len=24) :: sderro
    character(len=24) :: modele, mate, carele
    character(len=24) :: sdcriq
    type(NL_DS_Measure), intent(inout) :: ds_measure
    type(NL_DS_InOut), intent(inout) :: ds_inout
    integer :: fonact(*)
    type(NL_DS_Print), intent(in) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Init
!
! Prepare storing
!
! --------------------------------------------------------------------------------------------------
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  FONACT : FONCTIONNALITES ACTIVEES
! In  ds_print         : datastructure for printing parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_STAB ET MODE_VIBR)
! IN  SDDYNA : SD DYNAMIQUE
! IO  ds_inout         : datastructure for input/output management
! IN  SDCRIT : INFORMATIONS RELATIVES A LA CONVERGENCE
! IN  SDPILO : SD PILOTAGE
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDERRO : SD ERREUR
! In  ds_energy        : datastructure for energy management
! IN  SDCRIQ : SD CRITERE QUALITE
! IN  MODELE : NOM DU MODELE
! IN  MATE   : CHAMP DE MATERIAU
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: sdarch
    character(len=24) :: sdarch_ainf
    integer, pointer :: v_sdarch_ainf(:) => null()
    integer :: numarc, numins
    integer :: ifm, niv
    aster_logical :: lreuse
    character(len=8) :: result
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> PREPARATION DE LA SD EVOL_NOLI'
    endif
!
! --- FONCTIONNALITES ACTIVEES
!
    lreuse = isfonc(fonact,'REUSE')
!
! --- INSTANT INITIAL
!
    numins = 0
!
! - Get name of result's datastructure
!
    result = ds_inout%result
!
! --- ACCES SD ARCHIVAGE
!
    sdarch      = sddisc(1:14)//'.ARCH'
    sdarch_ainf = sdarch(1:19)//'.AINF'
!
! - Current storing index
!
    call jeveuo(sdarch_ainf, 'L', vi = v_sdarch_ainf)
    numarc = v_sdarch_ainf(1)
!
! --- CREATION DE LA SD EVOL_NOLI OU NETTOYAGE DES ANCIENS NUMEROS
!
    if (lreuse) then
        ASSERT(numarc.ne.0)
        call rsrusd(result, numarc)
    else
        ASSERT(numarc.eq.0)
        call rscrsd('G', result, 'EVOL_NOLI', 100)
    endif
!
! --- ARCHIVAGE ETAT INITIAL
!
    if (.not.lreuse) then
        call utmess('I', 'ARCHIVAGE_4')
        call nmarch(numins         , modele  , mate  , carele, fonact   ,&
                    ds_constitutive, ds_print, sddisc, sdpost, sdcrit   ,&
                    ds_measure     , sderro  , sddyna, sdpilo, ds_energy,&
                    ds_inout       , sdcriq  )
    endif
!
end subroutine
