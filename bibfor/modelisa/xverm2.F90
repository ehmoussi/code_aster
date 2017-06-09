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

subroutine xverm2(nfiss, fiss, mod)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    integer :: nfiss
    character(len=8) :: fiss(nfiss), mod
!
! ----------------------------------------------------------------------
!
! routine XFEM (verification des SD)
!
! verifications specifiques dans le cas des modelisations
! thermiques, HM et multi-heaviside, afin d'interdir certaines
! configurations
!
! ----------------------------------------------------------------------
!
! in  nfiss  : nombre de fissures
! in  fiss   : liste des noms des fissures
! in  mod    : nom du modele sain en entree de MODI_MODELE_XFEM
!
    integer :: ifiss, iexi
    character(len=16) :: typdis, pheno, exithm
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
!   recuperation du phenomene
!
    call dismoi('PHENOMENE', mod, 'MODELE', repk=pheno)
    ASSERT(pheno.eq.'MECANIQUE' .or. pheno.eq.'THERMIQUE')
!
!   s'agit-il d'une modelisation HM
!
    call dismoi('EXI_THM', mod, 'MODELE', repk=exithm)
!
!   boucle surlles fissures
!
    do ifiss = 1, nfiss
!
!       seules les INTERFACEs sont autorisees en HM-XFEM
!
        call dismoi('TYPE_DISCONTINUITE', fiss(ifiss), 'FISS_XFEM', repk=typdis)
        if (exithm .eq. 'OUI' .and. typdis .eq. 'FISSURE') then
            call utmess('F', 'XFEM_78', sk='HM-XFEM')
        endif
!
!       on interdit le multi-heaviside en thermique
!
        call jeexin(fiss(ifiss)//'.JONFISS', iexi)
        if (iexi .ne. 0 .and. pheno .eq. 'THERMIQUE') then
                call utmess('F', 'XFEM_71', sk=mod)
        endif
!
    end do
!
    call jedema()
end subroutine
