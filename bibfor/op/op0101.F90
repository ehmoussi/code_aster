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

subroutine op0101()
    implicit none
!      OPERATEUR :     AFFE_CHAR_CINE
!
!      MOTS-CLES ACTUELLEMENT TRAITES:   MECA_IMPO
!                                        THER_IMPO
!                                        ACOU_IMPO
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/charci.h"
#include "asterfort/getvid.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    integer :: n1, jafck
    character(len=8) :: chcine, mo, pheno, evoim
    character(len=16) :: type, oper
    character(len=19) :: chci19
    aster_logical :: cinef
!
! ======================================================================
! --- DEBUT
!
    call jemarq()
!
    call infmaj()
!
! --- RECUPERATION DU RESULTAT
    call getres(chcine, type, oper)
    chci19=chcine
    ASSERT(type(1:9).eq.'CHAR_CINE')
    pheno=type(11:14)
    cinef=(oper(15:16).eq.'_F')
!
! --- RECUPERATION DU MODELE :
    call getvid(' ', 'MODELE', scal=mo, nbret=n1)
!
! --- CREATION DU .AFCK:
    call wkvect(chci19//'.AFCK', 'G V K8', 3, jafck)
    zk8(jafck-1+2)=mo
!
    if (oper .eq. 'AFFE_CHAR_CINE') then
        call getvid(' ', 'EVOL_IMPO', scal=evoim, nbret=n1)
        if (n1 .eq. 1) zk8(jafck-1+3)=evoim
    endif
!
!
!     REMARQUE :
!      - ON AFFECTE UN 'TYPE' A LA CHARGE CINEMATIQUE (ACFK(2))
!        MAIS ON LE MODIFIE PARFOIS DANS CHARCI.
!        PARFOIS :  '_RE' -> '_FT'  (EVOL_IMPO)
!
    if (pheno .eq. 'MECA') then
        if (.not.cinef) then
            zk8(jafck-1+1)='CIME_RE'
            call charci(chcine, 'MECA_IMPO', mo, 'R')
        else
            zk8(jafck-1+1)='CIME_FT'
            call charci(chcine, 'MECA_IMPO', mo, 'F')
        endif
    else if (pheno.eq.'THER') then
        if (.not.cinef) then
            zk8(jafck-1+1)='CITH_RE'
            call charci(chcine, 'THER_IMPO', mo, 'R')
        else
            zk8(jafck-1+1)='CITH_FT'
            call charci(chcine, 'THER_IMPO', mo, 'F')
        endif
    else if (pheno.eq.'ACOU') then
        ASSERT(.not.cinef)
        zk8(jafck-1+1)='CIAC_CX'
        call charci(chcine, 'ACOU_IMPO', mo, 'C')
    else
        ASSERT(.false.)
    endif
!
!
!
!
    call jedema()
end subroutine
