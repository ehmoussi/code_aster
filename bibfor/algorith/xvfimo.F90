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

function xvfimo(modele, fiss)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
    character(len=8) :: modele, fiss
    aster_logical :: xvfimo
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     ROUTINE UTILITAIRE POUR X-FEM
!
!     BUT : RENVOIE .TRUE. SI LA FISSURE EST ASSOCIEE AU MODELE
!
!  IN :
!     MODELE : NOM DE LA SD_MODELE
!     FISS   : NOM DE LA SD_FISS_XFEM
! ======================================================================
!
    integer :: ier, nfiss, i
    character(len=8), pointer :: vfiss(:) => null()
!
    call jemarq()
!
    call jeexin(modele//'.FISS', ier)
    ASSERT(ier.ne.0)
!
!     RECUPERATION DU NOMBRE DE FISSURES ASSOCIEES AU MODELE
    call dismoi('NB_FISS_XFEM', modele, 'MODELE', repi=nfiss)
!
!     RECUPERATION DE LA LISTE DES FISSURES ASSOCIEES AU MODELE
    call jeveuo(modele//'.FISS', 'L', vk8=vfiss)
!
    xvfimo=.false.
!
    do i = 1, nfiss
        if (fiss .eq. vfiss(i)) xvfimo=.true.
    end do
!
    call jedema()
!
end function
