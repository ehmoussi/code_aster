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

subroutine tresu_print_all(refer, legend, llab, typres, nbref,&
                           rela, tole, ssigne, refr, valr,&
                           refi, vali, refc, valc, ignore,&
                           compare)
    implicit none
!
!
! person_in_charge: mathieu.courtois at edf.fr
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/tresu_print.h"
!
    character(len=16), intent(in) :: refer
    character(len=16), intent(in) :: legend
    aster_logical, intent(in) :: llab
    character(len=*), intent(in) :: typres
    integer, intent(in) :: nbref
    character(len=*), intent(in) :: rela
    real(kind=8), intent(in) :: tole
    character(len=*), intent(in) :: ssigne
    real(kind=8), intent(in) :: refr(nbref)
    real(kind=8), intent(in) :: valr
    integer, intent(in) :: refi(nbref)
    integer, intent(in) :: vali
    complex(kind=8), intent(in) :: refc(nbref)
    complex(kind=8), intent(in) :: valc
    aster_logical, intent(in), optional :: ignore
    real(kind=8), intent(in), optional :: compare
!
!   Pour faciliter la transition à tresu_print
!   On prend tous les types et on trie.
!
!
    real(kind=8) :: arg_cmp
    aster_logical :: skip
    character(len=1) :: typ
!
    skip = .false.
    if (present(ignore)) then
        skip = ignore
    endif
!
    arg_cmp = 1.d0
    if (present(compare)) then
        arg_cmp = compare
    endif
!
    typ = typres(1:1)
!
    select case (typ)
        case ('I')
        call tresu_print(refer, legend, llab, nbref, rela,&
                         tole, ssigne, refi=refi, vali=vali, ignore=skip,&
                         compare=arg_cmp)
        case ('R')
        call tresu_print(refer, legend, llab, nbref, rela,&
                         tole, ssigne, refr=refr, valr=valr, ignore=skip,&
                         compare=arg_cmp)
        case ('C')
        call tresu_print(refer, legend, llab, nbref, rela,&
                         tole, ssigne, refc=refc, valc=valc, ignore=skip,&
                         compare=arg_cmp)
    case default
        ASSERT(typ.eq.'I' .or. typ.eq.'R' .or. typ.eq.'C')
    end select
!
end subroutine tresu_print_all
