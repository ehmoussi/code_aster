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

subroutine i2trgi(t1, t2, n2, pt)
    implicit none
!
!
#include "asterfort/i2rdli.h"
    integer :: t1(*), t2(*), n2, pt
!
!**********************************************************************
!
!  OPERATION REALISEE
!  ------------------
!
!     RANGEMENT DES ELEMENTS DU TABLEAU T2 DE DIMENSION N2 DANS LE
!     TABLEAU T1.
!
!  INVARIANT DE ROUTINE
!  --------------------
!
!     TOUS LES ELEMENTS DE T1 SONT DISTINCTS ET TRIES DANS L' ORDRE
!     CROISSANT ; PT EST L' ADRESSE DE LA PREMIERE CASE LIBRE
!
!**********************************************************************
!
    integer :: i, val
!
    do 10, i = 1, n2, 1
!
    val = t2(i)
!
    call i2rdli(val, t1, pt)
!
    10 end do
!
end subroutine
