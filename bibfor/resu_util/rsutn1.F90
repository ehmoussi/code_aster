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

subroutine rsutn1(resu, nopara, motcle, iocc, objveu,&
                  nbordr)
    implicit none
#include "jeveux.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsnopa.h"
#include "asterfort/rsutnu.h"
#include "asterfort/rsutrg.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: iocc, nbordr
    character(len=16) :: nopara
    character(len=*) :: resu, motcle, objveu
!     RECUPERATION DES NUMEROS D'ORDRE DANS UNE STRUCTURE DE DONNEES
!     DE TYPE "RESULTAT" A PARTIR D'UN NOM SYMBOLIQUE ET DES VARIABLES
!     D'ACCES UTILISATEUR
!     ------------------------------------------------------------------
! IN  : RESU   : NOM DE LA STRUCTURE DE DONNEES
! IN  : NOPARA : NOM SYMBOLIQUE DU CHAMP
! IN  : MOTCLE : NOM DU MOT CLE FACTEUR
! IN  : IOCC   : NUMERO D'OCCURENCE
! OUT : OBJVEU : NOM JEVEUX DU VECTEUR ZI POUR ECRIRE LA LISTE DES NUME
! OUT : NBORDR : NOMBRE DE NUMERO D'ORDRE VALIDE POUR LE NOPARA
!     ------------------------------------------------------------------
    integer :: iret, ii, iordr, lordr, jordr, np, nc, irang, nbacc, nbpar
    integer :: nbtord
    real(kind=8) :: prec
    character(len=8) :: k8b, crit
    character(len=24) :: knume
    character(len=24) :: valk(2)
    integer :: nrang
    character(len=16), pointer :: acces(:) => null()
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
    knume = '&&RSUTN1.NUME_ORDR'
    call rsutnu(resu, motcle, iocc, knume, nbtord,&
                prec, crit, iret)
    if (iret .ne. 0) then
        k8b = resu
        call utmess('F', 'UTILITAI4_49', sk=k8b)
    endif
    call jeveuo(knume, 'L', lordr)
!
!     --- VERIFICATION QUE LE NOPARA EXISTE DANS LA SD RESULTAT ---
!
    call rsnopa(resu, 1, '&&RSUTN1.PARA.ACCES', nbacc, nbpar)
    call jeexin('&&RSUTN1.PARA.ACCES', iret)
    if (iret .gt. 0) then
        call jeveuo('&&RSUTN1.PARA.ACCES', 'L', vk16=acces)
        do iordr = 1, nbpar
            if (nopara .eq. acces(iordr)) goto 12
        end do
        k8b = resu
        valk (1) = nopara
        valk (2) = k8b
        call utmess('F', 'UTILITAI6_84', nk=2, valk=valk)
12      continue
    else
        call utmess('F', 'UTILITAI4_50')
    endif
    call jedetr('&&RSUTN1.PARA.ACCES')
!
    ii = 0
    do iordr = 1, nbtord
        call rsutrg(resu, zi(lordr+iordr-1), irang, nrang)
        if (irang .ne. 0) then
            ii = ii + 1
        endif
    end do
    if (ii .eq. 0) then
        call utmess('F', 'UTILITAI4_51', sk=nopara)
    endif
!
!     --- LISTE DES NUMEROS D'ORDRE ---
!
    nbordr = 0
    call wkvect(objveu, 'V V I', ii, jordr)
    do iordr = 1, nbtord
        call rsutrg(resu, zi(lordr+iordr-1), irang, nrang)
        if (irang .ne. 0) then
            nbordr = nbordr + 1
            zi(jordr+nbordr-1) = zi(lordr+iordr-1)
        endif
    end do
!
    call jedetr('&&RSUTN1.NUME_ORDR')
!
    call jedema()
end subroutine
