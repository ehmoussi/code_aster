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

subroutine gilig1(nfic, ndim, nbval, nbpoin)
    implicit   none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    integer :: nfic, ndim, nbval, nbpoin
!
!     BUT: LIRE LES N LIGNES DES POINTS DU MAILLAGE GIBI :
!                 ( PROCEDURE SAUVER)
!
!     IN: NFIC   : UNITE DE LECTURE
!         NDIM   : DIMENSION DU MAILLAGE : 2D OU 3D.
!         NBVAL  : NOMBRE DE VALEURS A LIRE
!
! ----------------------------------------------------------------------
!
    integer :: iacoor, iacoo1, nbfois, nbrest, icoj, i, j
    real(kind=8) :: rbid(3)
!     ------------------------------------------------------------------
!
    call jemarq()
!
!     -- ON CREE L'OBJET QUI CONTIENDRA LES COORDONNEES DES POINTS:
!        (ON CREE AUSSI UN OBJET TEMPORAIRE A CAUSE DES DENSITES)
!
    call wkvect('&&GILIRE.COORDO', 'V V R', nbpoin*ndim, iacoor)
    call wkvect('&&GILIRE.COORD1', 'V V R', nbpoin*(ndim+1), iacoo1)
!
!     -- ON LIT LES COORDONNEES DES NOEUDS:
!
    nbfois = nbval / 3
    nbrest = nbval - 3*nbfois
    icoj = 0
    do 10 i = 1, nbfois
        read(nfic,1000) ( rbid(j), j=1,3 )
        zr(iacoo1-1+ icoj +1) = rbid(1)
        zr(iacoo1-1+ icoj +2) = rbid(2)
        zr(iacoo1-1+ icoj +3) = rbid(3)
        icoj = icoj + 3
10  end do
    if (nbrest .gt. 0) then
        read(nfic,1000) ( rbid(j), j=1,nbrest )
        do 12 i = 1, nbrest
            zr(iacoo1-1+ icoj +i) = rbid(i)
12      continue
    endif
!
!     -- ON RECOPIE LES COORDONNEES EN OTANT LES DENSITES:
    do 20 i = 1, nbpoin
        do 22 j = 1, ndim
            zr(iacoor-1+ndim*(i-1)+j)=zr(iacoo1-1+(ndim+1)*(i-1)+j)
22      continue
20  end do
    call jedetr('&&GILIRE.COORD1')
!
    1000 format( 3(1x,d21.14) )
!
    call jedema()
!
end subroutine
