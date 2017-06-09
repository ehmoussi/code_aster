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

subroutine xselno(nno, nnop, nbsig, nse, ndim,&
                  jcnset, siseno, jout2)
    implicit none
!
!    - FONCTIONS REALISEES :  ROUTINE X-FEM
!
!          PASSAGE DES CONTRAINTES
!          DES POINTS DE GAUSS DES SOUS-ELEMENTS :
!            * AUX NOEUDS DES ELEMENTS PARENTS
!              (OPTION 'SIGM_ELNO') ;
!            * AUX SOMMETS (NOEUDS) DES SOUS-ELEMENTS
!              (OPTION 'SISE_ELNO') ;
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
!
!
!
#include "jeveux.h"
#include "asterfort/assert.h"
    integer :: mxval
    parameter (mxval=32*10*6)
!     EN 2D :
!     MXVAL =  6 (NBSE MAX) * 3 (NBNOSE MAX) * 4 (NBCMP MAX)-> en lineaire
!     MXVAL =  6 (NBSE MAX) * 6 (NBNOSE MAX) * 4 (NBCMP MAX)-> en quadratique
!     EN 3D :
!     MXVAL = 32 (NBSE MAX) * 4 (NBNOSE MAX) * 6 (NBCMP MAX)-> en lineaire
!     MXVAL = 32 (NBSE MAX) * 10(NBNOSE MAX) * 6 (NBCMP MAX)-> en quadratique

    integer :: ndim, nnop, nno
    integer :: nbsig, nbseco(27)
    integer :: jcnset
    integer :: jout2
    integer :: i, j, nse, ise, in, ino, ic
!
    real(kind=8) :: tmp, somsig(27, 6)
!
    real(kind=8) :: siseno(mxval)
!
!
! ----------------------------------------------------------------------
!
!
!     TABLEAUX DE LA SOMME DES CONTRAINTES
    do 444 i = 1, nnop
        do 445 j = 1, nbsig
            somsig(i,j)=0
445      continue
444  continue
!
!     TABLEAUX DU NOMBRE DE SOUS-ELEMENTS CONNECTES AUX NOEUDS
    do 446 i = 1, nnop
        nbseco(i)=0
446  continue
!
!       BOUCLE SUR LES NSE SOUS-ÉLÉMENTS
    do 210 ise = 1, nse
!
!       BOUCLE SUR LES 4/3 SOMMETS DU SOUS-TETRA/TRIA
        do 211 in = 1, nno
            ino=zi(jcnset-1+(ndim+1)*(ise-1)+in)
            if (ino .lt. 1000) then
                nbseco(ino)=nbseco(ino)+1
                do 212 ic = 1, nbsig
                    tmp = siseno(nbsig*nno*(ise-1)+nbsig*(in-1)+ic)
                    somsig(ino,ic)=somsig(ino,ic)+tmp
212              continue
            endif
211      continue
!
210  continue
!
!     MOYENNES DES CONTRAINTES AUX NOEUDS DE L'ELEMENT PARENT
    do 300 ino = 1, nnop
        ASSERT(nbseco(ino).gt.0)
        do 310 ic = 1, nbsig
            zr(jout2-1+nbsig*(ino-1)+ic) = somsig(ino,ic) / nbseco( ino)
310      continue
300  continue
!
!
end subroutine
