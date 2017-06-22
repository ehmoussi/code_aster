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

subroutine cglecc(typfis, resu, vecord, calsig)
    implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
!
    character(len=8) :: typfis, resu, calsig
    character(len=19) :: vecord
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : LECTURE DE LA CARTE DE COMPORTEMENT UTILISEE DANS LE CALCUL
!
!  IN :
!     TYPFIS : TYPE D'OBJET POUR DECRIRE LE FOND DE FISSURE
!              'FONDFISS' OU 'FISSURE' OU 'THETA'
!     RESU   : MOT-CLE RESULTAT
!     VECORD : VECTEUR DES NUME_ORDRE DU RESU
!  OUT :
!     CALSIG : 'OUI' S'IL FAUT RECALCULER LES CONTRAITNES
!              'NON' S'IL NE FAUT PAS RECALCULER LES CONTRAINTES
! ======================================================================
!
    integer :: ncelas, ier, i, jvec, nbord, iord, vali
    character(len=24) :: k24b
!
    call jemarq()
!
!     RECUPERATION DU MOT-CLE CALCUL_CONTRAINTE
!
!     PAR DEFAUT, ON RECALCULE LES CONTRAINTES
    calsig='OUI'
!
    call getfac('COMPORTEMENT', ncelas)
!
    if (ncelas .gt. 0) then
        call getvtx(' ', 'CALCUL_CONTRAINTE', scal=calsig, nbret=ier)
    endif
!
!     CALSIG='NON' N'EST PAS COMPATIBLE AVEC X-FEM
    if (calsig .eq. 'NON') then
        if (typfis .eq. 'FISSURE') then
            call utmess('F', 'RUPTURE1_39')
        endif
    endif
!
!     LES AUTRES VERIF SONF FAITES DANS LE CAPY (OPTION...)
!
!     VERIFICATION DE LA PRESENCE DU CHAMP SIEF_ELGA
!     LORSQUE CALCUL_CONTRAINTE='NON', SINON ERREUR 'F'
    if (calsig .eq. 'NON') then
!
        call jeveuo(vecord, 'L', jvec)
        call jelira(vecord, 'LONMAX', nbord)
!
        do 10 i = 1, nbord
            iord = zi(jvec-1+i)
            call rsexch(' ', resu, 'SIEF_ELGA', iord, k24b,&
                        ier)
            if (ier .ne. 0) then
!           PROBLEME DANS LA RECUP DE SIEF_ELGA POUR CE NUME_ORDRE
                vali=iord
                call utmess('F', 'RUPTURE0_93', si=vali)
            endif
10      continue
    endif
!
    call jedema()
!
end subroutine
