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

subroutine rvrepn(mailla, nlsnac, repere, sdnewr)
    implicit none
!
!
#include "jeveux.h"
!
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/rvrlln.h"
    character(len=24) :: nlsnac
    character(len=19) :: sdnewr
    character(len=8) :: mailla, repere
!
!***********************************************************************
!
!  OPERATION REALISEE
!  ------------------
!
!     CALCUL  DU REPERE LOCAL OU POLAIRE LA LONG D' UNE LISTE DE NOEUDS
!
!  ARGUMENTS EN ENTREE
!  -------------------
!
!     REPERE : VAUT 'LOCAL' OU 'POLAIRE'
!     COURBE : NOM DE LISTE DE NOEUDS
!     MAILLA : NOM DU MAILLAGE
!
!  ARGUMENTS EN SORTIE
!  -------------------
!
!     SDNEWR : NOM DE LA SD DU NOUVEAU REPERE
!              (DOC. C.F. RVCHGR)
!
!***********************************************************************
!
!  -----------------------------------------
!
!
!
!  ---------------------------------
!
!  VARIABLES LOCALES
!  -----------------
!
    integer ::  avec1, avec2, nbn, alsnac
    real(kind=8), pointer :: vale(:) => null()
!
!====================== CORPS DE LA ROUTINE ===========================
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    call jelira(nlsnac, 'LONMAX', nbn)
    call jeveuo(nlsnac, 'L', alsnac)
!
    call jeveuo(mailla//'.COORDO    .VALE', 'L', vr=vale)
!
    call jecrec(sdnewr//'.VEC1', 'V V R', 'NU', 'DISPERSE', 'VARIABLE',&
                1)
    call jecrec(sdnewr//'.VEC2', 'V V R', 'NU', 'DISPERSE', 'VARIABLE',&
                1)
    call jecroc(jexnum(sdnewr//'.VEC1', 1))
    call jecroc(jexnum(sdnewr//'.VEC2', 1))
    call jeecra(jexnum(sdnewr//'.VEC1', 1), 'LONMAX', 2*nbn)
    call jeecra(jexnum(sdnewr//'.VEC2', 1), 'LONMAX', 2*nbn)
    call jeveuo(jexnum(sdnewr//'.VEC1', 1), 'E', avec1)
    call jeveuo(jexnum(sdnewr//'.VEC2', 1), 'E', avec2)
!
    call rvrlln(vale, zi(alsnac), nbn, repere, zr(avec1),&
                zr(avec2))
!
    call jedema()
end subroutine
