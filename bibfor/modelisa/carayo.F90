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

subroutine carayo(char, ligrmo, noma, fonree)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alcart.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
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
! BUT : STOCKAGE DE SIGMA (CONSTANTE DE BOLZMAN), EPSILON (EMISSIVITE)
!       ET TMP_INF DANS UNE CARTE ALLOUEE SUR LE LIGREL DU MODELE
!
! ARGUMENTS D'ENTREE:
!      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
!      LIGRMO : NOM DU LIGREL DE MODELE
!      NOMA   : NOM DU MAILLAGE
!      FONREE : FONC OU REEL
!-----------------------------------------------------------------------
    integer :: nrayo, jvalv,  ncmp, n, iocc, nbtou, nbma, jma
    character(len=8) :: k8b, typmcl(2)
    character(len=16) :: motclf, motcle(2)
    character(len=19) :: carte
    character(len=24) :: mesmai
    character(len=8), pointer :: vncmp(:) => null()
!     ------------------------------------------------------------------
    call jemarq()
!
    motclf = 'RAYONNEMENT'
    call getfac(motclf, nrayo)
!
    carte = char//'.CHTH.RAYO'
!
    if (fonree .eq. 'REEL') then
        call alcart('G', carte, noma, 'RAYO_R')
    else if (fonree.eq.'FONC') then
        call alcart('G', carte, noma, 'RAYO_F')
    else
        call utmess('F', 'MODELISA2_37', sk=fonree)
    endif
!
    call jeveuo(carte//'.NCMP', 'E', vk8=vncmp)
    call jeveuo(carte//'.VALV', 'E', jvalv)
!
! --- STOCKAGE DE FLUX NULS SUR TOUT LE MAILLAGE
!
    ncmp = 3
    vncmp(1) = 'SIGMA'
    vncmp(2) = 'EPSIL'
    vncmp(3) = 'TPINF'
    if (fonree .eq. 'REEL') then
        zr(jvalv-1+1) = 0.d0
        zr(jvalv-1+2) = 0.d0
        zr(jvalv-1+3) = 0.d0
    else
        zk8(jvalv-1+1) = '&FOZERO'
        zk8(jvalv-1+2) = '&FOZERO'
        zk8(jvalv-1+3) = '&FOZERO'
    endif
    call nocart(carte, 1, ncmp)
!
    mesmai = '&&CARAYO.MES_MAILLES'
    motcle(1) = 'GROUP_MA'
    motcle(2) = 'MAILLE'
    typmcl(1) = 'GROUP_MA'
    typmcl(2) = 'MAILLE'
!
! --- STOCKAGE DANS LA CARTE
!
    do 10 iocc = 1, nrayo
        if (fonree .eq. 'REEL') then
            call getvr8(motclf, 'SIGMA', iocc=iocc, scal=zr(jvalv), nbret=n)
            call getvr8(motclf, 'EPSILON', iocc=iocc, scal=zr(jvalv+1), nbret=n)
            call getvr8(motclf, 'TEMP_EXT', iocc=iocc, scal=zr(jvalv+2), nbret=n)
        else
            call getvid(motclf, 'SIGMA', iocc=iocc, scal=zk8(jvalv), nbret=n)
            call getvid(motclf, 'EPSILON', iocc=iocc, scal=zk8(jvalv+1), nbret=n)
            call getvid(motclf, 'TEMP_EXT', iocc=iocc, scal=zk8(jvalv+2), nbret=n)
        endif
!
        call getvtx(motclf, 'TOUT', iocc=iocc, scal=k8b, nbret=nbtou)
        if (nbtou .ne. 0) then
            call nocart(carte, 1, ncmp)
!
        else
            call reliem(ligrmo, noma, 'NU_MAILLE', motclf, iocc,&
                        2, motcle, typmcl, mesmai, nbma)
            if (nbma .eq. 0) goto 10
            call jeveuo(mesmai, 'L', jma)
            call nocart(carte, 3, ncmp, mode='NUM', nma=nbma,&
                        limanu=zi(jma))
            call jedetr(mesmai)
        endif
!
10  end do
!
    call jedema()
!
end subroutine
