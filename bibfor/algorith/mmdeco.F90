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

subroutine mmdeco(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONSTINUE - POST-TRAITEMENT)
!
! GESTION DE LA DECOUPE
!
! ----------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
    character(len=24) :: tabfin, etatct
    integer :: jtabf, jetat
    integer :: zetat, ztabf
    integer :: ntpc, ipc
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    etatct = ds_contact%sdcont_solv(1:14)//'.ETATCT'
    tabfin = ds_contact%sdcont_solv(1:14)//'.TABFIN'
    call jeveuo(tabfin, 'L', jtabf)
    call jeveuo(etatct, 'E', jetat)
    ztabf = cfmmvd('ZTABF')
    zetat = cfmmvd('ZETAT')
!
! --- INITIALISATION
!
    ntpc = cfdisi(ds_contact%sdcont_defi,'NTPC')
!
! --- SAUVEGARDE DE L ETAT DE CONTACT EN CAS DE REDECOUPAGE
!
    do ipc = 1, ntpc
!       STATUT DE CONTACT
        zr(jetat-1+zetat*(ipc-1)+1) = zr(jtabf+ztabf*(ipc-1)+22)
!       SEUIL DE FROTTEMENT
        zr(jetat-1+zetat*(ipc-1)+2) = zr(jtabf+ztabf*(ipc-1)+16)
!       MEMOIRE DE GLISSIERE
        zr(jetat-1+zetat*(ipc-1)+3) = zr(jtabf+ztabf*(ipc-1)+17)
    end do
!
    call jedema()
!
end subroutine
