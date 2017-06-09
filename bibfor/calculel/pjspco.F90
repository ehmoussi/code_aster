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

subroutine pjspco(moa1, moa2, corres, base, noca, &
                  method, isole )
!
!
! --------------------------------------------------------------------------------------------------
!
!   Commande :  PROJ_CHAMP /  METHOD = SOUS_POINT_MATER | SOUS_POINT_RIGI
!
!       Calculer la structure de donnee corresp_2_mailla
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "asterf_types.h"
!
    aster_logical :: isole
    character(len=1) :: base
    character(len=8) :: moa1, moa2, noca, masp
    character(len=16) :: corres
    character(len=19) :: method
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/pjefco.h"
#include "asterfort/pjmasp.h"
#include "asterfort/pjrisp.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    ASSERT(base.eq.'V')
!
!   Création du maillage "sous-point" (masp) et remplissage du .PJEF_SP dans la sd corres
!   qui est un tableau référencant, pour chaque noeud du maillage :
!       les numéros de maille des points de gauss
!       les numéros de maille des sous-points
!   auxquels il correspond dans moa2
!
! --------------------------------------------------------------------------------------------------
!
    if ( .not.isole .and. (method.eq.'SOUS_POINT_RIGI') ) then
        call utmess('F', 'CALCULEL5_28')
    endif
    masp='&&PJSPCO'
    if ( method.eq.'SOUS_POINT_MATER' ) then
        call pjmasp(moa2, masp, corres, noca)
    else if ( method.eq.'SOUS_POINT_RIGI' ) then
        call pjrisp(moa2, masp, corres, noca)
    else
        ASSERT( .false. )
    endif
!
!   Appel à la routine "usuelle" pjefco
    call pjefco(moa1, masp, corres, 'V')
    call jedema()
end subroutine
