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

!
!
#include "asterf_types.h"
!
interface
    subroutine brendo(sige6, bt6, sut, bc1, suc,&
                      local, t33, n33, lct, bw,&
                      pw, bch, pch, delta, lcc,&
                      mt, mc, siget6, sigec6, nu,&
                      dt66, dc0, sut6, suc1, siga6,&
                      dt6)
        real(kind=8) :: sige6(6)
        real(kind=8) :: bt6(6)
        real(kind=8) :: sut
        real(kind=8) :: bc1
        real(kind=8) :: suc
        aster_logical :: local
        real(kind=8) :: t33(3, 3)
        real(kind=8) :: n33(3, 3)
        real(kind=8) :: lct
        real(kind=8) :: bw
        real(kind=8) :: pw
        real(kind=8) :: bch
        real(kind=8) :: pch
        real(kind=8) :: delta
        real(kind=8) :: lcc
        real(kind=8) :: mt
        real(kind=8) :: mc
        real(kind=8) :: siget6(6)
        real(kind=8) :: sigec6(6)
        real(kind=8) :: nu
        real(kind=8) :: dt66(6, 6)
        real(kind=8) :: dc0
        real(kind=8) :: sut6(6)
        real(kind=8) :: suc1
        real(kind=8) :: siga6(6)
        real(kind=8) :: dt6(6)
    end subroutine brendo
end interface
