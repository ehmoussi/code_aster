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

subroutine mefsma(matm, mata, matr, nugene, masgen,&
                  amogen, riggen)
    implicit   none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mefsm1.h"
    real(kind=8) :: matm(*), mata(*), matr(*)
    character(len=19) :: masgen, amogen, riggen
!
    integer ::   nbmode, nterm, nbloc
    character(len=1) :: base
    character(len=14) :: nugene
    character(len=19) :: nomnum, nomsto
    character(len=24), pointer :: refn(:) => null()
    integer, pointer :: scde(:) => null()
! DEB------------------------------------------------------------------
!
    call jemarq()
!
    nomnum = nugene//'.NUME'
    nomsto = nugene//'.SLCS'
!
    call jeveuo(nomsto//'.SCDE', 'L', vi=scde)
    nbmode = scde(1)
    nterm = scde(2)
    nbloc = scde(3)
!
    call jeveuo(nomnum//'.REFN', 'L', vk24=refn)
    base = refn(1)
!
    call mefsm1(matm, masgen, base, nomnum, nomsto,&
                nbmode, nbloc, nterm)
!
    call mefsm1(mata, amogen, base, nomnum, nomsto,&
                nbmode, nbloc, nterm)
!
    call mefsm1(matr, riggen, base, nomnum, nomsto,&
                nbmode, nbloc, nterm)
!
    call jedema()
!
end subroutine
