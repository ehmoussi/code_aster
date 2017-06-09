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

subroutine fgtaep(nommat, nomfo1, nomnap, nbcycl, epsmin,&
                  epsmax, dom)
    implicit none
#include "jeveux.h"
#include "asterfort/fointe.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/rcvale.h"
    character(len=*) :: nommat, nomfo1, nomnap
    real(kind=8) :: epsmin(*), epsmax(*)
    real(kind=8) :: dom(*)
    integer :: nbcycl
!     CALCUL DU DOMMAGE ELEMENTAIRE PAR TAHERI_MANSON_COFFIN
!     ------------------------------------------------------------------
! IN  NOMMAT : K   : NOM DU MATERIAU
! IN  NOMFO1 : K   : NOM DE LA FONCTION
! IN  NOMNAP : K   : NOM DE LA NAPPE
! IN  NBCYCL : I   : NOMBRE DE CYCLES
! IN  EPSMIN : R   : DEFORMATIONS MINIMALES DES CYCLES
! IN  EPSMAX : R   : DEFORMATIONS MAXIMALES DES CYCLES
! OUT DOM    : R   : VALEURS DES DOMMAGES ELEMENTAIRES
!     ------------------------------------------------------------------
!
    integer :: icodre(1)
    character(len=16) :: nomres
    character(len=8) :: nompar, nomp(2)
    character(len=32) :: pheno
    real(kind=8) :: nrupt(1), delta, dsigm, depsi, epmax, valp(2)
!-----------------------------------------------------------------------
    integer :: i, ier, nbpar
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    data zero  /1.d-13/
!
    call jemarq()
!
    epmax = 0.d0
    nomres = 'MANSON_COFFIN'
    nbpar = 1
    pheno = 'FATIGUE   '
    nompar = 'EPSI    '
    do 10 i = 1, nbcycl
        delta = (abs(epsmax(i)-epsmin(i)))/2.d0
        if (delta .gt. epmax-zero) then
            epmax = delta
            call rcvale(nommat, pheno, nbpar, nompar, [delta],&
                        1, nomres, nrupt(1), icodre(1), 2)
            dom(i) = 1.d0/nrupt(1)
        else
            nomp(1) = 'X'
            nomp(2) = 'EPSI'
            valp(1) = epmax
            valp(2) = delta
            call fointe('F ', nomnap, 2, nomp, valp, dsigm, ier)
            nomp(2) = 'SIGM'
            call fointe('F ', nomfo1, 1, [nomp(2)], [dsigm], depsi, ier)
            call rcvale(nommat, pheno, nbpar, nompar, [depsi],&
                        1, nomres, nrupt(1), icodre(1), 2)
            dom(i) = 1.d0/nrupt(1)
        endif
10  end do
!
    call jedema()
end subroutine
