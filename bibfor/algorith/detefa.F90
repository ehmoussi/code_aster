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

subroutine detefa(nnose, pi1, pi2, it, typma,&
                  ainter, cnset, n)
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/conare.h"
#    include "asterfort/xxmmvd.h"
    integer :: nnose, it, pi1, pi2, cnset(*), n(3)
    real(kind=8) :: ainter(*)
    character(len=8) :: typma
! person_in_charge: samuel.geniaut at edf.fr
!
!                      DETERMINER LE FACE DANS L'ELEMENT DE REFERENCE
!
!     ENTREE
!       NNOSE   : NOMBRE DE NOEUDS DU SOUS TETRA
!       PI1     : NUMERO DU PREMIER POINT D'INTERSECTION
!       PI2     : NUMERO DU DEUXIEME POINT D'INTERSECTION
!       CNSET   : CONNECTIVITE DES NOEUDS DE L'ELT PARENT
!       AINTER  : INFOS ARETE ASSOCIEE AU POINT D'INTERSECTION
!       IT      : INDICE DE SOUS-TETRA TRAITE EN COURS
!       TYPMA   : TYPE DE LA MAILLE (TYPE_MAILLE)
!
!     SORTIE
!       N       : LES INDICES DES NOEUX D'UNE FACE DANS L'ELEMENT PARENT
!-----------------------------------------------------------------------
!
    integer :: ar(12, 3), nbar, a1, a2, n1, n2, n3
    integer :: i, j, zxain
    aster_logical :: found
!-----------------------------------------------------------------------
    zxain=xxmmvd('ZXAIN')
    call conare(typma, ar, nbar)
    a1=nint(ainter(zxain*(pi1-1)+1))
    a2=nint(ainter(zxain*(pi2-1)+1))
!
!     CAS OU LA FISSURE COINCIDE AVEC UNE ARETE NON TRAITE ICI
    ASSERT((a1.ne.0).or.(a2.ne.0))
!
    do 1 i=1,3
       n(i)=0
1   continue     
    found=.false. 
!
!     CAS UN DES DEUX POINTS D'INTERSECTION EST CONFONDU AVEC UN NOEUD
!     SOMMET, CALCULE LES 3 INDICES DANS L'ELEMENT ENFANT
    if ((a1.eq.0) .and. (a2.ne.0)) then
        n1=ar(a2,1)
        n(1)=cnset(nnose*(it-1)+n1)
        n2=ar(a2,2)
        n(2)=cnset(nnose*(it-1)+n2)
        n(3)=nint(ainter(zxain*(pi1-1)+2))
!
    else if ((a1.ne.0).and.(a2.eq.0)) then
        n1=ar(a1,1)
        n(1)=cnset(nnose*(it-1)+n1)
        n2=ar(a1,2)
        n(2)=cnset(nnose*(it-1)+n2)
        n(3)=nint(ainter(zxain*(pi2-1)+2))
!
!     CAS LES DEUX POINTS D'INTERSECTIONS NE SONT PAS CONFONDU AVEC
!     LES NOEUDS SOMMETS, CALCULE LES 3 INDICES DANS L'ELEMENT ENFANT
    else if ((a1.ne.0).and.(a2.ne.0)) then
        do 30 i = 1, 2
            do 40 j = 1, 2
                if (ar(a1,i) .eq. ar(a2,j)) then
!                if (cnset(nnose*(it-1)+ar(a1,i)) .eq. cnset(nnose*(it-1)+ar(a2,j))) then
                    found=.true.
                    n3=ar(a1,i)
                    n1=ar(a1,3-i)
                    n2=ar(a2,3-j)
                endif
40          continue
30      continue
        ASSERT(found)
        n(1)=cnset(nnose*(it-1)+n1)
        n(2)=cnset(nnose*(it-1)+n2)
        n(3)=cnset(nnose*(it-1)+n3)
    endif
!
end subroutine
