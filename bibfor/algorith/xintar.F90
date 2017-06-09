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

subroutine xintar(lsna, lsnb, lsnm, a, b,&
                  m, ndim, intar)
    implicit none
!
#include "jeveux.h"
#include "asterfort/reerel.h"
#include "asterfort/vecini.h"
#include "asterfort/xnewto.h"
    integer :: ndim
    real(kind=8) :: lsna, lsnb, lsnm, a(3), b(3), m(3), intar(3)
!
!                      TROUVER LE PT D'INTERSECTION ENTRE L'ARETE
!                      ET LA FISSURE
!
!     ENTREE
!       LSNA    :VALEURS DES LEVELSET DES NOEUDS DE L'ELEMENT
!       LSNB    :VALEURS DES LEVELSET DES NOEUDS DE L'ELEMENT
!       LSNC    :VALEURS DES LEVELSET DES NOEUDS DE L'ELEMENT
!       A       :COORDONNEES DES NOEUDS DE L'ELEMENT
!       B       :COORDONNEES DES NOEUDS DE L'ELEMENT
!       M       :COORDONNEES DES NOEUDS DE L'ELEMENT
!       NDIM    :DIMENSION TOPOLOGIQUE DU MAILLAGE
!     SORTIE
!       INTAR   : COORDONNEES DES POINTS D'INTERSECTION
!     ----------------------------------------------------------------
!
    character(len=8) :: elp
    character(len=6) :: name
    real(kind=8) :: lsnl(3), col(ndim*3)
    real(kind=8) :: epsmax, rbid, xe(ndim)
    integer :: nno, itemax, i, ibid, n(3)
    parameter       (elp='SE3')
!
!---------------------------------------------------------------------
!     DEBUT
!---------------------------------------------------------------------
!
    itemax=500
    epsmax=1.d-9
    name='XINTAR'
    nno=3
!
    lsnl(1)=lsna
    lsnl(2)=lsnb
    lsnl(3)=lsnm
!
    do 100 i = 1, ndim
        col(i)=a(i)
        col(ndim+i)=b(i)
        col(ndim*2+i)=m(i)
100  end do
!
    rbid = 0.d0
    call vecini(ndim, 0.d0, xe)
    call xnewto(elp, name, n,&
                ndim, [rbid], ndim, [rbid], lsnl,&
                ibid, ibid, itemax,&
                epsmax, xe)
    call reerel(elp, nno, ndim, col, xe,&
                intar)
!
!---------------------------------------------------------------------
!     FIN
!---------------------------------------------------------------------
end subroutine
