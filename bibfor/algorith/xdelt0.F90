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

subroutine xdelt0(elrefp, ndime, tabls, ptxx, ksi, delta, arete)
    implicit none
!
#include "jeveux.h"
#include "asterc/r8gaem.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/elrfdf.h"
#include "asterfort/elrfvf.h"
#include "asterfort/xnormv.h"
    character(len=8) :: elrefp
    integer :: ndime
    real(kind=8) :: tabls(*), ksi, delta, ptxx(*)
    integer, intent(in), optional :: arete
!                 CALCUL DE LA QUANTITE A MINIMISER POUR LE CALCUL
!                    DE L INTERSECTION DE LA DROITE v*ksi+ptm AVEC 
!                     L ISO ZERO DE LA LEVEL SET
!
!     ENTREE
!       NDIM    : DIMENSION TOPOLOGIQUE DU MAILLAGE
!       KSI     : COORDONNEES DE REFERENCE DU POINT
!       LSNL    : VALEUR DES LSN DES NOEUDS DE L'ARETE
!
!     SORTIE
!       DELTA   : QUANTITE A MINIMISER
!     ----------------------------------------------------------------
!
!
    integer :: nbfct
    parameter    ( nbfct=27)   
    real(kind=8) :: ff(nbfct), dff(3, nbfct), v(ndime), pt(ndime), ptm(ndime)
    integer :: i, nderiv, nno, k, nna
    real(kind=8) :: fctg, dfctg, x(1), dfft(3,3), norme, rbid
!
!
!......................................................................
!
! --- CALCUL DES FONCTIONS DE FORME ET DE LEUR DERIVEES EN UN POINT
! --- DANS LA MAILLE
!
!
!
    call jemarq()
    fctg = 0.d0
    dfctg = 0.d0
!
    if (present(arete)) then
!   COORDONNEES SUIVANT L'ARETE AB DANS L ELEMENT DE REFERENCE
       do i = 1,ndime
         pt(i)=2.d0*(1.d0-ksi)*(5.d-1-ksi)*ptxx(i)+4.d0*ksi*(1.d0-ksi)*&
               ptxx(i+2*ndime)+2.d0*ksi*(ksi-5.d-1)*ptxx(i+ndime)
       end do
!     CALCUL DU VECTEUR TANGENT AU POINT COURANT
       x(1) = 2.d0*ksi-1.d0
       call elrfdf('SE3', x, 1*3, dfft, nna,&
                   nderiv)
       do k = 1, ndime
          v(k) = ptxx(k)*dfft(1,1)+ptxx(k+ndime)*dfft(1,2)+ptxx(k+2*ndime)*dfft(1,3)
          ptm(k) = ptxx(k+ndime)-ptxx(k)
       end do
       call xnormv(ndime, v, rbid)
       call xnormv(ndime, ptm, norme)
       do k = 1, ndime
          v(k) = v(k)*norme
       end do
    else
       do i = 1,ndime
         v(i)=ptxx(i)
         ptm(i)=ptxx(i+ndime)
       end do
!   COORDONNEES SUIVANT LE SEGMENT AB DANS L ELEMENT DE REFERENCE
       do i = 1,ndime
          pt(i)=ksi*v(i)+ptm(i)
       end do
    endif
!
!     CALCUL DES FONCTIONS DE FORME DE L'ELEMENT EN KSI
    call elrfvf(elrefp, pt, nbfct, ff, nno)
!
!     CALCUL DES DERIVEES FONCTIONS DE FORME DE L'ELEMENT EN KSI
    call elrfdf(elrefp, pt, ndime*nno, dff, nno,&
                nderiv)
!
! ---           FCTG : LEVEL SET NORMALE
    do i = 1, nno
        fctg = fctg + ff(i)*tabls(i)
    end do
    dfctg=0.d0
    do k = 1, ndime
       do i = 1, nno
         dfctg=dfctg+tabls(i)*dff(k,i)*v(k)
       end do
    end do
    ASSERT( abs(dfctg) .gt. 1.d0/r8gaem())
!
! --- CALCUL DES QUANTITES A MINIMISER
!     CALCUL DE DELTAS
!
    delta=fctg/dfctg
!
    call jedema()
end subroutine
