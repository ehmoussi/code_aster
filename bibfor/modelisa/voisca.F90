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

subroutine voisca(mailla, nbnobe, nunobe, comima, nbnobi,&
                  nunobi)
    implicit none
!  DESCRIPTION : SELECTION DANS LA LISTE NUNOBE DES NOEUDS DE BETON
!  -----------   APPARTENANT AU PAVE DEFINI PAR LES COORDONNEES EXTREMES
!                CONTENUES DANS COMIMA.
!
!  IN     : MAILLA : CHARACTER*8 , SCALAIRE
!                    NOM DU CONCEPT MAILLAGE ASSOCIE A L'ETUDE
!  IN     : NBNOBE : INTEGER , SCALAIRE
!                    NOMBRE DE NOEUDS APPARTENANT A LA STRUCTURE BETON
!  IN     : NUNOBE : CHARACTER*19 , SCALAIRE
!                    NOM D'UN VECTEUR D'ENTIERS POUR STOCKAGE DES
!                    NUMEROS DES NOEUDS APPARTENANT A LA STRUCTURE BETON
!  IN     : COMIMA : CHARACTER*24
!                    NOM DU VECTEUR CONTENANT LES 6 COORDONNEES
!                    EXTREME QUI CONSTITUENT LE PAVE DANS LEQUEL
!                    EST CONTENU LE CALBLE
!  OUT    : NBNOBI : INTEGER , SCALAIRE
!                    NOMBRE DE NOEUDS DE BETONAPPARTENANT A LA SELECTION
!  OUT    : NUNOBI : CHARACTER*19 , SCALAIRE
!                    NOM D'UN VECTEUR D'ENTIERS POUR STOCKAGE DES
!                    NUMEROS DES NOEUDS APPARTENANT A LA SELECTION
!
!-------------------   DECLARATION DES VARIABLES   ---------------------
!
! ARGUMENTS
! ---------
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=8) :: mailla
    character(len=19) :: nunobe, nunobi
    character(len=24) :: comima
    integer :: nbnobe, nbnobi
!
! VARIABLES LOCALES
! -----------------
#include "jeveux.h"
!
    integer :: jcoor
    real(kind=8) :: xmin, xmax, ymin, ymax, zmin, zmax, x, y, z
!
    character(len=24) :: coorno
!
    integer :: inube, inubi, icomm, noebe, i, j
!
!
!-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
!
    call jemarq()
    call jeveuo(nunobe, 'L', inube)
    call jeveuo(nunobi, 'E', inubi)
    call jeveuo(comima, 'L', icomm)
    coorno = mailla//'.COORDO    .VALE'
    call jeveuo(coorno, 'L', jcoor)
!
    xmin = zr(icomm-1+1)
    xmax = zr(icomm-1+2)
    ymin = zr(icomm-1+3)
    ymax = zr(icomm-1+4)
    zmin = zr(icomm-1+5)
    zmax = zr(icomm-1+6)
!
!     SELECTION DES NOEUDS APPARTENANT AU PAVE FORME PAR LES
!     COORDONNEES EXTREMES DES NOEUDS DU CABLE
    j=0
    do 10 i = 1, nbnobe
        noebe = zi(inube-1+i)
        x = zr(jcoor+3*(noebe-1) )
        y = zr(jcoor+3*(noebe-1)+1)
        z = zr(jcoor+3*(noebe-1)+2)
        if (x .lt. xmin) goto 10
        if (x .gt. xmax) goto 10
        if (y .lt. ymin) goto 10
        if (y .gt. ymax) goto 10
        if (z .lt. zmin) goto 10
        if (z .gt. zmax) goto 10
!
        zi(inubi+j) = noebe
        j = j+1
10  end do
    nbnobi=j
!
    call jedema()
end subroutine
