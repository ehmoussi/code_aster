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
    subroutine gcour2(resu, noma, nomo, nomno, coorn,&
                      nbnoeu, trav1, trav2, trav3, fonoeu, chfond, basfon, &
                      nomfiss, connex, stok4, liss,&
                      nbre, milieu, ndimte, norfon)
        character(len=8)  :: resu
        character(len=8)  :: noma
        character(len=8)  :: nomo
        character(len=24) :: nomno
        character(len=24) :: coorn
        integer           :: nbnoeu
        character(len=24) :: trav1
        character(len=24) :: trav2
        character(len=24) :: trav3
        character(len=24) :: fonoeu
        character(len=24) :: chfond
        character(len=24) :: basfon
        character(len=8)  :: nomfiss
        aster_logical     :: connex
        character(len=24) :: stok4
        character(len=24) :: liss
        integer           :: nbre
        aster_logical     :: milieu
        integer           :: ndimte
        character(len=24) :: norfon
    end subroutine gcour2
end interface
