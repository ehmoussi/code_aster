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

subroutine nmttch(result, inst, nume)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/rslipa.h"
#include "asterfort/utacli.h"
#include "asterfort/utmess.h"
    real(kind=8) :: inst
    integer :: nume
    character(len=8) :: result
!
! ----------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (UTILITAIRE - SELEC. INST.)
!
! RECHERCHE DE L'INDICE DANS LA SD RESULTAT JUSTE AVANT L'INSTANT
! DONNE
!
! ----------------------------------------------------------------------
!
!
! IN  RESULT : NOM DE LA SD RESULTAT
! IN  INST   : INSTANT A RECHERCHER
! OUT NUME   : INDICE A ECRASER
!
!
!
!
    character(len=24) :: nomobj
    integer :: jtemps
    integer :: nbinst, i, nbintv
    real(kind=8) :: tole
    real(kind=8) :: dtmin, ins, dt
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD_DISC
!
    tole = r8prem()
    nomobj = '&&NMTTCH.LISTE'
    call rslipa(result, 'INST', nomobj, jtemps, nbinst)
!
! --- RECHERCHE INSTANT
!
    call utacli(inst, zr(jtemps), nbinst, tole, nume)
    nbintv = nbinst - 1
!
! --- SI INST NON PRESENT DANS LA LISTE D INSTANT
! --- ON CHERCHE L INSTANT LE PLUS PROCHE AVANT L'INSTANT CHERCHE
!
    if (nume .lt. 0) then
        dtmin = inst-zr(jtemps)
        ins = zr(jtemps)
        do 40 i = 1, nbintv
            dt = inst-zr(jtemps+i)
            if (dt .le. 0.d0) then
                goto 45
            endif
            if (dt .lt. dtmin) then
                dtmin = dt
                ins = zr(jtemps+i)
            endif
40      continue
45      continue
        inst = ins
        call utacli(inst, zr(jtemps), nbinst, tole, nume)
        nume = nume + 1
    endif
!
    if (nume .lt. 0) then
        call utmess('F', 'DISCRETISATION_89')
    endif
!
    call jedetr(nomobj)
!
    call jedema()
!
end subroutine
