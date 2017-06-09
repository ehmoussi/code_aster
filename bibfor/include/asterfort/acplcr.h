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
     subroutine acplcr(nbvec,jvectn, jvectu, jvectv, nbordr,&
                  kwork, sompgw, jrwork, tspaq, ipg, dectau,nommet, &
                  jvecpg, jnorma,rayon,jresun, jdtaum,jtauma,&
                  jsgnma, jdsgma )
        integer :: nbvec
        integer :: jvectn
        integer :: jvectu
        integer :: jvectv
        integer :: nbordr
        integer :: kwork
        integer :: sompgw
        integer :: jrwork
        integer :: tspaq
        integer :: ipg
        integer :: dectau
        character(len=16) :: nommet
        integer :: jvecpg
        integer :: jnorma
        aster_logical :: rayon
        integer :: jresun
        integer :: jdtaum
        integer :: jtauma
        integer :: jsgnma
        integer :: jdsgma
    end subroutine acplcr
end interface
