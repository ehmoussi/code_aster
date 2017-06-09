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

subroutine rscopi(base, sd1, sd2)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/copich.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedupo.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
#include "asterfort/rsnopa.h"
    character(len=*) :: base, sd1, sd2
! person_in_charge: jacques.pellet at edf.fr
!
!   BUT:
!   DUPLIQUER UNE STRUCTURE DE DONNEES "RESULTAT".
!             EN DUPLIQUANT TOUS LES CHAMPS CONTENU DANS LE .TACH
!
!     IN:
!     BASE     : 'G' , 'V' , ... : BASE DE CREATION DE SD2
!     SD1 (K*) : NOM DE LA SD A DUPPLIQUER
!     SD2 (K*) : NOM DE LA SD A CREER
!
!     OUT:
!     SD2 EST CREEE ET A LE MEME CONTENU QUE SD1
!
!-----------------------------------------------------------------------
!
    integer :: i, j, nbcham, nbordr, iret, nbac, nbpara, nbpa, jpa, ipara
    integer :: iatava
    aster_logical :: dejfai
    character(len=1) :: bas2
    character(len=4) :: type, typacc
    character(len=5) :: nomobj
    character(len=16) :: nopara, nomsy
    character(len=19) :: sdr1, sdr2, ch1, ch2
    character(len=24) :: nompar
    integer, pointer :: ordr(:) => null()
!
! DEB-------------------------------------------------------------------
!
    call jemarq()
    bas2 = base
!
    sdr1 = sd1
    sdr2 = sd2
    call jelira(sdr1//'.DESC', 'NOMMAX', nbcham)
    call jelira(sdr1//'.ORDR', 'LONUTI', nbordr)
    call jeveuo(sdr1//'.ORDR', 'L', vi=ordr)
!
!     --- LE .DESC, .NOVA, .TAVA, .ORDR ---
!
    call jedupo(sdr1//'.DESC', bas2, sdr2//'.DESC', .false._1)
    call jedupo(sdr1//'.NOVA', bas2, sdr2//'.NOVA', .false._1)
    call jedupo(sdr1//'.TAVA', bas2, sdr2//'.TAVA', .false._1)
    call jedupo(sdr1//'.ORDR', bas2, sdr2//'.ORDR', .false._1)
    call jedupo(sdr1//'.REFD', bas2, sdr2//'.REFD', .false._1)
    call jedupo(sdr1//'.INDI', bas2, sdr2//'.INDI', .false._1)
!
!
!     --- LE .TACH ---
!
    call jecrec(sdr2//'.TACH', 'G V K24', 'NU', 'CONTIG', 'CONSTANT',&
                nbcham)
    call jeecra(sdr2//'.TACH', 'LONMAX', nbordr)
!
!     --- ON DUPLIQUE LES CHAMPS ---
!
    do 20 i = 1, nbcham
        call jenuno(jexnum(sdr1//'.DESC', i), nomsy)
        call jecroc(jexnum(sdr2//'.TACH', i))
        do 10 j = 0, nbordr - 1
            call rsexch(' ', sd1, nomsy, ordr(1+j), ch1,&
                        iret)
            if (iret .eq. 0) then
                call rsexch(' ', sd2, nomsy, ordr(1+j), ch2,&
                            iret)
                call copich(bas2, ch1, ch2)
                call rsnoch(sd2, nomsy, ordr(1+j))
            endif
 10     continue
 20 continue
!
!     --- LES VARIABLES ET PARAMETRES D'ACCES ---
!
    nompar = '&&RSCOPI.NOMS_PARA '
    call rsnopa(sdr1, 2, nompar, nbac, nbpa)
    nbpara = nbac + nbpa
    call jeveuo(nompar, 'L', jpa)
!
    dejfai = .false.
    do 30 j = 1, nbpara
        nopara = zk16(jpa+j-1)
        call jenonu(jexnom(sdr1//'.NOVA', nopara), ipara)
        call jeveuo(jexnum(sdr1//'.TAVA', ipara), 'L', iatava)
        nomobj = zk8(iatava-1+1) (1:5)
        typacc = zk8(iatava-1+4) (1:4)
!
        call jelira(sdr1//nomobj, 'TYPE', cval=type(1:1))
!
        if (typacc .eq. 'PARA' .and. type(1:1) .eq. 'R') then
            if (dejfai) goto 30
            dejfai = .true.
            nomobj = '.PARA'
        endif
        call jedupo(sdr1//nomobj, bas2, sdr2//nomobj, .false._1)
!
 30 continue
    call jedetr(nompar)
!
    call jedema()
end subroutine
