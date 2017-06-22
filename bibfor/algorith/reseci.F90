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

subroutine reseci(carele, nummai, ai1, ai2)
!**********************************************************************C
!***1.****RECUPERATION DU TYPGRANDEUR, DU NOMBRE MAX DE GRANDEUR
!         DU NOMBRE DE GRANDEUR EFFECTIF
!
!
!***2.****POUR CHAQUE GRANDEUR  ON RECUPER LE CODE
!         SI 1: TOUTES LES MAILLES ONT LA MEME GRANDEUR
!         SI 3: ON A UN GROUPMA TARDIF DECRIT DANS LE LIMA : ON
!               REUPERE SON NUMERO, ON VA VOIR SI NUMMAI Y EST
!               SI NON ON PASSE A LA GRANDEUR SUIVANTE
!               SI OUI ON RECUPER SON ENTIER CODE, ON VERI......
!**********************************************************************C
    implicit none
!
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/veri32.h"
    character(len=8) :: carele, k8bid1
    character(len=24) :: k24bi1
!
!
!**********************************************************************C
!***1.      RECUPERATION DU TYPE GRANDEUR NB ASSOCIATION***************C
!**********************************************************************C
!-----------------------------------------------------------------------
    integer :: iad1, ialima, iass1, iavale, ibid1, icmp, icode1
    integer :: iec1, igd, igdncm, imai1, inasmx, inbmai, inecgd
    integer :: inulim, irgai1, irgai2, itest1, itest2, numai1, numgd
    integer :: nummai
    real(kind=8) :: ai1, ai2
!-----------------------------------------------------------------------
    call jemarq()
    k24bi1 = carele//'.CARGENPO  .DESC'
    call jeveuo(k24bi1, 'L', iad1)
    igd = zi(iad1)
    inecgd = 2
    inasmx = zi(iad1+1)
!**********************************************************************C
!***        BOUCLE SUR LES ASSOCIATIONS *******************************C
!**********************************************************************C
    do 101 iass1 = 1, inasmx
        icode1 = zi(iad1-1+3+2* (iass1-1)+1)
        if (icode1 .eq. 1) then
            inulim = 1
            iec1 = zi(iad1-1+3+2* (inasmx)+inecgd* (iass1-1)+1)
!
        else if (icode1.eq.3) then
            inulim = zi(iad1-1+3+2* (iass1-1)+2)
            iec1 = zi(iad1-1+3+2* (inasmx)+inecgd* (iass1-1)+1)
!
        else
        endif
!   ON REGARDE SI LA MAILLE EST DANS LE .LIMA
        call jeveuo(jexnum(k24bi1(1:19)//'.LIMA', inulim), 'L', ialima)
        call jelira(jexnum(k24bi1(1:19)//'.LIMA', inulim), 'LONMAX', inbmai)
        do 103 imai1 = 1, inbmai
            numai1 = zi(ialima-1+imai1)
            if (nummai .eq. numai1) then
                goto 104
!
            endif
!
103      continue
101  end do
104  continue
!**********************************************************************C
!***        ON RECHERCHE LE NOMBRE DE CMP DE LA GRANDEUR **************C
!**********************************************************************C
    call jelira(jexnum('&CATA.GD.NOMCMP', igd), 'LONMAX', igdncm)
!**********************************************************************C
!***        ON RECHERCHE LES NUMERO DE AI1 ET AI2 DANS LA GD***********C
!**********************************************************************C
    call jenonu(jexnom('&CATA.GD.NOMGD', 'CAGNPO'), numgd)
    call jeveuo(jexnum('&CATA.GD.NOMCMP', numgd), 'L', iad1)
    do 105 icmp = 1, igdncm
        k8bid1 = zk8(iad1-1+icmp)
        if (k8bid1(1:3) .eq. 'AI1') then
            irgai1 = icmp
!
        else if (k8bid1(1:3).eq.'AI2') then
            irgai2 = icmp
        endif
!
105  end do
!**********************************************************************C
!***        ON RECUPERE LES VALEURS ***********************************C
!**********************************************************************C
    k24bi1 = carele//'.CARGENPO  .VALE'
    call jeveuo(k24bi1, 'L', iavale)
    if (irgai1 .gt. 30) call veri32()
    if (irgai2 .gt. 30) call veri32()
    itest1 = mod((iec1-mod(iec1,2**irgai1))/2**irgai1,2)
    itest2 = mod((iec1-mod(iec1,2**irgai2))/2**irgai2,2)
    if ((itest1*itest2) .ne. 1) then
!
    else
        ibid1 = (iass1-1)*igdncm + irgai1
        ai1 = zr(iavale-1+ibid1)
        ibid1 = (iass1-1)*igdncm + irgai2
        ai2 = zr(iavale-1+ibid1)
    endif
!
    call jedema()
end subroutine
