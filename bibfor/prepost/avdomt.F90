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

subroutine avdomt(nbvec, nbordr, ncycl, jdomel, domtot)
! person_in_charge: van-xuan.tran at edf.fr
    implicit   none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: nbvec, nbordr, ncycl(nbvec), jdomel
    real(kind=8) ::  domtot(nbvec)
!   real(kind=8) ::domel(nbvec*nbordr),
! ----------------------------------------------------------------------
! BUT: CALCULER LE DOMMAGE TOTAL (CUMUL) POUR TOUS LES VECTEURS NORMAUX.
! ----------------------------------------------------------------------
! ARGUMENTS :
!  NBVEC    IN   I  : NOMBRE DE VECTEURS NORMAUX.
!  NBORDR   IN   I  : NOMBRE DE NUMEROS D'ORDRE.
!  NCYCL    IN   I  : NOMBRE DE CYCLES ELEMENTAIRES POUR TOUS LES
!                     VECTEURS NORMAUX.
!  JDOMEL    IN   I  : ADDRESSE VECTEUR CONTENANT LES VALEURS DES DOMMAGES
!                     ELEMENTAIRES, POUR TOUS LES SOUS CYCLES
!                     DE CHAQUE VECTEUR NORMAL.
!  DOMTOT   OUT  R  : VECTEUR CONTENANT LES DOMMAGES TOTAUX (CUMUL)
!                     DE CHAQUE VECTEUR NORMAL.
! ----------------------------------------------------------------------
!     ------------------------------------------------------------------
    integer :: ivect, icycl, adrs, i
!     ------------------------------------------------------------------
!234567                                                              012
!
    call jemarq()
!
! INITIALISATION
!
    do 100 i = 1, nbvec
        domtot(i) = 0
100  end do
!
    do 10 ivect = 1, nbvec
        do 20 icycl = 1, ncycl(ivect)
            adrs = (ivect-1)*nbordr + icycl
            domtot(ivect) = domtot(ivect) + zr(jdomel+adrs)
20      continue
10  end do
!
    call jedema()
!
end subroutine
