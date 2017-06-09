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

subroutine crsmos(nomsto, typroz, neq)
    implicit    none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=*) :: nomsto, typroz
!    BUT: CREER UN STOCKAGE_MORSE POUR UNE MATRICE PLEINE OU DIAGONALE
!
!    DETERMINER LA NUMEROTATION GENERALISEE A PARTIR D'UN MODE_MECA
!    OU D'UN MODE_GENE
!    LA NUMEROTATION SERA PAR DEFAUT PLEINE
!
! IN  JXOUT K19 NOMSTO  : NOM DU STOCKAGE A CREER
! IN        K*  TYPROZ : 'PLEIN' /'DIAG'
! IN        I   NEQ     : DIMENSION DE LA MATRICE
!-----------------------------------------------------------------------
!
!
!
    integer :: i, j, nterm, ico, jsmde, jsmdi, jsmhc, neq
    character(len=19) :: sto19
    character(len=5) :: typrof
!     ------------------------------------------------------------------
!
!
    call jemarq()
    sto19=nomsto
    typrof=typroz
!
    ASSERT(typrof.eq.'PLEIN' .or. typrof.eq.'DIAG')
    if (typrof .eq. 'DIAG') then
        nterm=neq
    else
        nterm=neq*(neq+1)/2
    endif
!
    call wkvect(sto19//'.SMHC', 'G V S', nterm, jsmhc)
    call wkvect(sto19//'.SMDI', 'G V I', neq, jsmdi)
    call wkvect(sto19//'.SMDE', 'G V I', 6, jsmde)
!
!
    zi(jsmde-1+1 ) = neq
    zi(jsmde-1+2) = nterm
    zi(jsmde-1+3) = 1
!
!
    if (typrof .eq. 'DIAG') then
        do 201 i = 1, neq
            zi(jsmdi+i-1) = i
            zi4(jsmhc+i-1) = i
201      continue
    else if (typrof.eq.'PLEIN') then
        ico=0
        do 202 i = 1, neq
            zi(jsmdi+i-1) = i*(i+1)/2
            do 203 j = 1, i
                ico=ico+1
                zi4(jsmhc-1+ico) = j
203          continue
202      continue
    endif
!
    call jedema()
end subroutine
