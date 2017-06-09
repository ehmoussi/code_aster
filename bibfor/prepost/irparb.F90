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

subroutine irparb(resu, nbin, parin, nomjv, nbout)
    implicit none
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexpa.h"
#include "asterfort/rsnopa.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=*) :: resu, parin(*), nomjv
    integer :: nbin, nbout
!     DETERMINATION / VERIFICATION DES PARAMETRES
!     ------------------------------------------------------------------
! IN  RESU   : K8  : NOM DU CONCEPT
! IN  NBIN   : I   : NOMBRE DE PARAMETRES EN ENTREE
! IN  PARIN  : K16 : LISTE DES PARAMETRES EN ENTREE
! IN  NOMJV  : K16 : NOM DE L'OBJET JEVEUX DE STOCKAGE DES
!                       NOMS DE PARAMETRES
! OUT NBOUT  : I   : NOMBRE DE PARAMETRES EN SORTIE
!     ------------------------------------------------------------------
    character(len=24) :: valk(2)
!     ------------------------------------------------------------------
    integer :: nbac, nbpa
    character(len=8) :: resu8
    character(len=16) :: cbid, nomcmd
!
!-----------------------------------------------------------------------
    integer :: i, iret, lpout
!-----------------------------------------------------------------------
    call jemarq()
    resu8 = resu
!
    if (nbin .eq. 0) then
        nbout = 0
        lpout = 1
    else if (nbin .lt. 0) then
        call rsnopa(resu8, 2, nomjv, nbac, nbpa)
        call jeexin(nomjv, iret)
        if (iret .gt. 0) call jeveuo(nomjv, 'E', lpout)
        nbout = nbac + nbpa
    else
!
!       --- VERIFICATION DE L'EXISTANCE DU PARAMETRE
        nbout = 0
        call jeexin(nomjv, iret)
        if (iret .ne. 0) call jedetr(nomjv)
        call wkvect(nomjv, 'V V K16', nbin, lpout)
        do 225 i = 1, nbin
            call rsexpa(resu8, 2, parin(i), iret)
            if (iret .eq. 0) then
                call getres(cbid, cbid, nomcmd)
                valk (1) = parin(i)
                valk (2) = ' '
                call utmess('A', 'PREPOST5_41', nk=2, valk=valk)
            else
                nbout = nbout + 1
                zk16(lpout+nbout-1) = parin(i)
            endif
225      continue
    endif
!
!
    call jedema()
end subroutine
