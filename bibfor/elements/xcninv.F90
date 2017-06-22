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

subroutine xcninv(nnotot, nse, nnop, nno, jcnset,&
                  cninv)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
    integer :: nnotot, nse, nnop, nno, jcnset
    integer :: cninv(nnotot, nse+1)
!
!     BUT:
!         CALCUL DE LA CONNECTIVITE INVERSE DES SOUS ELEMENTS
!         DE L'ELEMENT XFEM PARENT (EN 2D).
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   NNOTOT : NOMBRE TOTAL DE NOEUDS (POINTS D'INTERSECTION INCLUS)
! IN   NSE    : NOMBRE TOTAL DE SOUS ELEMENT DE L'ELEMENT PARENT
! IN   NNOP   : NOMBRE DE NOEUDS DE L'ELEMENT PARENT (POINTS)
!                D'INTERSECTION EXCLUS
! IN   NNO    : NOMBRE DE NOEUDS DU SOUS-ELEMENT DE REFERENCE
! IN   JCNSET : ADRESSE DANS ZI DE LA CONNECTIVITE DES SOUS-ELEMENTS
!
!      SORTIE :
!-------------
! OUT  CNINV  : TABLEAU DE LA CONNECTIVITE INVERSE
!
! ......................................................................
!
!
!
!
    integer :: ise, in, ino, jno
!
! --- RÉCUPÉRATION DE LA SUBDIVISION DE L'ÉLÉMENT PARENT
! --- EN NSE SIMPLEXES
!
! ------------------- BOUCLE SUR LES NSE SOUS-ÉLÉMENTS  ----------------
!
    do 110 ise = 1, nse
!
! ------------- BOUCLE SUR LES SOMMETS DU SOUS-ÉLÉMENTS  ---------------
!
        do 111 in = 1, nno
!
            ino=zi(jcnset-1+nno*(ise-1)+in)
! ------- NUMÉROTATION PROPRE A LA CONNECTIVITÉ INVERSE
            if (ino .lt. 1000) then
                jno=ino
            else
                jno=ino-1000+nnop
            endif
! ------- STOCKAGE
            cninv(jno,1)=cninv(jno,1)+1
            ASSERT(cninv(jno, 1).le.nse)
            cninv(jno,cninv(jno,1)+1)=ise
!
111      continue
!
110  end do
!
end subroutine
