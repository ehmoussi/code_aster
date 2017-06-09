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

subroutine cescrm(basez, cesz, typcez, nomgdz, ncmpg,&
                  licmp, cesmz)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cescre.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
    integer :: ncmpg
    character(len=*) :: cesz, basez, typcez, nomgdz, cesmz
    character(len=*) :: licmp(*)
! ----------------------------------------------------------------------
! BUT : CREER UN CHAM_ELEM_S VIERGE (CESZ) EN PRENANT CESM COMME MODELE
!       PROCHE DE CESCRE : ON CREE UN CHAMP AYANT LA MEME TOPOLOGIE
!       (MEME MAILLAGE, MEME NBRE DE POINTS ET SOUS-POINTS PAR MAILLE).
! ----------------------------------------------------------------------
!     ARGUMENTS:
! BASEZ   IN       K1  : BASE DE CREATION POUR CESZ : G/V/L
! CESZ    IN/JXOUT K19 : SD CHAM_ELEM_S A CREER
! TYPCEZ  IN       K4  : TYPE DU CHAM_ELEM_S :
!                        / 'ELNO'
!                        / 'ELGA'
!                        / 'ELEM'
! NOMGDZ  IN       K8  : NOM DE LA GRANDEUR DE CESZ
! NCMPG   IN       I   : DIMENSION DE LICMP
! LICMP   IN       L_K8: NOMS DES CMPS VOULUES DANS CESZ
! CESMZ   IN       K19 : NOM DU CHAMP SIMPLE QUI SERT DE MODELE
!
!     ------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    integer :: i, ima, nbma
    integer :: j1, j2,   jcmps
    character(len=1) :: base
    character(len=4) :: cnum
    character(len=4) :: typces
    character(len=8) :: nomgd
    character(len=19) :: ces, cesm, wk1, wk2, cmps
    character(len=8), pointer :: cesk(:) => null()
    integer, pointer :: cesd(:) => null()
!     ------------------------------------------------------------------
!
    call jemarq()
    base = basez
    ces = cesz
    typces = typcez
    nomgd = nomgdz
    cesm = cesmz
    wk1 = '&&CESCRM.WK1'
    wk2 = '&&CESCRM.WK2'
    cmps = '&&CESCRM.LICMP'
!
    call jeveuo(cesm//'.CESD', 'L', vi=cesd)
    call jeveuo(cesm//'.CESK', 'L', vk8=cesk)
!
! --- RECUPERE LA TOPOLOGIE DU CHAM_ELEM_S MODELE
    nbma = cesd(1)
    call wkvect(wk1, 'V V I', nbma, j1)
    call wkvect(wk2, 'V V I', nbma, j2)
    do 10 ima = 1, nbma
        zi(j1-1+ima) = cesd(5+4*(ima-1)+1)
        zi(j2-1+ima) = cesd(5+4*(ima-1)+2)
10  end do
!
! --- VECTEUR DES COMPOSANTES
    call wkvect(cmps, 'V V K8', ncmpg, jcmps)
    if (nomgd .eq. 'NEUT_R' .and. licmp(1)(1:1) .eq. ' ') then
        do 20 i = 1, ncmpg
            call codent(i, 'G', cnum)
            zk8(jcmps-1+i) = 'X'//cnum
20      continue
    else
        do 21 i = 1, ncmpg
            ASSERT(licmp(i).ne.' ')
            zk8(jcmps-1+i) = licmp(i)
21      continue
    endif
!
! --- APPEL A CESCRE
    call cescre(base, ces, typces, cesk(1), nomgd,&
                ncmpg, zk8(jcmps), zi(j1), zi(j2), [-ncmpg])
!
! --- MENAGE
    call jedetr(wk1)
    call jedetr(wk2)
    call jedetr(cmps)
!
    call jedema()
end subroutine
