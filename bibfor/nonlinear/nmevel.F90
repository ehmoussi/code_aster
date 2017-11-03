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
subroutine nmevel(sddisc, nume_inst  , vale  , loop_name, lsvimx,&
                  ldvres, lresmx     , linsta, lerrcv   , lerror,&
                  conver, ds_contact_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/assert.h"
#include "asterfort/eneven.h"
#include "asterfort/nmevcx.h"
#include "asterfort/nmevdg.h"
#include "asterfort/nmevin.h"
#include "asterfort/utdidt.h"
#include "asterfort/getFailEvent.h"
!
character(len=19), intent(in) :: vale(*)
character(len=19), intent(in) :: sddisc
character(len=4), intent(in) :: loop_name
integer, intent(in) :: nume_inst
aster_logical, intent(in) :: lsvimx
aster_logical, intent(in) :: ldvres
aster_logical, intent(in) :: lresmx
aster_logical, intent(in) :: linsta
aster_logical, intent(in) :: lerrcv
aster_logical, intent(in) :: lerror
aster_logical, intent(in) :: conver
type(NL_DS_Contact), optional, intent(in) :: ds_contact_
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! DETECTION DU PREMIER EVENEMENT DECLENCHE
!
! ----------------------------------------------------------------------
!
! NB: DES QU'UN EVENT-DRIVEN EST SATISFAIT, ON SORT
! ON NE CHERCHE PAS A VERIFIER LES AUTRES EVENEMENTS
!
! In  sddisc           : datastructure for time discretization TEMPORELLE
! In  ds_contact       : datastructure for contact management
! IN  NUMINS : NUMERO D'INSTANT
! IN  VALE   : INCREMENTS DES VARIABLES
!               OP0070: VARIABLE CHAPEAU
!               OP0033: TABLE
! IN  NOMBCL : NOM DE LA BOUCLE
!               'RESI' - RESIDUS D'EQUILIBRE
!               'NEWT' - BOUCLE DE NEWTON
!               'FIXE' - BOUCLE DE POINT FIXE
!               'INST' - BOUCLE SUR LES PAS DE TEMPS
! IN  LSVIMX : .TRUE. SI ITERATIONS MAX ATTEINT DANS SOLVEUR ITERATIF
! IN  LDVRES : .TRUE. SI DIVERGENCE DU RESIDU
! IN  LRESMX : .TRUE. SI DIVERGENCE DU RESIDU (TROP GRAND)
! IN  LINSTA : .TRUE. SI INSTABILITE DETECTEE
! IN  LERRCV : .TRUE. SI ERREUR A CONVERGENCE DECLENCHEE
! IN  LERROR : .TRUE. SI ERREUR DECLENCHEE
! IN  CONVER : .TRUE. SI BOUCLE COURANTE A CONVERGE
!
! ----------------------------------------------------------------------
!
    integer :: nb_fail, i_fail, i_fail_acti
    integer :: event_type
!
! ----------------------------------------------------------------------
!
    i_fail_acti = 0
!
! --- NOMBRE D'EVENT-DRIVEN : NECHEC
!
    call utdidt('L', sddisc, 'LIST',  'NECHEC', vali_ = nb_fail)
!
! --- DETECTION DU _PREMIER_ EVENEMENT DECLENCHE
! --- DES QU'UN EVENT-DRIVEN EST SATISFAIT, ON SORT
! --- ON NE CHERCHE PAS A VERIFIER LES AUTRES EVENT
!
    do i_fail = 1, nb_fail
! ----- Get event type
        call getFailEvent(sddisc, i_fail, event_type)
!
! ----- PAR DEFAUT: EVENEMENT NON ACTIVE
!
        call eneven(sddisc, i_fail, .false._1)
!
        if (event_type .eq. FAIL_EVT_ERROR) then
            if (lsvimx .or. lerrcv .or. lerror) then
                i_fail_acti = i_fail
                goto 99
            endif
        else if (event_type .eq. FAIL_EVT_DIVE_RESI) then
            if (ldvres) then
                i_fail_acti = i_fail
                if (i_fail_acti .ne. 0) then
                    goto 99
                endif
            endif
        else if (event_type .eq. FAIL_EVT_RESI_MAXI) then
            if (lresmx) then
                i_fail_acti = i_fail
                if (i_fail_acti .ne. 0) then
                    goto 99
                endif
            endif
        else if (event_type .eq. FAIL_EVT_INCR_QUANT) then
            if (conver) then
                call nmevdg(sddisc, vale, i_fail, i_fail_acti)
                if (i_fail_acti .ne. 0) then
                    goto 99
                endif
            endif
        else if (event_type .eq. FAIL_EVT_COLLISION) then
            if (loop_name .eq. 'INST') then
                call nmevcx(sddisc, nume_inst, ds_contact_, i_fail, i_fail_acti)
                if (i_fail_acti .ne. 0) then
                    goto 99
                endif
            endif
        else if (event_type .eq. FAIL_EVT_INTERPENE) then
            if (loop_name .eq. 'INST') then
                call nmevin(sddisc, ds_contact_, i_fail, i_fail_acti)
                if (i_fail_acti .ne. 0) then
                    goto 99
                endif
            endif
        else if (event_type .eq. FAIL_EVT_INSTABILITY) then
            if (linsta) then
                i_fail_acti = i_fail
            endif
            if (i_fail_acti .ne. 0) then
                goto 99
            endif
        else
            ASSERT(.false.)
        endif
    end do
!
99  continue
!
! --- DECLENCHEMENT DE L'EVENEMENT
!
    if (i_fail_acti .ne. 0) then
        call eneven(sddisc, i_fail_acti, .true._1)
    endif
!
end subroutine
