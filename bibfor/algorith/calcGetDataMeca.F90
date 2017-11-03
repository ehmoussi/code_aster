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
!
subroutine calcGetDataMeca(list_load      , model         , mate     , cara_elem,&
                           disp_prev      , disp_cumu_inst, vari_prev, sigm_prev,&
                           ds_constitutive, l_elem_nonl, nume_harm)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmlect.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/nonlinDSConstitutiveCreate.h"
#include "asterfort/nmdorc.h"
#include "asterfort/nonlinDSConstitutiveInit.h"
#include "asterfort/dismoi.h"
#include "asterfort/isOptionPossible.h"
#include "asterfort/utmess.h"
!
character(len=19), intent(out) :: list_load
character(len=24), intent(out) :: model
character(len=24), intent(out) :: mate
character(len=24), intent(out) :: cara_elem
character(len=19), intent(out) :: disp_prev
character(len=19), intent(out) :: disp_cumu_inst
character(len=19), intent(out) :: vari_prev
character(len=19), intent(out) :: sigm_prev
type(NL_DS_Constitutive), intent(out) :: ds_constitutive
aster_logical, intent(out) :: l_elem_nonl
integer, intent(out) :: nume_harm
!
! --------------------------------------------------------------------------------------------------
!
! Command CALCUL
!
! Get data for mechanics
!
! --------------------------------------------------------------------------------------------------
!
! Out list_load        : name of datastructure for list of loads
! Out model            : name of model
! Out mate             : name of material characteristics (field)
! Out cara_elem        : name of elementary characteristics (field)
! Out disp_prev        : displacement at beginning of step
! Out disp_cumu_inst   : displacement increment from beginning of step
! Out vari_prev        : internal variables at beginning of step
! Out sigm_prev        : stress at beginning of step
! Out ds_constitutive  : datastructure for constitutive laws management
! Out l_elem_nonl      : .true. if all elements can compute non-linear options
! Out nume_harm        : Fourier harmonic number 
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: result
    aster_logical :: l_etat_init
    integer :: nocc
    character(len=19) :: ligrmo
!
! --------------------------------------------------------------------------------------------------
!
    list_load      = '&&OP0026.LISCHA'
    cara_elem      = '&&OP0026.CARELE'
    model          = ' '
    mate           = ' '
    vari_prev      = ' '
    sigm_prev      = ' '
    disp_prev      = ' '
    disp_cumu_inst = ' '
    l_elem_nonl    = .false._1
!
! - Get parameters from command file
!
    call nmlect(result, model, mate, cara_elem, list_load)
!
! - Can have internal variables ?
!
    call dismoi('NOM_LIGREL', model, 'MODELE', repk=ligrmo)
    call isOptionPossible(ligrmo, 'TOU_INI_ELGA', 'PVARI_R', l_some_ = l_elem_nonl)
! - Does option FULL_MECA exist
    if (l_elem_nonl) then
        call isOptionPossible(ligrmo, 'FULL_MECA', 'PDEPLPR', l_some_ = l_elem_nonl)
    endif
!
! - Get displacements
!
    call getvid(' ', 'DEPL', scal=disp_prev, nbret = nocc)
    if (nocc .eq. 0) then
        disp_prev = ' '
    endif
    call getvid(' ', 'INCR_DEPL', scal=disp_cumu_inst, nbret = nocc)
    if (nocc .eq. 0) then
        disp_cumu_inst = ' '
    endif
!
! - Get stresses
!
    call getvid(' ', 'SIGM', scal=sigm_prev, nbret=nocc)
    l_etat_init = nocc .ne. 0
    if (nocc .eq. 0) then
        sigm_prev = ' '
    endif
!
! - Get internal variables
!
    call getvid(' ', 'VARI', scal=vari_prev, nbret=nocc)
    if (nocc .eq. 0) then
        vari_prev = ' '
    endif
    if (vari_prev .ne. ' ' .and. .not. l_elem_nonl) then
        call utmess('I', 'CALCUL1_7')
    endif
!
! - Get Fourier Mode
!
    call getvis(' ', 'MODE_FOURIER', scal=nume_harm, nbret=nocc)
    if (nocc .eq. 0) nume_harm = 0
!
! - Prepare constitutive laws management datastructure
!
    if (l_elem_nonl) then
        call nonlinDSConstitutiveCreate(ds_constitutive)
        call nmdorc(model, mate, l_etat_init,&
                    ds_constitutive%compor, ds_constitutive%carcri, ds_constitutive%mult_comp,&
                    l_implex_ = .false._1)
        call nonlinDSConstitutiveInit(model, cara_elem, ds_constitutive)
    endif
!
end subroutine
