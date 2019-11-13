! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine fonnoe2(resu, noma, nomobj, nbnoff, typmp)
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/ismali.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/reliem.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=6)  :: nomobj
    character(len=8)  :: resu, noma
!
! FONCTION REALISEE:
!
!     CONSTRUCTION DU NOEUD DU FOND DE FISSURE
!
!     ENTREES:
!        RESU       : NOM DU CONCEPT RESULTAT DE L'OPERATEUR
!        NOMA       : NOM DU MAILLAGE
!        NOMOBJ     : NOM DU VECTEUR CONTENANT LES DONNEES RELATIVES
!                     AUX NOEUDS
!     SORTIES:
!        NBNOFF     : NOMBRE DE NOEUDS EN FOND DE FISSURE, ICI 1
!        TYPMP      : EN 2D, LE FOND N'EST COMPOSE QUE DE 1 NOEUD, DONC TYPMP = ''
!-----------------------------------------------------------------------
!
!
    integer :: jnoe1, jadr
    integer :: jjj, nbnoff
    character(len=8) :: noeud, typmp
    character(len=24) :: obtrav
!
    call jemarq()
!
!   EN 2D, LE TYPE DE MAILLE EN FOND DE FISSURE VAUT ''
    typmp ='        '
    nbnoff = 1
!
!   INFORMATION SUR LE NOEUD DU FOND DE FISSURE
    call wkvect(resu//'.FOND.NOEU', 'G V K8', nbnoff, jnoe1)
    obtrav = '&&'//nomobj//'.GROUP_NO'
! 
    call jeveuo(obtrav, 'L', jjj)
    call jeveuo(jexnom(noma//'.GROUPENO', zk24(jjj)), 'L', jadr)
    call jenuno(jexnum(noma//'.NOMNOE', zi(jadr)), noeud)
    zk8(jnoe1) = noeud
!
    call jelira(resu//'.FOND.NOEU', 'LONUTI', nbnoff)
    call jedema()
end subroutine
