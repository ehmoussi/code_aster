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

subroutine vecgcy(nomres, numeg)
!
    implicit none
!
!***********************************************************************
!    O. NICOLAS      DATE 12/05/05
!-----------------------------------------------------------------------
!  BUT: INITIALISER UN VECTEUR GENERALISE A ZERO
!
!     CONCEPT CREE: VECT_ASSE_GENE
!
!-----------------------------------------------------------------------
!
!
!
!
!
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
    character(len=8) :: nomres, numeg, modgen
    character(len=19) :: nomnum, nomsto
    integer ::  iavale, iarefe, iadesc, j, neq
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    character(len=24), pointer :: refn(:) => null()
    integer, pointer :: smde(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
!
!     1/ LECTURE ET STOCKAGE DES INFORMATIONS
!     =======================================
    nomnum = numeg//'      .NUME'
    nomsto = numeg//'      .SMOS'
    call jeveuo(nomnum//'.REFN', 'L', vk24=refn)
    modgen=refn(1)(1:8)
!
    call jeveuo(nomsto//'.SMDE', 'L', vi=smde)
    neq=smde(1)
!
    call wkvect(nomres//'           .VALE', 'G V R', neq, iavale)
    call wkvect(nomres//'           .REFE', 'G V K24', 2, iarefe)
    call wkvect(nomres//'           .DESC', 'G V I', 3, iadesc)
    zk24(iarefe) = modgen
    zk24(iarefe+1) = nomnum
    zi(iadesc) = 1
    zi(iadesc+1) = neq
!
    do 60 j = 1, neq
        zr(iavale+j-1) = 0.d0
60  continue
!
!
!
    call jedema()
end subroutine
