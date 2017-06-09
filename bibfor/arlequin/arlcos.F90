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

subroutine arlcos(numa, connex, loncum, coord, dime,&
                  cnoeud)
!
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
!
    integer :: numa, connex(*), loncum(*)
    integer :: dime
    real(kind=8) :: coord(3, *), cnoeud(dime, *)
!
! ----------------------------------------------------------------------
!
! CONSTRUCTION DE BOITES ENGLOBANTES POUR UN GROUPE DE MAILLES
!
! RETOURNE LES COORDONNEES DES NOEUDS DE LA MAILLE POUR LES ELEMENTS
! SOLIDES
!
! ----------------------------------------------------------------------
!
!
! IN  NUMA   : NUMERO ABSOLU DE LA MAILLE DANS LE MAILLAGE
! IN  CONNEX : CONNEXITE DES MAILLES
! IN  LONCUM : LONGUEUR CUMULEE DE CONNEX
! IN  COORD  : COORDONNEES DES NOEUDS
! IN  DIME   : DIMENSION DE L'ESPACE
! OUT CNOEUD : COORD DES NOEUDS (X1, [Y1, Z1], X2, ...)
!
! ----------------------------------------------------------------------
!
    integer :: ino, idim, nuno, jdec, nbno
!
! ----------------------------------------------------------------------
!
    jdec = loncum(numa)
    nbno = loncum(numa+1) - jdec
!
    if ((nbno < 1) .or. (nbno > 27)) then
        ASSERT( .false. )
    endif
!
    do 10 ino = 1, nbno
        nuno = connex(jdec-1+ino)
        do 11 idim = 1, dime
            cnoeud(idim,ino) = coord(idim,nuno)
 11     end do
 10 end do
!
end subroutine
