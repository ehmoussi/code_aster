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

subroutine mdsize(nomres, nbsauv, nbmode, nbnoli)
!
    implicit none
#include "jeveux.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeveuo.h"
    character(len=8) :: nomres
!     DIMINUTION DES OBJETS D'UN TRAN_GENE DE NOM NOMRES
!-----------------------------------------------------------------------
! IN  : NOMRES : NOM DU TRAN_GENE RESULTAT
! IN  : NBSAUV : NOMBRE DE RESULTATS ARCHIVES (SELON ARCHIVAGE DES PAS
!                DE TEMPS).NOUVELLE TAILLE DE NOMRES
! IN  : NBMODE : NOMBRE DE MODES OU D'EQUATIONS GENERALISEES
! IN  : NBNOLI : NOMBRE DE NON LINEARITES LOCALISEES
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: nbsauv, nbmode, nbnoli, nbvint, jdesc, nbstoc
!-----------------------------------------------------------------------
    nbstoc = nbsauv * nbmode
    call jeecra(nomres//'           .DEPL', 'LONUTI', nbstoc)
    call jeecra(nomres//'           .VITE', 'LONUTI', nbstoc)
    call jeecra(nomres//'           .ACCE', 'LONUTI', nbstoc)
    call jeecra(nomres//'           .ORDR', 'LONUTI', nbsauv)
    call jeecra(nomres//'           .DISC', 'LONUTI', nbsauv)
    call jeecra(nomres//'           .PTEM', 'LONUTI', nbsauv)
!
    if (nbnoli .gt. 0) then
        call jeveuo(nomres//'           .DESC', 'L', jdesc)
        nbvint = zi(jdesc+3)
        nbstoc = nbvint * nbsauv
        call jeecra(nomres//'        .NL.VINT', 'LONUTI', nbstoc)
    endif

end subroutine
