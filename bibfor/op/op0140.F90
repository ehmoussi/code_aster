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

subroutine op0140()
    implicit none
!
!***********************************************************************
!    T. KERBER      DATE 12/05/93
!-----------------------------------------------------------------------
!  BUT: ASSEMBLER UN VECTEUR ISSU D'UN MODELE GENERALISE
!
!     CONCEPT CREE: VECT_ASSE_GENE
!
!-----------------------------------------------------------------------
!
!
!
!
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/vecgcy.h"
#include "asterfort/vecgen.h"
    character(len=8) :: nomres, numeg
    character(len=9) :: method
    character(len=16) :: nomcon, nomope
    character(len=24) :: seliai
    integer :: ibid, iopt, elim
!
!-----------------------------------------------------------------------
!
!-------PHASE DE VERIFICATION-------------------------------------------
!
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    call infmaj()
!
    call getres(nomres, nomcon, nomope)
!
    call getvid(' ', 'NUME_DDL_GENE', scal=numeg, nbret=ibid)
!
    call getvtx(' ', 'METHODE', scal=method, nbret=iopt)
!
    elim=0
    seliai=numeg(1:8)//'      .ELIM.BASE'
    call jeexin(seliai, elim)
!
!
    if (method .eq. 'CLASSIQUE') then
        call vecgen(nomres, numeg)
    else if (elim .ne. 0) then
        call vecgen(nomres, numeg)
    else
        call vecgcy(nomres, numeg)
    endif
    call jeecra(nomres//'           .DESC', 'DOCU', cval='VGEN')
!
    call jedema()
end subroutine
