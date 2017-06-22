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

subroutine xmifis(ndim, ndime, elrefp, geom, lsn, &
                  n, ip1, ip2, pinref, miref, mifis,&
                  pintt, exit, jonc, u, v)
    implicit none
!
#include "jeveux.h"
#include "blas/ddot.h"
#include "asterfort/assert.h"
#include "asterfort/reeref.h"
#include "asterfort/reerel.h"
#include "asterfort/vecini.h"
#include "asterfort/xelrex.h"
#include "asterfort/xnewto.h"
#include "asterfort/xnormv.h"
    integer :: ndim, ndime, n(3), ip1, ip2, exit(2)
    character(len=8) :: elrefp
    real(kind=8) :: mifis(ndim), pinref(*), miref(ndime), geom(*), lsn(*)
    real(kind=8) :: pintt(*)
    aster_logical :: jonc
    real(kind=8), intent(in), optional :: u(ndime), v(ndime)
!
!                      TROUVER LES COORDONNES DU PT MILIEU ENTRE LES
!                      DEUX POINTS D'INTERSECTION
!
!     ENTREE
!       NDIM    : DIMENSION TOPOLOGIQUE DU MAILLAGE
!       PTINT  : COORDONNÉES DES POINTS D'INTERSECTION
!       JTABCO  : ADRESSE DES COORDONNEES DES NOEUDS DE L'ELEMENT
!       JTABLS  : ADRESSE DES LSN DES NOEUDS DE L'ELEMENT
!       IPP     : NUMERO NOEUD PREMIER POINT INTER
!       IP      : NUMERO NOEUD DEUXIEME POINT INTER
!       N       : LES INDICES DES NOEUX D'UNE FACE DANS L'ELEMENT PARENT
!       PINTT   : COORDONNES REELES DES POINTS D'INTERSECTION
!       U,V     : BASE ORTHONORMEE DE LA FACE SUR LAQUELLE ON EFFECTUE LA
!                 RECHERCHE (EN OPTION)
!     SORTIE
!       mifis   : COORDONNES DU PT MILIEU ENTRE IPP ET IP
!     ----------------------------------------------------------------
!
    integer :: nno, j, ia, ib, ic
    real(kind=8) :: x(81), ksi(ndime), bc(ndime), ba(ndime), ff(27)
    real(kind=8) :: epsmax, rbid, ip1ip2(ndime), ptxx(2*ndime)
    real(kind=8) :: vect(ndime), k, k1, k2, alpha, dekker(4*ndime)
    real(kind=8) :: pta(ndime) , ptb(ndime), ptc(ndime), newpt(ndime)
    integer :: itemax
    character(len=6) :: name
!
! --------------------------------------------------------------------
!
    itemax=100
    epsmax=1.d-9
    name='XMIFIS'
!
    call xelrex(elrefp, nno, x)
    ib=n(1)
    ic=n(2)
    ia=n(3)
    if (present(u).and.present(v)) then
       do j = 1, ndime
          bc(j) = u(j)
          ba(j) = v(j)
       end do
    else
       if (ia.lt.1000) then
          do j = 1, ndime
             pta(j) = x(ndime*(ia-1)+j)
          end do
       else
          do j = 1, ndim
             newpt(j) = pintt(ndim*(ia-1001)+j)
          end do
          call reeref(elrefp, nno, geom, newpt, ndim,&
                      pta, ff)
       endif
!
       if (ib.lt.1000) then
          do j = 1, ndime
             ptb(j) = x(ndime*(ib-1)+j)
          end do
       else
          do j = 1, ndim
             newpt(j) = pintt(ndim*(ib-1001)+j)
          end do
          call reeref(elrefp, nno, geom, newpt, ndim,&
                      ptb, ff)
       endif
!
       if (ic.lt.1000) then
          do j = 1, ndime
             ptc(j) = x(ndime*(ic-1)+j)
          end do
       else
          do j = 1, ndim
             newpt(j) = pintt(ndim*(ic-1001)+j)
          end do
          call reeref(elrefp, nno, geom, newpt, ndim,&
                      ptc, ff)
       endif
       call vecini(4*ndime,0.d0, dekker)
       do j = 1, ndime
          bc(j) = ptc(j)-ptb(j)
          ba(j) = pta(j)-ptb(j)
          dekker(j) = pta(j)
          dekker(j+ndime) = ptb(j)
          dekker(j+2*ndime) = ptc(j)
       end do
    endif
!
    do j = 1, ndime
      ip1ip2(j)=pinref(ndime*(ip2-1)+j)-pinref(ndime*(ip1-1)+j)
    enddo
    call xnormv(ndime, bc, rbid)
    call xnormv(ndime, ba, rbid)
    call xnormv(ndime, ip1ip2, rbid)
!   ARETE BC ORTHOGONAL A IP1-IP2 ? A PRIORI NON
!   CE SERAIT PRUDENT DE LE REVERIFIER
!   SI ORTH : BC EST LA NORMALE CHERCHEE
!   SINON : CALCULER LA NORMALE
    k=ddot(ndime,ba,1,bc,1)
    k1=ddot(ndime,ba,1,ip1ip2,1)
    k2=ddot(ndime,bc,1,ip1ip2,1)
    alpha=dsqrt(1/(k1**2+k2**2-2*k*k1*k2))
    do j=1,ndime
        vect(j)=alpha*(k2*ba(j)-k1*bc(j))
    enddo
!
    do j=1,ndime
      ptxx(j)=vect(j)
      ptxx(j+ndime)=(pinref(ndime*(ip1-1)+j)+&
                     pinref(ndime*(ip2-1)+j))/2.d0
    enddo
!     CALCUL DES COORDONNEES DE REFERENCE
!     DU POINT PAR UN ALGO DE NEWTON
!     ON CHOSIST LA METHODE DE NEWTON-DEKKER LORSQUE L'ON EFFECTUE LA
!     RECHERCHE SUR LA FACE D'UN ELEMENT, AFIN DE NE PAS SORTIR DE CETTE FACE
!!!!!ATTENTION INITIALISATION DU NEWTON:
    call vecini(ndime, 0.d0, ksi)
    if ((present(u).and.present(v)) .or. jonc) then
       call xnewto(elrefp, name, n,&
                   ndime, ptxx, ndim, geom, lsn,&
                   ip1, ip2, itemax,&
                   epsmax, ksi)
    else
       call xnewto(elrefp, name, n,&
                   ndime, ptxx, ndim, geom, lsn,&
                   ip1, ip2, itemax,&
                   epsmax, ksi, exit, dekker)
    endif
    do j=1,ndime
       miref(j)=ksi(1)*ptxx(j)+ptxx(j+ndime)
    enddo
!
! --- COORDONNES DU POINT DANS L'ELEMENT REEL
    call reerel(elrefp, nno, ndim, geom, miref,&
                mifis)
!
end subroutine
