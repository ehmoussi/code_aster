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

subroutine cbprca(phenom_, load)
!
implicit none
!
#include "asterfort/gettco.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/dismoi.h"
#include "asterfort/lisnnl.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
!
    character(len=*), intent(in) :: phenom_
    character(len=8), intent(in) :: load
!
! --------------------------------------------------------------------------------------------------
!
! Loads affectation
!
! Keyword = 'EVOL_CHAR'
!
! --------------------------------------------------------------------------------------------------
!
! In  phenom       : phenomenon (MECANIQUE/THERMIQUE/ACOUSTIQUE)
! In  load         : name of load
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: object
    character(len=8), pointer :: p_object(:) => null()
    character(len=8) :: evol_char
    integer :: nb_occ, nb_cham
    character(len=16) :: type_sd
    character(len=13) :: obje_pref
!
! --------------------------------------------------------------------------------------------------
!
    call getvid(' ', 'EVOL_CHAR', scal=evol_char, nbret=nb_occ)
    call lisnnl(phenom_, load, obje_pref)
!
    if (nb_occ .ne. 0) then
!
! ----- Check
!
        ASSERT(nb_occ.eq.1)
        call dismoi('NB_CHAMP_UTI', evol_char, 'RESULTAT', repi=nb_cham)
        if (nb_cham .le. 0) then
            call utmess('F', 'CHARGES3_1', sk=evol_char)
        endif
        call gettco(evol_char, type_sd)
        ASSERT(type_sd .eq. 'EVOL_CHAR')
!
! ----- Save
!
        object = obje_pref(1:13)//'.EVOL.CHAR'
        call wkvect(object, 'G V K8', 1, vk8 = p_object)
        p_object(1) = evol_char

    endif

end subroutine
