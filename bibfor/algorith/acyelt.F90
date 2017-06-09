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

subroutine acyelt(nmcolz, nomobz, nob, cmat, ndim,&
                  ideb, jdeb, x)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 10/04/91
!-----------------------------------------------------------------------
!  BUT:  ASSEMBLER SI ELLE EXISTE LA SOUS-MATRICE  CORRESPONDANT
!  A UN NOM OBJET DE COLLECTION DANS UNE MATRICE COMPLEXE AVEC
!   UN ASSEMBLAGE EN UN TEMPS (ADAPTE AU CYCLIQUE)
!   LA SOUS-MATRICE EST SYMETRIQUE ET SE SITUE A CHEVAL SUR LA DIAGONALE
!   ELLE EST ELLE-MEME STOCKEE TRIANGULAIRE SUPERIEURE
!
!-----------------------------------------------------------------------
!
! NMCOLZ   /I/: NOM K24 DE LA COLLECTION
! NOMOBZ   /I/: NOM K8 DE L'OBJET DE COLLECTION
! NOB     /I/: NOMBRE DE LIGNE ET COLONNES DE LA MATRICE ELEMENTAIRE
! CMAT     /M/: MATRICE RECEPTRICE COMPLEXE
! NDIM     /I/: DIMENSION DE LA MATRICE RECEPTRICE CARREE
! IDEB     /I/: INDICE DE PREMIERE LIGNE RECEPTRICE
! JDEB     /I/: INDICE DE PREMIERE COLONNE RECEPTRICE
! X        /I/: COEFFICIENT ASSEMBLAGE
!
!
!
#include "jeveux.h"
!
#include "asterfort/ampcpr.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
!
!
    character(len=8) :: nomob
    character(len=24) :: nomcol
    complex(kind=8) :: cmat(*)
    character(len=*) :: nmcolz, nomobz
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, iad, ibid, ideb, iret, j, jdeb
    integer :: llob, ndim, nob
    real(kind=8) :: x
!-----------------------------------------------------------------------
    call jemarq()
    nomob = nomobz
    nomcol = nmcolz
!
    call jenonu(jexnom(nomcol(1:15)//'.REPE.MAT', nomob), iret)
    if (iret .eq. 0) goto 9999
!
    call jenonu(jexnom(nomcol(1:15)//'.REPE.MAT', nomob), ibid)
    call jeveuo(jexnum(nomcol, ibid), 'L', llob)
!
    iad = llob - 1
    do 30 j = 1, nob
        do 30 i = j, 1, -1
            iad = iad + 1
            call ampcpr(cmat, ndim, ndim, zr(iad), 1,&
                        1, ideb-1+i, jdeb-1+j, x, 1,&
                        1)
30      continue
!
!
9999  continue
    call jedema()
end subroutine
