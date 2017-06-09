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
#include "asterf_types.h"
!
interface
    subroutine assma3(lmasym, lmesym, tt, igr, iel,&
                      c1, rang, jnueq, jnumsd, jresl,&
                      nbvel, nnoe, ldist, ldgrel,&
                      ilima, jadli, jadne, jprn1, jprn2,&
                      jnulo1, jposd1, admodl,&
                      lcmodl, mode, nec, nmxcmp, ncmp,&
                      jsmhc, jsmdi, iconx1, iconx2, jtmp2,&
                      lgtmp2, jvalm, ilinu, ellagr)
        aster_logical :: lmasym
        aster_logical :: lmesym
        character(len=2) :: tt
        integer :: igr
        integer :: iel
        real(kind=8) :: c1
        integer :: rang
        integer :: jnueq
        integer :: jnumsd
        integer :: jresl
        integer :: nbvel
        integer :: nnoe
        aster_logical :: ldist
        aster_logical :: ldgrel
        integer :: ilima
        integer :: jadli
        integer :: jadne
        integer :: jprn1
        integer :: jprn2
        integer :: jnulo1
        integer :: jposd1
        integer :: admodl
        integer :: lcmodl
        integer :: mode
        integer :: nec
        integer :: nmxcmp
        integer :: ncmp
        integer :: jsmhc
        integer :: jsmdi
        integer :: iconx1
        integer :: iconx2
        integer :: jtmp2
        integer :: lgtmp2
        integer :: jvalm(2)
        integer :: ilinu
        integer :: ellagr
    end subroutine assma3
end interface
