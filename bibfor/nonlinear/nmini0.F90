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
subroutine nmini0(list_func_acti, eta      , nume_inst      , matass     , zmeelm    ,&
                  zmeass        , zveelm   , zveass         , zsolal     , zvalin    ,&
                  ds_print      , ds_conv  , ds_algopara    , ds_inout   , ds_contact,&
                  ds_measure    , ds_energy, ds_constitutive, ds_material)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/nmchai.h"
#include "asterfort/infdbg.h"
#include "asterfort/nonlinDSConvergenceCreate.h"
#include "asterfort/nonlinDSPrintCreate.h"
#include "asterfort/nonlinDSAlgoParaCreate.h"
#include "asterfort/nonlinDSInOutCreate.h"
#include "asterfort/nonlinDSContactCreate.h"
#include "asterfort/nonlinDSMeasureCreate.h"
#include "asterfort/nonlinDSEnergyCreate.h"
#include "asterfort/nonlinDSConstitutiveCreate.h"
#include "asterfort/nonlinDSMaterialCreate.h"
!
integer, intent(out) :: list_func_acti(*)
character(len=19), intent(out) :: matass
integer, intent(out) :: nume_inst
real(kind=8), intent(out) :: eta
integer, intent(in) :: zmeelm, zmeass, zveelm
integer, intent(in) :: zveass, zsolal, zvalin
type(NL_DS_Print), intent(out) :: ds_print
type(NL_DS_Conv), intent(out) :: ds_conv
type(NL_DS_AlgoPara), intent(out) :: ds_algopara
type(NL_DS_InOut), intent(out) :: ds_inout
type(NL_DS_Contact), intent(out) :: ds_contact
type(NL_DS_Measure), intent(out) :: ds_measure
type(NL_DS_Energy), intent(out) :: ds_energy
type(NL_DS_Constitutive), intent(out) :: ds_constitutive
type(NL_DS_Material), intent(out) :: ds_material
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Initializations
!
! Creation of datastructures
!
! --------------------------------------------------------------------------------------------------
!
! Out list_func_acti   : list of active functionnalities
! Out nume_inst        : index of current time step
! Out ds_print         : datastructure for printing parameters
! Out ds_conv          : datastructure for convergence management
! Out ds_algopara      : datastructure for algorithm parameters
! Out ds_inout         : datastructure for input/output management
! Out ds_contact       : datastructure for contact management
! Out ds_measure       : datastructure for measure and statistics management
! Out ds_energy        : datastructure for energy management
! Out ds_constitutive  : datastructure for constitutive laws management
! Out ds_material      : datastructure for material parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    real(kind=8), parameter :: zero = 0.d0
    integer :: long
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> Create datastructures'
    endif
!
! - Create printing management datastructure
!
    call nonlinDSPrintCreate(ds_print)
!
! - Create convergence management datastructure
!
    call nonlinDSConvergenceCreate(ds_conv)
!
! - Create algorithm parameters datastructure
!
    call nonlinDSAlgoParaCreate(ds_algopara)
!
! - Create input/output management datastructure
!
    call nonlinDSInOutCreate('MECA', ds_inout)
!
! - Create contact management datastructure
!
    call nonlinDSContactCreate(ds_contact)
!
! - Create measure and statistics management datastructure
!
    call nonlinDSMeasureCreate(ds_measure)
!
! - Create energy management datastructure
!
    call nonlinDSEnergyCreate(ds_energy)
!
! - Create constitutive laws management datastructure
!
    call nonlinDSConstitutiveCreate(ds_constitutive)
!
! - Create material management datastructure
!
    call nonlinDSMaterialCreate(ds_material)
!
! --- FONCTIONNALITES ACTIVEES               (NMFONC/ISFONC)
!
    list_func_acti(1:100) = 0
!
! --- INITIALISATION BOUCLE EN TEMPS
!
    nume_inst = 0
    eta    = zero
    matass = '&&OP0070.MATASS'
!
! --- VERIF. LONGUEURS VARIABLES CHAPEAUX (SYNCHRO OP0070/NMCHAI)
!
    call nmchai('MEELEM', 'LONMAX', long)
    ASSERT(long.eq.zmeelm)
    call nmchai('MEASSE', 'LONMAX', long)
    ASSERT(long.eq.zmeass)
    call nmchai('VEELEM', 'LONMAX', long)
    ASSERT(long.eq.zveelm)
    call nmchai('VEASSE', 'LONMAX', long)
    ASSERT(long.eq.zveass)
    call nmchai('SOLALG', 'LONMAX', long)
    ASSERT(long.eq.zsolal)
    call nmchai('VALINC', 'LONMAX', long)
    ASSERT(long.eq.zvalin)
!
end subroutine
