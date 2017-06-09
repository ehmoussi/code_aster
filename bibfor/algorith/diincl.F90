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

function diincl(sddisc, nomchz, force)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    aster_logical :: diincl
    character(len=19) :: sddisc
    character(len=*) :: nomchz
    aster_logical :: force
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE - DISCRETISATION)
!
! INDIQUE S'IL FAUT ARCHIVER UN CHAMP
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION
! IN  NOMCHA : NOM DU CHAMP
! IN  FORCE  : INDIQUE SI ON FORCE L'ARCHIVAGE POUR LES CHAMPS EXCLUS
! OUT DIINCL : VRAI SI LE CHAMP DOIT ETRE SAUVE
!
!
!
!
    integer :: iret, nb, i
    character(len=16) :: nomcha
    character(len=19) :: sdarch
    character(len=24) :: arcexc
    integer :: jarexc
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    nomcha = nomchz
!
! --- ACCES SD ARCHIVAGE
!
    sdarch = sddisc(1:14)//'.ARCH'
    arcexc = sdarch(1:19)//'.AEXC'
!
! --- AUCUN CHAMP N'EST EXCLU
!
    call jeexin(arcexc, iret)
    if (iret .eq. 0) then
        diincl = .true.
        goto 9999
    endif
!
! --- LE CHAMP EST-IL EXCLU ?
!
    diincl = .false.
    call jeveuo(arcexc, 'L', jarexc)
    call jelira(arcexc, 'LONMAX', nb)
    do 10 i = 1, nb
        if (nomcha .eq. zk16(jarexc-1 + i)) then
            diincl = .false.
            goto 999
        endif
 10 end do
    diincl = .true.
!
999 continue
!
! --- ON STOCKE LES CHAMPS EXCLUS SI ON FORCE L'ARCHIVAGE
!
    if (force) then
        diincl = .true.
    endif
!
9999 continue
!
    call jedema()
end function
