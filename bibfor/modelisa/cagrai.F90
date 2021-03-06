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

subroutine cagrai(char, ligrmo, noma, fonree)
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
! BUT : STOCKAGE DES CHARGES DES GRADIENTS INITIAUX DE TEMPERAT REPARTIS
!       DANS UNE CARTE ALLOUEE SUR LE LIGREL DU MODELE
!
! ARGUMENTS D'ENTREE:
!      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
!      LIGRMO : NOM DU LIGREL DE MODELE
!      NOMA   : NOM DU MAILLAGE
!      FONREE : FONC OU REEL
!-----------------------------------------------------------------------
    integer :: nchgi, jvalv,  nx, ny, nz, i, iocc, nbtou, nbma, jma
    real(kind=8) :: grx, gry, grz
    character(len=8) :: k8b, typmcl(2), grxf, gryf, grzf
    character(len=16) :: motclf, motcle(2)
    character(len=19) :: carte
    character(len=24) :: mesmai
    character(len=8), pointer :: ncmp(:) => null()
!     ------------------------------------------------------------------
    call jemarq()
!
    motclf = 'PRE_GRAD_TEMP'
    call getfac(motclf, nchgi)
!
    carte = char//'.CHTH.'//'GRAIN'
!
    if (fonree .eq. 'REEL') then
        call alcart('G', carte, noma, 'FLUX_R')
    else if (fonree.eq.'FONC') then
        call alcart('G', carte, noma, 'FLUX_F')
    else
        call utmess('F', 'MODELISA2_37', sk=fonree)
    endif
!
    call jeveuo(carte//'.NCMP', 'E', vk8=ncmp)
    call jeveuo(carte//'.VALV', 'E', jvalv)
!
    ncmp(1) = 'FLUX'
    ncmp(2) = 'FLUY'
    ncmp(3) = 'FLUZ'
    if (fonree .eq. 'REEL') then
        do 10 i = 1, 3
            zr(jvalv-1+i) = 0.d0
10      continue
    else if (fonree.eq.'FONC') then
        do 12 i = 1, 3
            zk8(jvalv-1+i) = '&FOZERO'
12      continue
    endif
    call nocart(carte, 1, 3)
!
    mesmai = '&&CAGRAI.MES_MAILLES'
    motcle(1) = 'GROUP_MA'
    motcle(2) = 'MAILLE'
    typmcl(1) = 'GROUP_MA'
    typmcl(2) = 'MAILLE'
!
    do 20 iocc = 1, nchgi
!
        if (fonree .eq. 'REEL') then
            call getvr8(motclf, 'FLUX_X', iocc=iocc, scal=grx, nbret=nx)
            call getvr8(motclf, 'FLUX_Y', iocc=iocc, scal=gry, nbret=ny)
            call getvr8(motclf, 'FLUX_Z', iocc=iocc, scal=grz, nbret=nz)
            do 22 i = 1, 3
                zr(jvalv-1+i) = 0.d0
22          continue
            if (nx .ne. 0) zr(jvalv-1+1) = grx
            if (ny .ne. 0) zr(jvalv-1+2) = gry
            if (nz .ne. 0) zr(jvalv-1+3) = grz
        else if (fonree.eq.'FONC') then
            call getvid(motclf, 'FLUX_X', iocc=iocc, scal=grxf, nbret=nx)
            call getvid(motclf, 'FLUX_Y', iocc=iocc, scal=gryf, nbret=ny)
            call getvid(motclf, 'FLUX_Z', iocc=iocc, scal=grzf, nbret=nz)
            do 24 i = 1, 3
                zk8(jvalv-1+i) = '&FOZERO'
24          continue
            if (nx .ne. 0) zk8(jvalv-1+1) = grxf
            if (ny .ne. 0) zk8(jvalv-1+2) = gryf
            if (nz .ne. 0) zk8(jvalv-1+3) = grzf
        endif
!
        call getvtx(motclf, 'TOUT', iocc=iocc, scal=k8b, nbret=nbtou)
        if (nbtou .ne. 0) then
            call nocart(carte, 1, 3)
!
        else
            call reliem(ligrmo, noma, 'NU_MAILLE', motclf, iocc,&
                        2, motcle, typmcl, mesmai, nbma)
            if (nbma .eq. 0) goto 20
            call jeveuo(mesmai, 'L', jma)
            call nocart(carte, 3, 3, mode='NUM', nma=nbma,&
                        limanu=zi(jma))
            call jedetr(mesmai)
        endif
!
20  end do
!
    call jedema()
end subroutine
