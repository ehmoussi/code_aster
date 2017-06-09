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

subroutine pjma1p(moa1, ma1p, cham1, corres)
! person_in_charge: jacques.pellet at edf.fr
!
! COMMANDE:  PROJ_CHAMP /ECLA_PG
! CREATION DU MAILLAGE 1 PRIME (MA1P)
! REMPLISSAGE DU .PJEF_MP DANS LA SD CORRES
!   QUI EST LE NOM DU MAILLAGE 1 PRIME
!
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
! MOA1 : MODELE1 A ECLATER
! MA1P : EST LE MAILLAGE 1 PRIME
! CORRES : STRUCTURE DE DONNEES CORRES
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/eclpgm.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=8) :: moa1, ma1p
    character(len=19) :: cham1
! ----------------------------------------------------------------------
!
!
    real(kind=8) :: shrink, lonmin
    integer :: jcorre
    character(len=16) :: corres, lisch(1)
    character(len=19) :: ligrel
!
!
    call jemarq()
!
    shrink=1.d0
    lonmin=0.d0
    ASSERT(cham1.ne.' ')
    call dismoi('NOM_LIGREL', cham1, 'CHAM_ELEM', repk=ligrel)
!
    call eclpgm(ma1p, moa1, cham1, ligrel, shrink,&
                lonmin, 0, lisch)
!
    call wkvect(corres//'.PJEF_MP', 'V V K8', 1, jcorre)
    zk8(jcorre+1-1)=ma1p
!
    call jedema()
!
end subroutine
