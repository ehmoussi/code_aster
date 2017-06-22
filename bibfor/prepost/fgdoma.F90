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

subroutine fgdoma(nommat, nbcycl, epsmin, epsmax, dom)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/rcvale.h"
    character(len=*) :: nommat
    real(kind=8) :: epsmin(*), epsmax(*)
    real(kind=8) :: dom(*)
    integer :: nbcycl
!     CALCUL DU DOMMAGE ELEMENTAIRE PAR INTERPOLATION SUR
!     UNE COURBE DE MANSON_COFFIN DONNEE POINT PAR POINT
!     ------------------------------------------------------------------
! IN  NOMMAT : K   : NOM DU MATERIAU
! IN  NBCYCL : I   : NOMBRE DE CYCLES
! IN  EPSMIN : R   : DEFORMATIONS MINIMALES DES CYCLES
! IN  EPSMAX : R   : DEFORMATIONS MAXIMALES DES CYCLES
! OUT DOM    : R   : VALEURS DES DOMMAGES ELEMENTAIRES
!     ------------------------------------------------------------------
!
    integer :: icodre(1)
    character(len=8) :: nompar
    character(len=16) :: nomres
    character(len=32) :: pheno
    real(kind=8) :: nrupt(1), delta
!
!-----------------------------------------------------------------------
    integer :: i, nbpar
!-----------------------------------------------------------------------
    call jemarq()
    nomres = 'MANSON_COFFIN'
    nbpar = 1
    pheno = 'FATIGUE   '
    nompar = 'EPSI    '
!
    do 10 i = 1, nbcycl
        delta = (abs(epsmax(i)-epsmin(i)))/2.d0
        call rcvale(nommat, pheno, nbpar, nompar, [delta],&
                    1, nomres, nrupt(1), icodre(1), 2)
        dom(i) = 1.d0/nrupt(1)
10  end do
!
    call jedema()
end subroutine
