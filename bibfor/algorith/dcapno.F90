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

subroutine dcapno(resuz, typchz, iord, chavaz)
!    P. RICHARD     DATE 28/03/91
!-----------------------------------------------------------------------
!  BUT:  RECUPERER L'ADRESSE D'UN .VALE D'UN CHAMNO A PARTIR DE SON
!  TYPE ET DE NUMERO D'ORDRE DANS UN RESULTAT COMPOSE
    implicit none
!
!-----------------------------------------------------------------------
!
! RESUZ    /I/: NOM DU RESULTAT COMPOSE
! TYPCHZ   /I/: TYPE DU CHAMPS
! IORD     /I/: NUMERO D'ORDRE DU CHAMNO DANS CONCEPT RESULTAT
! CHAVAZ   /0/: NOM K24 DE L'OBJET JEVEUX DEMANDE
!
!
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
    character(len=*) :: chavaz
    character(len=*) :: resuz, typchz
!
!
!
    character(len=8) :: resu, typch
    character(len=19) :: chacou
    character(len=24) :: chaval
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: iad, ier, iord
!-----------------------------------------------------------------------
    call jemarq()
    chaval = chavaz
    resu = resuz
    typch = typchz
    call rsexch('F', resu, typch, iord, chacou,&
                ier)
!
    chaval = chacou//'.VALE'
    call jeveuo(chaval, 'L', iad)
!
    chavaz = chaval
    goto 9999
!
9999  continue
    call jedema()
end subroutine
