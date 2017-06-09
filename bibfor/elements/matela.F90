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

subroutine matela(icodma, materi, itemp, temp, e,&
                  nu)
    implicit none
#include "asterfort/rcvalb.h"
    real(kind=8) :: temp, e, nu
    integer :: icodma, itemp
    character(len=*) :: materi
!
!     RECUPERATION DES VALEURS DE E, NU
!     FONCTION EVENTUELLEMENT DE LA TEMPERATURE TEMP
!     COMPORTEMENT : 'ELAS'
!     ------------------------------------------------------------------
! IN  ICODMA : IS  : ADRESSE DU MATERIAU CODE
! IN  ITEMP  : IS  : =0 : PAS DE TEMPERATURE
! IN  TEMP   : R8  : VALEUR DE LA TEMPERATURE
!
! OUT E      : R8  : MODULE D'YOUNG
! OUT NU     : R8  : COEFFICIENT DE POISSON
!
    integer :: nbres, nbpar, i
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    parameter    (nbres=2)
    real(kind=8) :: valpar, valres(nbres)
    integer :: codres(nbres)
    character(len=8) :: nompar
    character(len=16) :: nomres(nbres)
    data nomres / 'E', 'NU'/
!
    do 10 i = 1, nbres
        valres(i) = 0.d0
10  end do
    if (itemp .eq. 0) then
        nbpar = 0
        nompar = ' '
        valpar = 0.d0
    else
        nbpar = 1
        nompar = 'TEMP'
        valpar = temp
    endif
    call rcvalb('RIGI', 1, 1, '+', icodma,&
                materi, 'ELAS', nbpar, nompar, [valpar],&
                2, nomres, valres, codres, 1)
    e = valres(1)
    nu = valres(2)
end subroutine
