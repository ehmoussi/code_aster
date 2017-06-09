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
    subroutine caeihm(nomte, axi, perman, mecani, press1,&
                      press2, tempe, dimdef, dimcon, ndim,&
                      nno1, nno2, npi, npg, dimuel,&
                      iw, ivf1, idf1, ivf2, idf2,&
                      jgano1, iu, ip, ipf, iq,&
                      modint)
        character(len=16) :: nomte
        aster_logical :: axi
        aster_logical :: perman
        integer :: mecani(8)
        integer :: press1(9)
        integer :: press2(9)
        integer :: tempe(5)
        integer :: dimdef
        integer :: dimcon
        integer :: ndim
        integer :: nno1
        integer :: nno2
        integer :: npi
        integer :: npg
        integer :: dimuel
        integer :: iw
        integer :: ivf1
        integer :: idf1
        integer :: ivf2
        integer :: idf2
        integer :: jgano1
        integer :: iu(3, 18)
        integer :: ip(2, 9)
        integer :: ipf(2, 2, 9)
        integer :: iq(2, 2, 9)
        character(len=3) :: modint
    end subroutine caeihm
end interface
