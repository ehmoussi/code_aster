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

subroutine trldc(a, nordre, ierr)
    implicit none
!
!    A. COMTE                                 DATE 31/07/91
!-----------------------------------------------------------------------
!  BUT: FACTORISATION LDLT EN PLACE D'UNE MATRICE COMPLEXE
!  ET HERMITIENNE STOCKEE TRIANGULAIRE SUPERIEURE
!
!  CODE RETOUR  SI =0 RAS
!               SI NON NUL ALORS EST EGAL AU RANG DU PIVOT NUL TROUVE
!
!-----------------------------------------------------------------------
!
! A        /M/: MATRICE COMPLEXE A FACTORISER
! NORDRE   /I/: DIMENSION DE LA MATRICE
! IERR     /O/: CODE RETOUR
!
!-----------------------------------------------------------------------
!
#include "asterc/r8gaem.h"
#include "asterfort/utmess.h"
    complex(kind=8) :: a(*), r8val
    real(kind=8) :: epsi, xmod, xmax, zero
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, ibm, idiag, ierr, in, indiag, jn
    integer :: jndiag, nordre
!-----------------------------------------------------------------------
    data zero /0.d+00/
!-----------------------------------------------------------------------
!
    epsi=1.d0/r8gaem()
    xmax=zero
    ierr = 0
    do 100 in = 1, nordre
        indiag = in*(in-1)/2+1
        if (in .eq. 1) goto 50
!
!        UTILISATION  DES  LIGNES  (1) A (IN-1)
        do 40 jn = 1, in-1
            jndiag = jn*(jn-1)/2+1
!
            if (jn .eq. 1) goto 36
            ibm = jn - 1
!
            r8val = a (indiag+in-jn)
            do 30 i = 1, ibm
                idiag = i*(i-1)/2+1
                r8val = r8val - dconjg(a(jndiag+jn-i))*a(indiag+in-i)* a(idiag)
30          continue
            a ( indiag+in-jn ) = r8val
!
36          continue
            a (indiag+in-jn ) = a (indiag+in-jn ) / a(jndiag)
40      continue
!
50      continue
!
!        UTILISATION  DE LA LIGNE IN ( CALCUL DU TERME PIVOT)
        ibm = in - 1
!
        r8val = a (indiag)
        do 85 i = 1, ibm
            idiag = i*(i-1)/2+1
            r8val = r8val - dconjg(a(indiag+in-i))*a(indiag+in-i)*a( idiag)
85      continue
        a (indiag) = r8val
        xmod=dble(r8val)**2+dimag(r8val)**2
        if (xmod .gt. xmax) xmax=xmod
        if ((xmod/xmax) .lt. epsi) then
            call utmess('I', 'ALGORITH10_98')
            ierr = in
            goto 9999
        endif
!
100  end do
!
9999  continue
end subroutine
