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
    subroutine mpinvc(nbmesu, nbmode, nbabs, phi, cmesu,&
                      coef, xabs, lfonct, ceta, cetap,&
                      ceta2p)
        integer :: nbabs
        integer :: nbmode
        integer :: nbmesu
        real(kind=8) :: phi(nbmesu, nbmode)
        complex(kind=8) :: cmesu(nbmesu, nbabs)
        real(kind=8) :: coef(*)
        real(kind=8) :: xabs(nbabs)
        aster_logical :: lfonct
        complex(kind=8) :: ceta(nbmode, nbabs)
        complex(kind=8) :: cetap(nbmode, nbabs)
        complex(kind=8) :: ceta2p(nbmode, nbabs)
    end subroutine mpinvc
end interface
