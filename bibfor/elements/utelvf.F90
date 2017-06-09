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

subroutine utelvf(elrefa, famil, nomjv, npg, nno)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elraca.h"
#include "asterfort/elraga.h"
#include "asterfort/elrfvf.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: npg, nno
    character(len=8) :: elrefa, famil
    character(len=*) :: nomjv
! BUT: RECUPERER LES VALEURS DES FONCTIONS DE FORME
! ----------------------------------------------------------------------
!   IN   ELREFA : NOM DE L'ELREFA (K8)
!        FAMIL  : NOM DE LA FAMILLE DE POINTS DE GAUSS :
!                 'FPG1','FPG3',...
!   IN   NOMJV  : NOM JEVEUX POUR STOCKER LES FONCTIONS DE FORME
!   OUT  NPG    : NOMBRE DE POINTS DE GAUSS
!        NNO    : NOMBRE DE NOEUDS DU TYPE_MAILLE
! ----------------------------------------------------------------------
!
    integer :: nbpgmx, nbnomx, nbfamx
    parameter (nbpgmx=27, nbnomx=27, nbfamx=20)
!
    integer :: nbpg(nbfamx), ndim, nnos, nbfpg
    integer :: ifam, decal, ipg, ino, jvr
    real(kind=8) :: xno(3*nbnomx), xpg(3*nbpgmx), poipg(nbpgmx), ff(nbnomx)
    real(kind=8) :: vol
    character(len=8) :: nofpg(nbfamx)
! DEB ------------------------------------------------------------------
!
    call elraca(elrefa, ndim, nno, nnos, nbfpg,&
                nofpg, nbpg, xno, vol)
!
    ASSERT((ndim.ge.0) .and. (ndim.le.3))
    ASSERT((nno.gt.0) .and. (nno.le.nbnomx))
    ASSERT((nbfpg.gt.0) .and. (nbfpg.le.nbfamx))
!
    do 10,ifam = 1,nbfpg
    if (nofpg(ifam) .eq. famil) goto 12
    10 end do
    call utmess('F', 'ELEMENTS4_56', sk=famil)
12  continue
!
    npg = nbpg(ifam)
    ASSERT((npg.gt.0) .and. (npg.le.nbpgmx))
!
    call wkvect(nomjv, 'V V R', npg*nno, jvr)
!
!       -- COORDONNEES ET POIDS DES POINTS DE GAUSS :
!       ------------------------------------------------
    call elraga(elrefa, nofpg(ifam), ndim, npg, xpg,&
                poipg)
!
!     -- VALEURS DES FONCTIONS DE FORME :
!     ------------------------------------------------
    decal = 0
    do 20 ipg = 1, npg
        call elrfvf(elrefa, xpg(ndim*(ipg-1)+1), nbnomx, ff, nno)
        do 22 ino = 1, nno
            decal = decal + 1
            zr(jvr-1+decal) = ff(ino)
22      continue
20  end do
!
end subroutine
