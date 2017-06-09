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

subroutine vpshif(lmatk, valshi, lmatm, lmatsh)
    implicit none
#include "jeveux.h"
#include "asterfort/mtcmbl.h"
    real(kind=8) :: valshi
    integer :: lmatk, lmatm, lmatsh
!     EFFECTUE LE DECCALAGE SPECTRALE :
!                  MSH =  K - W * M  (W ETANT LE SHIFT)
!     ------------------------------------------------------------------
! IN  LMATK  : IS : ADRESSE ATTRIBUT MATRICE K
! IN  VALSHI : R8 : VALEUR DU DECALAGE
! IN  LMATM  : IS : ADRESSE ATTRIBUT MATRICE M
! IN  LMATSH : IS : ADRESSE ATTRIBUT MATRICE SHIFTEE
!     ------------------------------------------------------------------
!
!
    real(kind=8) :: coef(2)
    character(len=1) :: typcst(2)
    character(len=8) :: nomddl
    character(len=24) :: nmat(2), nmatsh
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: nbcmb
!-----------------------------------------------------------------------
    data typcst/'R', 'R'/
    data nomddl /'        '/
!     ------------------------------------------------------------------
!
!     --- DECALAGE SPECTRAL  K - W * M    (W ETANT LE SHIFT) ---
    coef(1) = 1.d0
    coef(2) = -valshi
    nmat (1) = zk24(zi(lmatk+1))
    nmat (2) = zk24(zi(lmatm+1))
    nmatsh=zk24(zi(lmatsh+1))
    nbcmb = 2
    call mtcmbl(nbcmb, typcst, coef, nmat, nmatsh,&
                nomddl, ' ', 'ELIM=')
end subroutine
