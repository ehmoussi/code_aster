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

subroutine mm2onf(ndim, nno, alias, ksi1, ksi2,&
                  ddff)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/assert.h"
#include "asterfort/elrfd2.h"
    character(len=8) :: alias
    real(kind=8) :: ksi1, ksi2
    real(kind=8) :: ddff(3, 9)
    integer :: nno, ndim
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
!
! CALCUL DES DERIVEES SECONDES DES FONCTIONS DE FORME EN UN POINT
! DE L'ELEMENT DE REFERENCE
!
! ----------------------------------------------------------------------
!
! IN  ALIAS  : NOM D'ALIAS DE L'ELEMENT
! IN  NNO    : NOMBRE DE NOEUD DE L'ELEMENT
! IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
! IN  KSI1   : POINT DE CONTACT SUIVANT KSI1 DES
!               FONCTIONS DE FORME ET LEURS DERIVEES
! IN  KSI2   : POINT DE CONTACT SUIVANT KSI2 DES
!               FONCTIONS DE FORME ET LEURS DERIVEES
! OUT DDFF   : DERIVEES SECONDES DES FONCTIONS DE FORME EN XI YI
!
! ----------------------------------------------------------------------
!
    integer :: ibid1, ibid2, i
    real(kind=8) :: ksi(2)
    real(kind=8) :: d2ff(3, 3, 9)
    character(len=8) :: elrefe
!
! ----------------------------------------------------------------------
!
!
! --- INITIALISATIONS
!
    do 10 i = 1, 9
        ddff(1,i) = 0.d0
        ddff(2,i) = 0.d0
        ddff(3,i) = 0.d0
        d2ff(1,1,i) = 0.d0
        d2ff(1,2,i) = 0.d0
        d2ff(1,3,i) = 0.d0
        d2ff(2,1,i) = 0.d0
        d2ff(2,2,i) = 0.d0
        d2ff(2,3,i) = 0.d0
        d2ff(3,1,i) = 0.d0
        d2ff(3,2,i) = 0.d0
        d2ff(3,3,i) = 0.d0
10  end do
!
    ksi(1) = ksi1
    ksi(2) = ksi2
!
    elrefe = alias
!
    if ((nno.lt.1) .or. (nno.gt.9)) then
        ASSERT(.false.)
    endif
!
    if ((ndim.lt.1) .or. (ndim.gt.3)) then
        ASSERT(.false.)
    endif
!
! --- RECUP DERIVEES SECONDES DES FONCTIONS DE FORME
!
    call elrfd2(elrefe, ksi, nno*ndim*ndim, d2ff, ibid1,&
                ibid2)
!
! --- CONVERSION XI-YI/YI-XI -> KSI1-KSI2
!
    do 16 i = 1, nno
        ddff(1,i) = d2ff(1,1,i)
        ddff(2,i) = d2ff(2,2,i)
        ddff(3,i) = d2ff(1,2,i)
16  end do
!
end subroutine
