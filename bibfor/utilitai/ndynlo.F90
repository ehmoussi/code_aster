! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
function ndynlo(sddyna, chainz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynin.h"
!
aster_logical :: ndynlo
character(len=19) :: sddyna
character(len=*) :: chainz
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE)
!
! INTERROGE SDDYNA POUR RENVOYER UN BOOLEEN
!
! ----------------------------------------------------------------------
!
!
! OUT NDYNLO : TRUE SI <CHAINE> FAIT PARTIE DES PROPRIETES DE LA SD
!               FALSE SINON
! IN  SDDYNA : NOM DE LA SD DEDIEE A LA DYNAMIQUE
! IN  CHAINE : PROPRIETE EVENTUELLE DE LA SD DYNAC

    character(len=24) :: chaine
    character(len=16) :: typsch
    character(len=24) :: typesch
    character(len=16), pointer :: v_typesch(:) => null()
    character(len=24) :: infosd
    aster_logical, pointer :: v_infosd(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    ndynlo = ASTER_FALSE
    chaine = chainz
!
! --- ACCES OBJET PRINCIPAL SDDYNA
!
    if (sddyna .eq. ' ') then
        if (chaine .eq. 'STATIQUE') then
            ndynlo = ASTER_TRUE
        else
            ndynlo = ASTER_FALSE
        endif
        goto 999
    else
        typesch = sddyna(1:15)//'.TYPE_SCH'
        call jeveuo(typesch, 'L', vk16 = v_typesch)
    endif
    typsch = v_typesch(1)
!
    if (typsch .eq. 'STATIQUE') then
        if (chaine .eq. 'STATIQUE') then
            ndynlo = ASTER_TRUE
        else
            ndynlo = ASTER_FALSE
        endif
        goto 999
    else
        if (chaine  .eq. 'DYNAMIQUE') then
            ndynlo = ASTER_TRUE
            goto 999
        endif
    endif
!
    infosd = sddyna(1:15)//'.INFO_SD'
    call jeveuo(infosd, 'L', vl = v_infosd)
!
    if (chaine .eq. 'STATIQUE') then
        ndynlo = ASTER_FALSE
    else if (chaine .eq. 'DIFF_CENT') then
        if (v_typesch(7) .eq. 'DIFF_CENTREE') then
            ndynlo = ASTER_TRUE
        endif
    else if (chaine .eq. 'TCHAMWA') then
        if (v_typesch(8) .eq. 'TCHAMWA') then
            ndynlo = ASTER_TRUE
        endif
    else if (chaine .eq. 'NEWMARK') then
        if (v_typesch(2) .eq. 'NEWMARK') then
            ndynlo = ASTER_TRUE
        endif
    else if (chaine .eq. 'FAMILLE_NEWMARK') then
        if ((v_typesch(2) .eq. 'NEWMARK') .or.&
            (v_typesch(7) .eq. 'DIFF_CENTREE') .or.&
            (v_typesch(8) .eq. 'TCHAMWA') .or.&
            (v_typesch(5) .eq. 'HHT_COMPLET') .or. (v_typesch(3)(1:3).eq.'HHT')) then
            ndynlo = ASTER_TRUE
        else
            ndynlo = ASTER_FALSE
        endif
    else if (chaine .eq. 'HHT_COMPLET') then
        if (v_typesch(5) .eq. 'HHT_COMPLET') then
            ndynlo = ASTER_TRUE
        endif
    else if (chaine .eq. 'HHT') then
        if (v_typesch(3)(1:3) .eq. 'HHT') then
            ndynlo = ASTER_TRUE
        endif
    else if (chaine .eq. 'IMPLICITE') then
        if (v_typesch(2) .eq. 'NEWMARK' .or. &
            v_typesch(5) .eq. 'HHT_COMPLET' .or.&
            v_typesch(3)(1:3) .eq. 'HHT') then
            ndynlo = ASTER_TRUE
        endif
    else if (chaine .eq. 'EXPLICITE') then
        if (v_typesch(7) .eq. 'DIFF_CENTREE' .or. v_typesch(8) .eq. 'TCHAMWA') then
            ndynlo = ASTER_TRUE
        endif
    else if (chaine .eq. 'MAT_AMORT') then
        ndynlo = v_infosd(1)
    else if (chaine .eq. 'MULTI_APPUI') then
        ndynlo = v_infosd(2)
    else if (chaine .eq. 'AMOR_MODAL') then
        ndynlo = v_infosd(3)
    else if (chaine .eq. 'MASS_DIAG') then
        ndynlo = v_infosd(4)
    else if (chaine .eq. 'PROJ_MODAL') then
        ndynlo = v_infosd(5)
    else if (chaine .eq. 'IMPE_ABSO') then
        ndynlo = v_infosd(6)
    else if (chaine .eq. 'ONDE_PLANE') then
        ndynlo = v_infosd(7)
    else if (chaine .eq. 'EXPL_GENE') then
        ndynlo = v_infosd(9)
    else if (chaine .eq. 'NREAVI') then
        ndynlo = v_infosd(12)
    else if (chaine .eq. 'RAYLEIGH_KTAN') then
        ndynlo = v_infosd(13)
    else if (chaine .eq. 'COEF_MASS_SHIFT') then
        ndynlo = v_infosd(14)
    else if (chaine .eq. 'VECT_ISS') then
        ndynlo = v_infosd(15)
    else if (chaine .eq. 'AMOR_RAYLEIGH') then
        ndynlo = v_infosd(16)
    else if (chaine .eq. 'FORMUL_DEPL') then
        if (ndynin(sddyna,'FORMUL_DYNAMIQUE') .eq. 1) then
            ndynlo = ASTER_TRUE
        else
            ndynlo = ASTER_FALSE
        endif
    else if (chaine .eq. 'FORMUL_VITE') then
        if (ndynin(sddyna,'FORMUL_DYNAMIQUE') .eq. 2) then
            ndynlo = ASTER_TRUE
        else
            ndynlo = ASTER_FALSE
        endif
    else if (chaine .eq. 'FORMUL_ACCE') then
        if (ndynin(sddyna,'FORMUL_DYNAMIQUE') .eq. 3) then
            ndynlo = ASTER_TRUE
        else
            ndynlo = ASTER_FALSE
        endif
    else if (chaine.eq.'MULTI_PAS') then
        if (v_typesch(5) .eq. 'HHT_COMPLET') then
            ndynlo = ASTER_TRUE
        else
            ndynlo = ASTER_FALSE
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
999 continue
!
    call jedema()
!
end function
