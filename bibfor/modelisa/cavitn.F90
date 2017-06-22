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

subroutine cavitn(char, ligrmo, noma, fonree)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alcart.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/reliem.h"
#include "asterfort/utmess.h"
    character(len=4) :: fonree
    character(len=8) :: char, noma
    character(len=*) :: ligrmo
!
! BUT : STOCKAGE DE LA VITESSE NORMALE DANS UNE CARTE ALLOUEE SUR LE
!       LIGREL DU MODELE
!
! ARGUMENTS D'ENTREE:
!      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
!      LIGRMO : NOM DU LIGREL DE MODELE
!      NOMA   : NOM DU MAILLAGE
!      FONREE : FONC OU REEL
! ----------------------------------------------------------------------
    integer :: iocc, n, nvnor, jvalv,  nbma, jma
    character(len=8) ::  typmcl(2)
    character(len=16) :: motclf, motcle(2)
    character(len=19) :: carte
    character(len=24) :: mesmai
    character(len=8), pointer :: ncmp(:) => null()
!     ------------------------------------------------------------------
!
    call jemarq()
!
    motclf = 'VITE_FACE'
    call getfac(motclf, nvnor)
!
    carte =char//'.CHME.VNOR'
!
    if (fonree .eq. 'REEL') then
        call alcart('G', carte, noma, 'SOUR_R')
    else if (fonree.eq.'FONC') then
        call alcart('G', carte, noma, 'SOUR_F')
    else
        call utmess('F', 'MODELISA2_37', sk=fonree)
    endif
!
    call jeveuo(carte//'.NCMP', 'E', vk8=ncmp)
    call jeveuo(carte//'.VALV', 'E', jvalv)
!
! --- STOCKAGE DES VITESSES NORMALES NULLES SUR TOUT LE MAILLAGE
!
    ncmp(1) = 'VNOR'
    if (fonree .eq. 'REEL') then
        zr(jvalv) = 0.d0
    else
        zk8(jvalv) = '&FOZERO'
    endif
    call nocart(carte, 1, 1)
!
    mesmai = '&&CAVITN.MES_MAILLES'
    motcle(1) = 'GROUP_MA'
    motcle(2) = 'MAILLE'
    typmcl(1) = 'GROUP_MA'
    typmcl(2) = 'MAILLE'
!
! --- STOCKAGE DANS LA CARTE
!
    do 10 iocc = 1, nvnor
!
        if (fonree .eq. 'REEL') then
            call getvr8(motclf, 'VNOR', iocc=iocc, scal=zr(jvalv), nbret=n)
        else
            call getvid(motclf, 'VNOR', iocc=iocc, scal=zk8(jvalv), nbret=n)
        endif
!
        call reliem(ligrmo, noma, 'NU_MAILLE', motclf, iocc,&
                    2, motcle, typmcl, mesmai, nbma)
        if (nbma .eq. 0) goto 10
        call jeveuo(mesmai, 'L', jma)
        call nocart(carte, 3, 1, mode='NUM', nma=nbma,&
                    limanu=zi(jma))
        call jedetr(mesmai)
!
10  end do
!
    call jedema()
end subroutine
