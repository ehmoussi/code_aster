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

subroutine palino(nomaz, mcfact, mcgrno, mcno, iocc,&
                  noml)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/reliem.h"
#include "asterfort/wkvect.h"
    character(len=*) :: nomaz, mcfact, mcgrno, mcno, noml
    integer :: iocc
!
! BUT : LECTURE DE LA LISTE DE NOEUDS DECRITS PAR LA SEQUENCE :
!       MCFAC : ( MCGRNO : LISTE DE GROUP_NO ,
!                 MCNO   : LISTE DE NOEUD   , ....)
!       CREATION D'UN OBJET DE NOM : NOML  OJB V V I DIM=NBNO+1
!       NBNO : NOMBRE DE NOEUDS LUS
!       NOML(1) = NBNO  NOML(1+I)=INO NUM.DUNOEUD DANS NOMAZ
!
! IN   NOMAZ   : NOM DU MAILLAGE
! IN   MCFACT K*(*) : MOT CLE FACTEUR
! IN   MCGRNO K*(*) : MOT CLE CONSERNANT LA LISTE DE GROUP_NO
! IN   MCNO   K*(*) : MOT CLE CONSERNANT LA LISTE DE NOEUDS
! IN   IOCC   I     : NUMERO DE L'OCCURENCE DU MOT CLE FACTEUR
! OUT  NOML   K*24  : NOM DE L'OBJET JEVEUX CREE SUR LA VOLATILE
!
    character(len=8) :: noma
    character(len=16) :: mcf, tymocl(2), limocl(2)
    character(len=24) :: liste1
    integer :: j1, j2, n1, k
!
    call jemarq()
    noma = nomaz
    mcf = mcfact
    tymocl(1)='GROUP_NO'
    limocl(1)= mcgrno
    tymocl(2)='NOEUD'
    limocl(2)= mcno
!
    liste1='&&PALINO.LISTE'
!
    call reliem(' ', noma, 'NU_NOEUD', mcf, iocc,&
                2, limocl, tymocl, liste1, n1)
    call jedetr(noml)
    call wkvect(noml, 'V V I', n1+1, j2)
    zi(j2)=n1
    if (n1 .gt. 0) then
        call jeveuo(liste1, 'L', j1)
        do 1, k=1,n1
        zi(j2+k)=zi(j1-1+k)
 1      continue
    endif
!
!
    call jedetr(liste1)
    call jedema()
end subroutine
