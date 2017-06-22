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

subroutine xpogma(nbgma, nb, listgr, ima, jlogma)
!
!
    implicit none
!
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    integer :: nbgma, nb, ima, jlogma
    character(len=24) :: listgr
!
!   AUGMENTATION DE LA TAILLE DES GROUP_MA A CREER
!
!   IN
!       NBGMA   : NOMBRE DE GROUP_MA EN TOUT
!       NB      : NOMBRE D'ELEMENTS A RAJOUTER
!       LISTGR  : LISTE DES GROUPES DE MAILLES
!       IMA     : NUMERO DE LA MAILLE
!
!   IN/OUT
!       JLOGMA  : ADRESSE DES VECTEUR DE TAILLE
!
    integer :: ngrm, iagma, i, ig
!
!
    call jemarq()
!
    if (nbgma .eq. 0) goto 999
!
    call jelira(jexnum(listgr, ima), 'LONMAX', ngrm)
!
!     NGRM = 0 : MAILLE N'APPARTENANT A AUCUN GROUPE, ON SORT
    if (ngrm .eq. 0) goto 999
!
    call jeveuo(jexnum(listgr, ima), 'L', iagma)
!
!     BOUCLE SUR LES GROUPES CONTENANT LA MAILLE IMA
    do 10 i = 1, ngrm
!       NUMERO DU GROUPE
        ig = zi(iagma-1+i)
!       ON AUGMENTE DE NB
        zi(jlogma-1+ig)=zi(jlogma-1+ig)+nb
10  end do
!
999  continue
    call jedema()
end subroutine
