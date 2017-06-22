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

subroutine cafotu(char, ligrmo, ialloc, noma, fonree)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alcart.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/nocart.h"
#include "asterfort/reliem.h"
#include "asterfort/utmess.h"
!
!
    integer :: ialloc
    character(len=4) :: fonree
    character(len=8) :: char, noma
    character(len=*) :: ligrmo
!
! BUT : STOCKAGE DE FORCE_TUYAU(PRES) DANS UNE CARTE ALLOUEE SUR LE
!       LIGREL DU MODELE
!
! ARGUMENTS D'ENTREE:
!      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
!      LIGRMO : NOM DU LIGREL DE MODELE
!      IALLOC : 1 SI LA CARTE DE PRESSION ALLOUE PAR CAPRES, 0 SINON
!      NOMA   : NOM DU MAILLAGE
!      FONREE : FONC OU REEL
!
!-----------------------------------------------------------------------
    integer :: npres,  jvalv, ncmp, iocc, npr, iatyma, nbma, i, ima
    integer :: iadtyp, jma, nmatot, nbtou
    character(len=8) :: k8b, maille, type, typmcl(2)
    character(len=16) :: motclf, motcle(2)
    character(len=19) :: carte
    character(len=24) :: mesmai, valk(4)
    character(len=8), pointer :: vncmp(:) => null()
!-----------------------------------------------------------------------
!
    call jemarq()
!
    motclf = 'FORCE_TUYAU'
    call getfac(motclf, npres)
!
    carte = char//'.CHME.PRESS'
    if (ialloc .eq. 0) then
        if (fonree .eq. 'REEL') then
            call alcart('G', carte, noma, 'PRES_R')
        else if (fonree.eq.'FONC') then
            call alcart('G', carte, noma, 'PRES_F')
        else
            ASSERT(.false.)
        endif
    endif
!
    call jeveuo(noma//'.TYPMAIL', 'L', iatyma)
    call dismoi('NB_MA_MAILLA', noma, 'MAILLAGE', repi=nmatot)
!
    call jeveuo(carte//'.NCMP', 'E', vk8=vncmp)
    call jeveuo(carte//'.VALV', 'E', jvalv)
!
! --- STOCKAGE DE PRESSIONS NULLES SUR TOUT LE MAILLAGE
!
    ncmp = 1
    vncmp(1) = 'PRES'
    if (ialloc .eq. 0) then
        if (fonree .eq. 'REEL') then
            zr(jvalv) = 0.d0
        else
            zk8(jvalv) = '&FOZERO'
        endif
        call nocart(carte, 1, ncmp)
    endif
!
    mesmai = '&&CAFOTU.MES_MAILLES'
    motcle(1) = 'GROUP_MA'
    motcle(2) = 'MAILLE'
    typmcl(1) = 'GROUP_MA'
    typmcl(2) = 'MAILLE'
!
! --- STOCKAGE DANS LA CARTE
!
    do iocc = 1, npres
!
        if (fonree .eq. 'REEL') then
            call getvr8(motclf, 'PRES', iocc=iocc, scal=zr(jvalv), nbret=npr)
        else
            call getvid(motclf, 'PRES', iocc=iocc, scal=zk8(jvalv), nbret=npr)
        endif
!
        call getvtx(motclf, 'TOUT', iocc=iocc, scal=k8b, nbret=nbtou)
!
        if (nbtou .ne. 0) then
            do ima = 1, nmatot
                iadtyp = iatyma-1+ima
                call jenuno(jexnum('&CATA.TM.NOMTM', zi(iadtyp)), type)
                if ((type(1:4).ne.'SEG3') .and. (type(1:4).ne.'SEG4')) then
                    call jenuno(jexnum(noma//'.NOMMAI', ima), maille)
                    valk(1) = maille
                    valk(2) = motclf
                    call utmess('A', 'MODELISA9_81', nk=2, valk=valk)
                endif
            enddo
            call nocart(carte, 1, ncmp)
!
        else
            call reliem(ligrmo, noma, 'NU_MAILLE', motclf, iocc,&
                        2, motcle, typmcl, mesmai, nbma)
            if (nbma .ne. 0) then
                call jeveuo(mesmai, 'L', jma)
                do i = 1, nbma
                    ima = zi(jma-1+i)
                    iadtyp = iatyma-1+ima
                    call jenuno(jexnum('&CATA.TM.NOMTM', zi(iadtyp)), type)
                    if ((type(1:4).ne.'SEG3') .and. (type(1:4).ne.'SEG4')) then
                        call jenuno(jexnum(noma//'.NOMMAI', ima), maille)
                        valk(1) = maille
                        valk(2) = motclf
                        call utmess('A', 'MODELISA9_81', nk=2, valk=valk)
                    endif
                enddo
                call nocart(carte, 3, ncmp, mode='NUM', nma=nbma,&
                            limanu=zi(jma))
                call jedetr(mesmai)
            endif
        endif
!
    end do
!
    call jedetr(char//'.PRES.GROUP')
    call jedetr(char//'.PRES.LISTE')
!-----------------------------------------------------------------------
    call jedema()
end subroutine
