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

subroutine capres(char, ligrmo, noma, ndim, fonree)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alcart.h"
#include "asterfort/assert.h"
#include "asterfort/char_affe_neum.h"
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
#include "asterfort/vetyma.h"
#include "asterfort/xtmafi.h"
#include "asterfort/xvelfm.h"
    integer :: ndim
    character(len=4) :: fonree
    character(len=8) :: char, noma
    character(len=*) :: ligrmo
!
! BUT : STOCKAGE DES PRESSIONS DANS UNE CARTE ALLOUEE SUR LE
!       LIGREL DU MODELE (Y COMPRIS THM)
!
! ARGUMENTS D'ENTREE:
!      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
!      LIGRMO : NOM DU LIGREL DE MODELE
!      NOMA   : NOM DU MAILLAGE
!      NDIM   : DIMENSION DU PROBLEME (2D OU 3D)
!      FONREE : FONC OU REEL
!-----------------------------------------------------------------------
    integer :: ibid, npres, ncmp, jvalv,  iocc, np, nc, nbtou, nbma
    integer :: jma, nfiss, nfismx
    parameter    (nfismx=100)
    character(len=8) :: k8b, fiss(nfismx)
    character(len=16) :: motclf
    character(len=19) :: carte
    character(len=24) :: mesmai, lismai
    character(len=19) :: cartes(1)
    integer :: ncmps(1)
    character(len=8), pointer :: vncmp(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
!
    motclf = 'PRES_REP'
    call getfac(motclf, npres)
!
    carte = char//'.CHME.PRESS'
!
    if (fonree .eq. 'REEL') then
        call alcart('G', carte, noma, 'PRES_R')
    else if (fonree.eq.'FONC') then
        call alcart('G', carte, noma, 'PRES_F')
    else
        ASSERT(.false.)
    endif
!
    call jeveuo(carte//'.NCMP', 'E', vk8=vncmp)
    call jeveuo(carte//'.VALV', 'E', jvalv)
!
! --- STOCKAGE DE FORCES NULLES SUR TOUT LE MAILLAGE
!
    ncmp = 2
    vncmp(1) = 'PRES'
    vncmp(2) = 'CISA'
!
    if (fonree .eq. 'REEL') then
        zr(jvalv) = 0.d0
        zr(jvalv+1) = 0.d0
    else
        zk8(jvalv) = '&FOZERO'
        zk8(jvalv+1) = '&FOZERO'
    endif
    call nocart(carte, 1, ncmp)
!
    mesmai = '&&CAPRES.MES_MAILLES'
    lismai = '&&CAPRES.NUM_MAILLES'
!
! --- STOCKAGE DANS LA CARTE
!
    do iocc = 1, npres
!
        if (fonree .eq. 'REEL') then
            call getvr8(motclf, 'PRES', iocc=iocc, scal=zr(jvalv), nbret=np)
            call getvr8(motclf, 'CISA_2D', iocc=iocc, scal=zr(jvalv+1), nbret=nc)
        else
            call getvid(motclf, 'PRES', iocc=iocc, scal=zk8(jvalv), nbret=np)
            call getvid(motclf, 'CISA_2D', iocc=iocc, scal=zk8(jvalv+1), nbret=nc)
        endif
        if (nc .ne. 0 .and. ndim .eq. 3) then
            call utmess('F', 'MODELISA9_94')
        endif
!
        call getvtx(motclf, 'TOUT', iocc=iocc, scal=k8b, nbret=nbtou)
        call getvid(motclf, 'FISSURE', iocc=iocc, nbval=0, nbret=nfiss)
!
        if (nfiss .ne. 0) then
!
            nfiss = -nfiss
            call getvid(motclf, 'FISSURE', iocc=iocc, nbval=nfiss, vect=fiss,&
                        nbret=ibid)
!           VERIFICATION DE LA COHERENCE ENTRE LES FISSURES ET LE MODELE
            call xvelfm(nfiss, fiss, ligrmo(1:8))
!           RECUPERATION DES MAILLES PRINCIPALES X-FEM FISSUREES
            call xtmafi(ndim, fiss, nfiss, lismai,&
                        mesmai, nbma, model=ligrmo(1:8))
            call jeveuo(mesmai, 'L', jma)
            call nocart(carte, 3, ncmp, mode='NOM', nma=nbma,&
                        limano=zk8(jma))
            call jedetr(mesmai)
            call jedetr(lismai)
!
        else
!
            cartes(1) = carte
            ncmps(1) = ncmp
            call char_affe_neum(noma, ndim, motclf, iocc, 1,&
                                cartes, ncmps)
        endif
!
    end do
!
!-----------------------------------------------------------------------
    call jedema()
end subroutine
