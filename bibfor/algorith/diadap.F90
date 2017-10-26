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
!
function diadap(sddisc, i_adap)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utdidt.h"
#include "asterfort/getAdapEvent.h"
!
aster_logical :: diadap
character(len=19), intent(in) :: sddisc
integer, intent(in) :: i_adap
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE)
!
! ACCES AU DECLENCHEUR DE L'ADAPTATION DU PAS DE TEMPS
!
! --------------------------------------------------------------------------------------------------
!
! In  sddisc           : datastructure for time discretization
! IN  I_ADAPT : NUMERO DE LA METHODE D ADAPTATION TRAITEE
! OUT DIADAP : .TRUE. SI ON DOIT ADAPTER LE PAS DE TEMPS
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbinse, nbok, event_type
!
! --------------------------------------------------------------------------------------------------
!
    diadap = .false.
!
! - Get event type
!
    call getAdapEvent(sddisc, i_adap, event_type)
!
    if (event_type .eq. ADAP_EVT_NONE) then
        diadap = .false.
    else if (event_type .eq. ADAP_EVT_ALLSTEPS) then
        diadap = .true.
    else if (event_type .eq. ADAP_EVT_TRIGGER) then
!
! ----- RECUP DU SEUIL SUR LE NB DE SUCCES CONSECUTIFS
!
        call utdidt('L', sddisc, 'ADAP', 'NB_INCR_SEUIL', index_= i_adap,&
                    vali_ = nbinse)
!
! ----- RECUP DU NB DE SUCCES CONSECUTIFS
!
        call utdidt('L', sddisc, 'ADAP', 'NB_EVEN_OK', index_= i_adap,&
                    vali_ = nbok)
        if (nbok .lt. nbinse) then
            diadap = .false.
        else
!         ICI NBOK EST NORMALEMENT EGAL A NBINSE
!         MAIS NBOK PEUT ETRE AUSSI SUPERIEUR A NBINSE SI ON UTILISE
!         LA METHODE CONTINUE
            diadap = .true.
!         REMISE A ZERO DE NBOK
            nbok = 0
            call utdidt('E', sddisc, 'ADAP', 'NB_EVEN_OK', index_= i_adap,&
                        vali_ = nbok)
        endif
    else
        ASSERT(.false.)
    endif
!
end function
