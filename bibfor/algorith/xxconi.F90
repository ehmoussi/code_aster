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

function xxconi(defico, nomfis, typmai)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    integer :: xxconi
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=8) :: nomfis
    character(len=4) :: typmai
    character(len=24) :: defico
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM (METHODE XFEM - UTILITAIRE)
!
! RETOURNE LA ZONE DE CONTACT CORRESPONDANT A UNE FISSURE
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD DU CONTACT
! IN  NOMFIS : NOM DE LA SD FISS_XFEM
! IN  TYPMAI : TYPE DE LA FISSURE: POUR L'INSTANT 'MAIT'
!
!
!
!
!
!
    character(len=24) :: xfimai
    integer :: jfimai
    integer :: nzoco, izone, iret
    character(len=8) :: fiscou
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    iret = 0
!
! --- ACCES OBJETS JEVEUX
!
    xfimai = defico(1:16)//'.XFIMAI'
    call jeveuo(xfimai, 'L', jfimai)
    call jelira(xfimai, 'LONMAX', nzoco)
!
! --- RECHERCHE FISSURE DANS MAITRE
!
    do 10 izone = 1, nzoco
        if (typmai .eq. 'MAIT') then
            fiscou = zk8(jfimai-1+izone)
        else
            ASSERT(.false.)
        endif
        if (fiscou .eq. nomfis) then
            if (iret .eq. 0) then
                iret = izone
                goto 11
            else
                ASSERT(.false.)
            endif
        endif
10  end do
11  continue
!
    if (iret .le. 0) then
        call utmess('F', 'XFEM_4')
    else
        xxconi = iret
    endif
!
    call jedema()
!
end function
