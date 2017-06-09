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

subroutine mmeven(phase, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=3), intent(in) :: phase
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - EVENT-DRIVEN)
!
! DETECTION D'UNE COLLISION
!
! ----------------------------------------------------------------------
!
!
! IN  PHASE  : PHASE DE DETECTION
!              'INI' - AU DEBUT DU PAS DE TEMPS
!              'FIN' - A LA FIN DU PAS DE TEMPS
! In  ds_contact       : datastructure for contact management
!
!
!
!
    integer :: ifm, niv
    integer :: ntpc, iptc
    character(len=24) :: ctevco, tabfin
    integer :: jctevc, jtabf
    integer :: zeven, ztabf
    aster_logical :: lactif
    real(kind=8) :: etacin, etacfi
    aster_logical :: lexiv
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> ...... GESTION DES JEUX POUR EVENT-DRIVEN'
    endif
!
! --- PARAMETRES
!
    ntpc = cfdisi(ds_contact%sdcont_defi,'NTPC')
!
! --- UNE ZONE EN MODE SANS CALCUL: ON NE PEUT RIEN FAIRE
!
    lexiv = cfdisl(ds_contact%sdcont_defi,'EXIS_VERIF')
    if (lexiv) goto 999
!
! --- ACCES OBJETS DU CONTACT
!
    tabfin = ds_contact%sdcont_solv(1:14)//'.TABFIN'
    ctevco = ds_contact%sdcont_solv(1:14)//'.EVENCO'
    call jeveuo(tabfin, 'L', jtabf)
    call jeveuo(ctevco, 'E', jctevc)
    ztabf = cfmmvd('ZTABF')
    zeven = cfmmvd('ZEVEN')
!
! --- DETECTION
!
    do iptc = 1, ntpc
        etacin = zr(jctevc+zeven*(iptc-1)+1-1)
        etacfi = zr(jctevc+zeven*(iptc-1)+2-1)
        lactif = .false.
!
! ----- LA LIAISON EST-ELLE ACTIVE ?
!
        if (zr(jtabf+ztabf*(iptc-1)+22) .gt. 0.d0) lactif = .true.
!
! ----- CHANGEMENT STATUT
!
        if (lactif) then
            if (phase .eq. 'INI') then
                etacin = 1.d0
            else if (phase.eq.'FIN') then
                etacfi = 1.d0
            else
                ASSERT(.false.)
            endif
        else
            if (phase .eq. 'INI') then
                etacin = 0.d0
            else if (phase.eq.'FIN') then
                etacfi = 0.d0
            else
                ASSERT(.false.)
            endif
        endif
        zr(jctevc+zeven*(iptc-1)+1-1) = etacin
        zr(jctevc+zeven*(iptc-1)+2-1) = etacfi
    end do
!
999 continue
!
    call jedema()
end subroutine
