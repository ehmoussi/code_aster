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

subroutine foston(chval, vecnom, nbfonc)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelibe.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    integer :: nbfonc
    character(len=*) :: chval, vecnom(nbfonc)
!     STOCKAGE DANS LA COLLECTION CHVAL DES FONCTIONS COMPOSANT LA NAPPE
!     ACCES PAR NOM OU NUMERO DANS LA COLLECTION
!     ------------------------------------------------------------------
! IN  CHVAL : NOM JEVEUX DE LA COLLECTION
! IN  VECNOM: NOMS DES FONCTIONS, ISSUS DES COMMANDES UTILISATEUR
! IN  NBFONC: NOMBRE DE FONCTIONS
!     ------------------------------------------------------------------
!     OBJETS SIMPLES LUS
!         CHFVAL=VECNOM(I)//'.VALE'
!     OBJETS SIMPLES CREES
!         JEXNUM(CHVAL,I)
!     ------------------------------------------------------------------
    integer :: i, j, nbp, lvaln, lvalf, nbpt
    character(len=24) :: chfval
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    nbpt=0
    chfval(20:24) = '.VALE'
    do 1 i = 1, nbfonc
        chfval(1:19) = vecnom(i)
        call jelira(chfval, 'LONUTI', nbp)
        nbpt=nbpt+nbp
 1  end do
    call jeecra(chval, 'LONT', nbpt)
    do 3 i = 1, nbfonc
        chfval(1:19) = vecnom(i)
        call jeveuo(chfval, 'L', lvalf)
        call jelira(chfval, 'LONUTI', nbp)
        call jecroc(jexnum(chval, i))
        call jeecra(jexnum(chval, i), 'LONMAX', nbp)
        call jeecra(jexnum(chval, i), 'LONUTI', nbp)
        call jeveuo(jexnum(chval, i), 'E', lvaln)
        do 2 j = 1, nbp
            zr(lvaln+j-1)=zr(lvalf+j-1)
 2      continue
        call jelibe(chfval)
 3  end do
    call jedema()
end subroutine
