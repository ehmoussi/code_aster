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

subroutine rsutn2(resu, nomcha, motcle, iocc, objveu,&
                  nbordr)
    implicit none
#include "jeveux.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsutnu.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: iocc, nbordr
    character(len=*) :: resu, nomcha, motcle, objveu
!     RECUPERATION DES NUMEROS D'ORDRE DANS UNE STRUCTURE DE DONNEES
!     DE TYPE "RESULTAT" A PARTIR D'UN NOM SYMBOLIQUE ET DES VARIABLES
!     D'ACCES UTILISATEUR
!     ------------------------------------------------------------------
! IN  : RESU   : NOM DE LA STRUCTURE DE DONNEES
! IN  : NOMCHA : NOM SYMBOLIQUE DU CHAMP
! IN  : MOTCLE : NOM DU MOT CLE FACTEUR
! IN  : IOCC   : NUMERO D'OCCURENCE
! OUT : OBJVEU : NOM JEVEUX DU VECTEUR ZI POUR ECRIRE LA LISTE DES NUME
! OUT : NBORDR : NOMBRE DE NUMERO D'ORDRE VALIDE POUR LE NOMCHA
!     ------------------------------------------------------------------
    integer :: iret, ii, iordr, lordr, jordr, np, nc, nbtord
    real(kind=8) :: prec
    character(len=8) :: k8b, crit
    character(len=16) :: k16b
    character(len=19) :: cham19
    character(len=24) :: knume
!     ------------------------------------------------------------------
    call jemarq()
!
!     --- LECTURE DE LA PRECISION ET DU CRITERE ---
!
    call getvr8(motcle, 'PRECISION', iocc=iocc, scal=prec, nbret=np)
    call getvtx(motcle, 'CRITERE', iocc=iocc, scal=crit, nbret=nc)
!
!     --- RECUPERATION DES NUMEROS D'ORDRE ---
!
    knume = '&&RSUTN2.NUME_ORDR'
    call rsutnu(resu, motcle, iocc, knume, nbtord,&
                prec, crit, iret)
    if (iret .ne. 0) then
        k8b = resu
        call utmess('F', 'UTILITAI4_49', sk=k8b)
    endif
    call jeveuo(knume, 'L', lordr)
!
!     --- VERIFICATION QUE LE NOMCHA EXISTE DANS LA SD RESULTAT ---
!
    ii = 0
    do iordr = 1, nbtord
        call rsexch(' ', resu, nomcha, zi(lordr+iordr-1), cham19,&
                    iret)
        if (iret .eq. 0) ii = ii + 1
    end do
    if (ii .eq. 0) then
        k16b = nomcha
        call utmess('F', 'UTILITAI4_52', sk=k16b)
    endif
!
!     --- LISTE DES NUMEROS D'ORDRE ---
!
    nbordr = 0
    call wkvect(objveu, 'V V I', ii, jordr)
    do iordr = 1, nbtord
        call rsexch(' ', resu, nomcha, zi(lordr+iordr-1), cham19,&
                    iret)
        if (iret .eq. 0) then
            nbordr = nbordr + 1
            zi(jordr+nbordr-1) = zi(lordr+iordr-1)
        endif
    end do
!
    call jedetr('&&RSUTN2.NUME_ORDR')
!
    call jedema()
end subroutine
