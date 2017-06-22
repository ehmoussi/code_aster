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

subroutine lrvemo(modele)
    implicit none
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    character(len=8) :: modele
!
!   BUT:ROUTINE DE LIRE RESU / LIRE_CHAMP QUI VERIFIE LA COHERENCE ENTRE
!       LE MODELE FOURNI ET LES DONNEES DU FICHIER MED
!
!   ENTREE: MODELE(K8)  = NOM DU MODELE
!-----------------------------------------------------------------------
! person_in_charge: nicolas.sellenet at edf.fr
!
    integer :: n1
!
    character(len=8) :: chanom, typech
    character(len=16) :: typres, pheno, valk(2), nomcmd
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
    call getres(chanom, typech, nomcmd)
!
!     ON VERIFIE QUE LE PHENOMENE DU MODELE FOURNI EST COHERENT AVEC
!     LA SD RESULTAT A PRODUIRE
!     =========================
    if (nomcmd(1:9) .eq. 'LIRE_RESU') then
        call getvtx(' ', 'TYPE_RESU', scal=typres, nbret=n1)
        call dismoi('PHENOMENE', modele, 'MODELE', repk=pheno)
        if (typres(1:9) .eq. 'EVOL_THER') then
            if (pheno(1:9) .eq. 'MECANIQUE') then
                valk(1)=pheno
                valk(2)=typres
                call utmess('F+', 'MED_54')
                call utmess('F', 'MED_56', nk=2, valk=valk)
            endif
        endif
    endif
!
    call jedema()
!
end subroutine
