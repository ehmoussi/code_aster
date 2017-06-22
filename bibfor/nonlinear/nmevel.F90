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

subroutine nmevel(sddisc, nume_inst  , vale  , loop_name, lsvimx,&
                  ldvres, lresmx     , linsta, lerrcv   , lerror,&
                  conver, ds_contact_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/eneven.h"
#include "asterfort/nmevcx.h"
#include "asterfort/nmevdg.h"
#include "asterfort/nmevin.h"
#include "asterfort/utdidt.h"
!
! person_in_charge: mickael.abbas at edf.fr
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
    integer :: nb_echec, i_echec, i_echec_acti
    character(len=16) :: event_name
!
! ----------------------------------------------------------------------
!
    i_echec_acti = 0
!
! --- NOMBRE D'EVENT-DRIVEN : NECHEC
!
    call utdidt('L', sddisc, 'LIST',  'NECHEC',&
                vali_ = nb_echec)
!
! --- DETECTION DU _PREMIER_ EVENEMENT DECLENCHE
! --- DES QU'UN EVENT-DRIVEN EST SATISFAIT, ON SORT
! --- ON NE CHERCHE PAS A VERIFIER LES AUTRES EVENT
!
    do i_echec = 1, nb_echec
!
! ----- RECUPERATION DU NOM DE L'EVENT-DRIVEN
!
        call utdidt('L', sddisc, 'ECHE', 'NOM_EVEN', index_ = i_echec, &
                    valk_ = event_name)
!
! ----- PAR DEFAUT: EVENEMENT NON ACTIVE
!
        call eneven(sddisc, i_echec, .false._1)
!
        if (event_name .eq. 'ERRE') then
            if (lsvimx .or. lerrcv .or. lerror) then
                i_echec_acti = i_echec
                goto 99
            endif
        else if (event_name.eq.'DIVE_RESI') then
            if (ldvres) then
                i_echec_acti = i_echec
                if (i_echec_acti .ne. 0) then
                    goto 99
                endif
            endif
        else if (event_name.eq.'RESI_MAXI') then
            if (lresmx) then
                i_echec_acti = i_echec
                if (i_echec_acti .ne. 0) then
                    goto 99
                endif
            endif
        else if (event_name.eq.'DELTA_GRANDEUR') then
            if (conver) then
                call nmevdg(sddisc, vale, i_echec, i_echec_acti)
                if (i_echec_acti .ne. 0) then
                    goto 99
                endif
            endif
        else if (event_name.eq.'COLLISION') then
            if (loop_name .eq. 'INST') then
                call nmevcx(sddisc, nume_inst, ds_contact_, i_echec, i_echec_acti)
                if (i_echec_acti .ne. 0) then
                    goto 99
                endif
            endif
        else if (event_name.eq.'INTERPENETRATION') then
            if (loop_name .eq. 'INST') then
                call nmevin(sddisc, ds_contact_, i_echec, i_echec_acti)
                if (i_echec_acti .ne. 0) then
                    goto 99
                endif
            endif
        else if (event_name.eq.'INSTABILITE') then
            if (linsta) then
                i_echec_acti = i_echec
            endif
            if (i_echec_acti .ne. 0) then
                goto 99
            endif
        else
            write(6,*) 'NOMEVD: ',event_name
            ASSERT(.false.)
        endif
    end do
!
99  continue
!
! --- DECLENCHEMENT DE L'EVENEMENT
!
    if (i_echec_acti .ne. 0) then
        call eneven(sddisc, i_echec_acti, .true._1)
    endif
!
end subroutine
