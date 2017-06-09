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

subroutine nmdome(modele, mate, carele, lischa, result,&
                  nuord)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getres.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmdoch.h"
#include "asterfort/rcmfmc.h"
#include "asterfort/rslesd.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: nuord
    character(len=8) :: result
    character(len=19) :: lischa
    character(len=24) :: modele, mate, carele
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE
!
! SAISIE ET VERIFICATION DE LA COHERENCE DES DONNEES MECANIQUES
!
! ----------------------------------------------------------------------
!
!
! VAR MODELE  : NOM DU MODELE
! OUT MATE    : NOM DU CHAMP DE MATERIAU CODE
! OUT CARELE  : CARACTERISTIQUES DES POUTRES ET COQUES
! I/O LISCHA  : SD L_CHARGES
! IN  RESULT  : NOM DE LA SD RESULTAT
! IN  NUORD   : NUMERO D'ORDRE
!
! ----------------------------------------------------------------------
!
    integer :: iexcit, n1
    character(len=8) :: k8bid, k8bla
    character(len=8) :: cara, nomo, materi, repons
    character(len=16) :: nomcmd, typesd
    character(len=19) :: excit
    aster_logical :: l_load_user
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call getres(k8bid, typesd, nomcmd)
!
! --- INITIALISATIONS
!
    iexcit = 1
    excit = ' '
    k8bla = ' '
    l_load_user = .true.
!
! --- LECTURES
!
    if (nomcmd .eq. 'LIRE_RESU' .or. nomcmd .eq. 'CREA_RESU') goto 500
!
    if ((nomcmd.eq.'CALC_CHAMP') .or. (nomcmd.eq.'POST_ELEM')) then
!
! ------ RECUPERATION DU MODELE, MATERIAU, CARA_ELEM et EXCIT
!        POUR LE NUMERO D'ORDRE NUORDR
!
        call rslesd(result, nuord, modele(1:8), materi, carele(1:8),&
                    excit, iexcit)
        l_load_user = iexcit.eq.1
!
        if (materi .ne. k8bla) then
            call rcmfmc(materi, mate)
        else
            mate = ' '
        endif
        cara = carele(1:8)
    else
!
! ------ LE MODELE
!
        if (modele .eq. ' ') then
            call getvid(' ', 'MODELE', scal=nomo, nbret=n1)
            if (n1 .eq. 0) then
                call utmess('F', 'CALCULEL3_50')
            endif
            modele = nomo
        endif
!
! ------ LE MATERIAU
!
        materi = ' '
        call getvid(' ', 'CHAM_MATER', scal=materi, nbret=n1)
        call dismoi('BESOIN_MATER', modele, 'MODELE', repk=repons)
        if ((n1.eq.0) .and. (repons(1:3).eq.'OUI')) then
            call utmess('A', 'CALCULEL3_40')
        endif
        if (n1 .ne. 0) then
            call rcmfmc(materi, mate)
        else
            mate = ' '
        endif
!
! ------ LES CARACTERISTIQUES ELEMENTAIRES
!
        cara = ' '
!
        call getvid(' ', 'CARA_ELEM', scal=cara, nbret=n1)
        call dismoi('EXI_RDM', modele, 'MODELE', repk=repons)
        if ((n1.eq.0) .and. (repons(1:3).eq.'OUI')) then
            call utmess('A', 'CALCULEL3_39')
        endif
!
        carele = cara
    endif
!
500 continue
!
! --- TRAITEMENT DES CHARGES
!
    call nmdoch(lischa, l_load_user, excit)
!
    call jedema()
end subroutine
