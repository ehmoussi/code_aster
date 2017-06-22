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

subroutine calapl(char, ligrmo, noma)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alcart.h"
#include "asterfort/codent.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/nocart.h"
#include "asterfort/reliem.h"
#include "asterfort/wkvect.h"
!
    character(len=8) :: char, noma
    character(len=*) :: ligrmo
!
! BUT : STOCKAGE DES CHARGES REPARTIES DANS UNE CARTE ALLOUEE SUR LE
!       LIGREL DU MODELE ( FORCES DE LAPLACE )
!
! ARGUMENTS D'ENTREE:
!      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
!      LIGRMO : NOM DU LIGREL DE MODELE
!      NOMA   : NOM DU MAILLAGE
! ----------------------------------------------------------------------
    integer :: ima, nbflp,   iocc, into, jtran, jno, nbtou, nbma
    integer :: jma, nbma2, jma2, ntra, nsym, jnuma
    character(len=8) :: k8b, typmcl(2), typmc2(2)
    character(len=16) :: motclf, motcle(2), motcl2(2), listma, ltrans
    character(len=19) :: carte
    character(len=24) :: mesmai, mesma2, connex
    character(len=8), pointer :: ncmp(:) => null()
    character(len=16), pointer :: valv(:) => null()
!     ------------------------------------------------------------------
!
    call jemarq()
!
    motclf = 'INTE_ELEC'
    call getfac(motclf, nbflp)
!
    mesmai = '&&CALAPL.MES_MAILLES'
    motcle(1) = 'GROUP_MA'
    motcle(2) = 'MAILLE'
    typmcl(1) = 'GROUP_MA'
    typmcl(2) = 'MAILLE'
!
    mesma2 = '&&CALAPL.MES_MAILLES_2'
    motcl2(1) = 'GROUP_MA_2'
    motcl2(2) = 'MAILLE_2'
    typmc2(1) = 'GROUP_MA'
    typmc2(2) = 'MAILLE'
!
    connex = noma//'.CONNEX'
    call jelira(connex, 'NMAXOC', into)
!
    do 10 iocc = 1, nbflp
!
        carte(1:17) = char//'.CHME.'//'FL1'
        listma(1:14) = char//'.LISMA'
        ltrans(1:14) = char//'.TRANS'
        call codent(iocc, 'D0', carte(18:19))
        call codent(iocc, 'D0', listma(15:16))
        call codent(iocc, 'D0', ltrans(15:16))
!
        call alcart('G', carte, noma, 'LISTMA')
!
        call jeveuo(carte//'.NCMP', 'E', vk8=ncmp)
        call jeveuo(carte//'.VALV', 'E', vk16=valv)
!
!        STOCKAGE DE VALEURS NULLES SUR TOUT LE MAILLAGE
!
        ncmp(1) = 'LISTMA'
        ncmp(2) = 'TRANS'
        valv(1) = ' '
        valv(2) = ' '
        call nocart(carte, 1, 2)
!
        call wkvect(ltrans, 'G V R', 6, jtran)
        zr(jtran) = 0.d0
        zr(jtran+1) = 0.d0
        zr(jtran+2) = 0.d0
        zr(jtran+3) = 0.d0
        zr(jtran+4) = 0.d0
        zr(jtran+5) = 0.d0
!
        ncmp(1) = 'LISTMA'
        ncmp(2) = 'TRANS'
        valv(1) = listma
        valv(2) = ltrans
!
        call getvr8(motclf, 'TRANS', iocc=iocc, nbval=0, nbret=ntra)
        call getvr8(motclf, 'SYME', iocc=iocc, nbval=0, nbret=nsym)
        ntra = -ntra
        nsym = -nsym
        if (ntra .ne. 0) then
            call getvr8(motclf, 'TRANS', iocc=iocc, nbval=ntra, vect=zr(jtran))
        endif
        if (nsym .ne. 0) then
            call getvr8(motclf, 'SYME', iocc=iocc, nbval=nsym, vect=zr(jtran))
        endif
!
! ------ GEOMETRIE DU CONDUCTEUR SECONDAIRE
!
        call reliem(ligrmo, noma, 'NU_MAILLE', motclf, iocc,&
                    2, motcl2, typmc2, mesma2, nbma2)
        if (nbma2 .eq. 0) goto 10
!
! ------ GEOMETRIE DU CONDUCTEUR PRINCIPAL
!
        call getvtx(motclf, 'TOUT', iocc=iocc, scal=k8b, nbret=nbtou)
        if (nbtou .ne. 0) then
            if (nbma2 .eq. 0) then
                call wkvect(listma, 'G V I', 2*into, jnuma)
                do 12 ima = 1, into
                    call jeveuo(jexnum(connex, ima), 'L', jno)
                    zi(jnuma+2*ima-2) = zi(jno)
                    zi(jnuma+2*ima-1) = zi(jno+1)
12              continue
            else
                call jeveuo(mesma2, 'L', jma2)
                call wkvect(listma, 'G V I', 2*nbma2, jnuma)
                do 14 ima = 1, nbma2
                    call jeveuo(jexnum(connex, zi(jma2+ima-1)), 'L', jno)
                    zi(jnuma+2*ima-2) = zi(jno)
                    zi(jnuma+2*ima-1) = zi(jno+1)
14              continue
                call jedetr(mesma2)
            endif
            call nocart(carte, 1, 2)
!
        else
            call reliem(ligrmo, noma, 'NU_MAILLE', motclf, iocc,&
                        2, motcle, typmcl, mesmai, nbma)
            if (nbma .eq. 0) goto 10
            call jeveuo(mesmai, 'L', jma)
            if (nbma2 .eq. 0) then
                call wkvect(listma, 'G V I', 2*nbma, jnuma)
                do 16 ima = 1, nbma
                    call jeveuo(jexnum(connex, zi(jma+ima-1)), 'L', jno)
                    zi(jnuma+2*ima-2) = zi(jno)
                    zi(jnuma+2*ima-1) = zi(jno+1)
16              continue
            else
                call jeveuo(mesma2, 'L', jma2)
                call wkvect(listma, 'G V I', 2*nbma2, jnuma)
                do 18 ima = 1, nbma2
                    call jeveuo(jexnum(connex, zi(jma2+ima-1)), 'L', jno)
                    zi(jnuma+2*ima-2) = zi(jno)
                    zi(jnuma+2*ima-1) = zi(jno+1)
18              continue
                call jedetr(mesma2)
            endif
            call nocart(carte, 3, 2, mode='NUM', nma=nbma,&
                        limanu=zi(jma))
            call jedetr(mesmai)
        endif
!
10  end do
!
    call jedema()
end subroutine
