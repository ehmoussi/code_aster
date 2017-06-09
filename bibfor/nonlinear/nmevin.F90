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

subroutine nmevin(sddisc, ds_contact, i_echec, i_echec_acti)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/cfdisd.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utdidt.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sddisc
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer, intent(in) :: i_echec
    integer, intent(out) :: i_echec_acti
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - EVENEMENTS)
!
! GESTION DE L'EVENEMENT INTERPENETRATION
!
! ----------------------------------------------------------------------
!
! In  sddisc           : datastructure for time discretization TEMPORELLE
! In  ds_contact       : datastructure for contact management
! IN  IECHEC : OCCURRENCE DE L'ECHEC
! OUT IEVDAC : VAUT IECHEC SI EVENEMENT DECLENCHE
!                   0 SINON
!
! ----------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbliai
    integer :: iliai
    character(len=24) :: jeuite
    integer :: jjeuit
    real(kind=8) :: jeufin, pnmaxi
    aster_logical :: levent
    real(kind=8) :: pene_maxi
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... INTERPENETRATION'
    endif
!
! --- INITIALISATIONS
!
    call utdidt('L', sddisc, 'ECHE', 'PENE_MAXI', index_ = i_echec,&
                valr_ = pene_maxi)
    i_echec_acti = 0
    levent = .false.
    pnmaxi = 0.d0
!
! - Get parameters of contact
!
    nbliai = cfdisd(ds_contact%sdcont_solv,'NBLIAI')
!
! - Access to contact datastructures
!
    jeuite = ds_contact%sdcont_solv(1:14)//'.JEUITE'
    call jeveuo(jeuite, 'L', jjeuit)
!
! --- DETECTION PENETRATION
!
    do iliai = 1, nbliai
        jeufin = zr(jjeuit+3*(iliai-1)+1-1)
        if (jeufin .le. 0.d0) then
            if (abs(jeufin) .gt. pene_maxi) then
                if (abs(jeufin) .gt. pnmaxi) then
                    pnmaxi = abs(jeufin)
                endif
                levent = .true.
            endif
        endif
    end do
!
! --- ACTIVATION EVENEMENT
!
    if (levent) then
        i_echec_acti = i_echec
    endif
!
    call jedema()
end subroutine
