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

function zerosd(typesd, sd)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/utmess.h"
#include "asterfort/zerobj.h"
    aster_logical :: zerosd
    character(len=*) :: sd, typesd
! person_in_charge: jacques.pellet at edf.fr
! ----------------------------------------------------------------------
!  BUT : DETERMINER SI UNE SD EST NULLE (OU PAS)
!  IN   TYPESD : TYPE DE  SD
!   LISTE DES POSSIBLES: 'RESUELEM', 'CARTE', 'CHAM_NO', 'CHAM_ELEM'
!       SD     : NOM DE LA SD
!
!     RESULTAT:
!       ZEROSD : .TRUE.    SI LES VALEURS DE LA SD SONT TOUTES NULLES
!                .FALSE.   SINON
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    character(len=19) :: k19
    character(len=16) :: typ2sd
!
! -DEB------------------------------------------------------------------
!
    typ2sd=typesd
!
!
!
    if (typ2sd .eq. 'RESUELEM') then
!     --------------------------------
        k19=sd
        zerosd=zerobj(k19//'.RESL')
!
!
    else if (typ2sd.eq.'CHAM_NO') then
!     --------------------------------
        k19=sd
        zerosd=zerobj(k19//'.VALE')
!
!
    else if (typ2sd.eq.'CARTE') then
!     --------------------------------
        k19=sd
        zerosd=zerobj(k19//'.VALE')
!
!
    else if (typ2sd.eq.'CHAM_ELEM') then
!     --------------------------------
        k19=sd
        zerosd=zerobj(k19//'.CELV')
!
    else
        call utmess('F', 'UTILITAI_47', sk=typ2sd)
    endif
!
end function
