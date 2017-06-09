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

subroutine rcma02(etat, iocc, vale)
    implicit   none
#include "jeveux.h"
#include "asterfort/jeveuo.h"
    integer :: iocc
    real(kind=8) :: vale(*)
    character(len=1) :: etat
!     RECUPERATION DES CARACTERISTIQUES MATERIAU POUR UN ETAT
!
! IN  : ETAT   : ETAT STABILISE "A" OU "B"
! IN  : IOCC   : NUMERO D'OCCURRENCE DE LA SITUATION
! OUT : VALE   : CARACTERISTIQUES MATERIAU
!                VALE(1) = E
!                VALE(2) = NU
!                VALE(3) = ALPHA
!                VALE(4) = EC
!                VALE(5) = SM
!                VALE(6) = M
!                VALE(7) = N
!     ------------------------------------------------------------------
!
    integer :: nbcmp, i, jvale
    parameter   ( nbcmp = 7 )
! DEB ------------------------------------------------------------------
!
! --- LES CARACTERISTIQUES MATERIAU
!
    call jeveuo('&&RC3200.MATERIAU_'//etat, 'L', jvale)
!
    do 10 i = 1, nbcmp
        vale(i) = zr(jvale-1+nbcmp*(iocc-1)+i)
10  continue
!
end subroutine
