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

function idensd(typesd, sd1, sd2)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/idenob.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    aster_logical :: idensd
    character(len=*) :: sd1, sd2, typesd
! person_in_charge: jacques.pellet at edf.fr
! ----------------------------------------------------------------------
!  BUT : DETERMINER L'IDENTITE DE 2 SD D'ASTER.
!  IN   TYPESD : TYPE DE  SD1 ET SD2
!               'PROF_CHNO'
!       SD1   : NOM DE LA 1ERE SD
!       SD2   : NOM DE LA 2EME SD
!
!     RESULTAT:
!       IDENSD : .TRUE.    SI SD1 == SD2
!                .FALSE.   SINON
! ----------------------------------------------------------------------
    aster_logical :: iden
    character(len=16) :: typ2sd
    character(len=19) :: pchn1, pchn2
! ----------------------------------------------------------------------
    call jemarq()
    typ2sd = typesd
    idensd=.true.
!
    if (sd1 .eq. sd2) goto 999
!
!
    if (typ2sd .eq. 'PROF_CHNO') then
!     --------------------------------
        pchn1=sd1
        pchn2=sd2
        iden=idenob(pchn1//'.LILI',pchn2//'.LILI')
        if (.not.iden) goto 998
        iden=idenob(pchn1//'.PRNO',pchn2//'.PRNO')
        if (.not.iden) goto 998
        iden=idenob(pchn1//'.DEEQ',pchn2//'.DEEQ')
        if (.not.iden) goto 998
        iden=idenob(pchn1//'.NUEQ',pchn2//'.NUEQ')
        if (.not.iden) goto 998
!
!
    else
        call utmess('F', 'UTILITAI_47', sk=typ2sd)
    endif
!
    goto 999
998 continue
    idensd=.false.
!
999 continue
    call jedema()
end function
