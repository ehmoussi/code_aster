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

subroutine nmcrel(sderro, nomevt, vall)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmeceb.h"
    character(len=24) :: sderro
    character(len=9) :: nomevt
    aster_logical :: vall
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (SD ERREUR)
!
! ENREGISTREMENT D'UN EVENEMENT INTRINSEQUE
!
! ----------------------------------------------------------------------
!
! POUR LES EVENEMENTS A CODE RETOUR, IL FAUT D'ABORD TRANSFORMER LE
! CODE RETOUR EN EVENEMENT - UTILISER NMCRET
!
!
! IN  SDERRO : SD GESTION DES ERREURS
! IN  NOMEVT : NOM DE L'EVENEMENT (VOIR LA LISTE DANS NMCRER)
! IN  VALL   : .TRUE. SI ON ACTIVE
!
! ----------------------------------------------------------------------
!
    integer :: ieven, zeven
    character(len=24) :: erreno, erreni, erraac
    integer :: jeenom, jeeniv, jeeact
    character(len=24) :: errinf
    integer :: jeinfo
    character(len=16) :: neven, teven
    character(len=4) :: nombcl
    integer :: ievact
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    ievact = 0
!
! --- ACCES SD
!
    errinf = sderro(1:19)//'.INFO'
    call jeveuo(errinf, 'L', jeinfo)
    zeven = zi(jeinfo-1+1)
!
    erreno = sderro(1:19)//'.ENOM'
    erreni = sderro(1:19)//'.ENIV'
    erraac = sderro(1:19)//'.EACT'
    call jeveuo(erreno, 'L', jeenom)
    call jeveuo(erreni, 'L', jeeniv)
    call jeveuo(erraac, 'E', jeeact)
!
! --- RECHERCHE DE L'EVENEMENT
!
    do 15 ieven = 1, zeven
!
! ----- NOM DE L'EVENEMENT
!
        neven = zk16(jeenom-1+ieven)
!
! ----- TYPE DE L'EVENEMENT
!
        teven = zk16(jeeniv-1+ieven)
!
! ----- ACTIVATION DE L'EVENEMENT
!
        if (neven .eq. nomevt) then
            ievact = ieven
            goto 66
        endif
 15 end do
!
 66 continue
!
    ASSERT(ievact.ne.0)
!
! --- (DES-)ACTIVATION DE L'EVENEMENT
!
    if (vall) then
        zi(jeeact-1+ievact) = 1
    else
        zi(jeeact-1+ievact) = 0
    endif
!
! --- EVENEMENT DE TYPE ERREUR ACTIVE: ON CHANGE LE STATUT DE LA BOUCLE
!
    if (vall) then
        teven = zk16(jeeniv-1+ievact)
        if (teven(1:5) .eq. 'ERRI_') then
            nombcl = teven(6:9)
            call nmeceb(sderro, nombcl, 'ERRE')
!
! ------- UNE ERREUR DE NIVEAU CALC EST FATALE POUR TOUT LE MONDE
!
            if (nombcl .eq. 'CALC') then
                call nmeceb(sderro, 'NEWT', 'STOP')
                call nmeceb(sderro, 'FIXE', 'STOP')
                call nmeceb(sderro, 'INST', 'STOP')
            endif
        endif
    endif
!
!
    call jedema()
end subroutine
