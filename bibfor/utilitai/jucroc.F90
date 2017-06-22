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

subroutine jucroc(nomc, nooc, nuoc, dim, ldec)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jecroc.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
    character(len=*) :: nomc, nooc
    integer :: nuoc, dim, ldec
!     CREATION D'UN OBJET DE COLLECTION
!     ------------------------------------------------------------------
! IN  NOMC  : CH*24 : NOM (COMPLET)  DE LA COLLECTION
! IN  NOOC  : CH*8  : NOM  DE L'OBJET (SI NUM <=0)
! IN  NUOC  : IS    : OU NUM  DE L'OBJET (>0)
! IN  DIM   : IS    : TAILLE DE L'OBJET
! OUT LDEC  : IS    : DECALAGE
!     ------------------------------------------------------------------
    character(len=32) :: nom
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (nuoc .gt. 0) then
        nom = jexnum(nomc,nuoc)
    else
        nom = jexnom(nomc,nooc)
    endif
    call jecroc(nom)
    call jeecra(nom, 'LONMAX', dim)
    call jeecra(nom, 'LONUTI', dim)
    call jeveuo(nom, 'E', ldec)
end subroutine
