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

subroutine cocali(lis1z, lis2z, typz)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/juveca.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=*) :: lis1z, lis2z, typz
!
!
!     BUT :  CONCATENATION DES LISTES DE K8 LIS1 ET LIS2
!            ON AFFECTE TOUS LES ELEMENTS DE LA LISTE LIS2
!            A LA LISTE LIS1 APRES LE DERNIER ELEMENT DE LA LISTE
!            LIS1
!            SI LIS1 N'EXISTE PAS , ON LA CREE ET ON LUI AFFECTE
!            LA LONGUEUR ET LES ELEMENTS DE LIS2
!            SI LIS2 N'EXISTE PAS ON SORT EN ERREUR FATALE
!
! IN/OUT  LIS1   K24  : NOM DE LA LISTE A ENRICHIR
! IN      LIS2   K24  : NOM DE LA LISTE QUE L'ON CONCATENE A LA
!                       LISTE LIS1
! IN      TYPE   K1   : TYPE DE LA LISTE, POUR L'INSTANT SONT PREVUES
!                        'I'   LISTE D'ENTIERS
!                        'R'   LISTE DE REELS
!                        'K8'  LISTE DE K8
!
!
!
!
    character(len=2) :: type
    character(len=24) :: lis1, lis2
    character(len=24) :: valk(2)
!
!-----------------------------------------------------------------------
    integer :: i, idlis1, idlis2, iret, lonli1, lonli2
!-----------------------------------------------------------------------
    call jemarq()
    lis1 = lis1z
    lis2 = lis2z
    type = typz
!
    call jeexin(lis2, iret)
    if (iret .eq. 0) then
        valk(1) = lis2
        valk(2) = lis1
        call utmess('F', 'MODELISA4_25', nk=2, valk=valk)
    else
        call jeveuo(lis2, 'L', idlis2)
        call jelira(lis2, 'LONMAX', lonli2)
    endif
!
    call jeexin(lis1, iret)
    if (iret .eq. 0) then
        if (lonli2 .eq. 0) then
            valk(1) = lis2
            valk(2) = lis1
            call utmess('F', 'MODELISA4_26', nk=2, valk=valk)
        else
            if (type .eq. 'K8') then
                call wkvect(lis1, 'V V K8', lonli2, idlis1)
                lonli1 = 0
            else if (type(1:1).eq.'R') then
                call wkvect(lis1, 'V V R', lonli2, idlis1)
                lonli1 = 0
            else if (type(1:1).eq.'I') then
                call wkvect(lis1, 'V V I', lonli2, idlis1)
                lonli1 = 0
            else
                call utmess('F', 'MODELISA4_27', sk=type)
            endif
!
        endif
    else
        call jeveuo(lis1, 'E', idlis1)
        call jelira(lis1, 'LONMAX', lonli1)
        call juveca(lis1, lonli1+lonli2)
        call jeveuo(lis1, 'E', idlis1)
    endif
!
    if (type .eq. 'K8') then
        do 10 i = 1, lonli2
            zk8(idlis1+lonli1+i-1) = zk8(idlis2+i-1)
10      continue
    else if (type(1:1).eq.'R') then
        do 20 i = 1, lonli2
            zr(idlis1+lonli1+i-1) = zr(idlis2+i-1)
20      continue
    else if (type(1:1).eq.'I') then
        do 30 i = 1, lonli2
            zi(idlis1+lonli1+i-1) = zi(idlis2+i-1)
30      continue
    else
        call utmess('F', 'MODELISA4_27', sk=type)
    endif
!
! FIN -----------------------------------------------------------------
    call jedema()
end subroutine
