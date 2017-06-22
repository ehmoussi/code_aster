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

subroutine nmevcx(sddisc, nume_inst, ds_contact, i_echec, i_echec_acti)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisl.h"
#include "asterfort/nmevcc.h"
#include "asterfort/nmevco.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sddisc
    integer, intent(in) :: nume_inst
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer, intent(in) :: i_echec
    integer, intent(out) :: i_echec_acti
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - EVENEMENTS)
!
! DETECTION DE L'EVENEMENT COLLISION
!
! ----------------------------------------------------------------------
!
! In  sddisc           : datastructure for time discretization TEMPORELLE
! In  ds_contact       : datastructure for contact management
! IN  NUMINS : NUMERO D'INSTANT
! IN  IECHEC : OCCURRENCE DE L'ECHEC
! OUT IEVDAC : VAUT IECHEC SI EVENEMENT DECLENCHE
!                   0 SINON
!
! ----------------------------------------------------------------------
!
    aster_logical :: l_cont_cont, l_cont_disc
!
! ----------------------------------------------------------------------
!
    l_cont_cont  = cfdisl(ds_contact%sdcont_defi,'FORMUL_CONTINUE')
    l_cont_disc  = cfdisl(ds_contact%sdcont_defi,'FORMUL_DISCRETE')
    i_echec_acti = 0
!
    if (l_cont_disc) then
        call nmevco(sddisc, nume_inst, ds_contact, i_echec, i_echec_acti)
    else if (l_cont_cont) then
        call nmevcc(sddisc, nume_inst, ds_contact, i_echec, i_echec_acti)
    else
        ASSERT(.false.)
    endif
!
end subroutine
