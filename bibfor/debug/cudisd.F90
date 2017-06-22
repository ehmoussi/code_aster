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

function cudisd(resocu, questz)
    implicit none
    integer :: cudisd
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: resocu
    character(len=*) :: questz
!
! ----------------------------------------------------------------------
!
! ROUTINE LIAISON_UNILATER (UTILITAIRE)
!
! LECTURE INFORMATIONS SUR L'ETAT DES LIAISONS
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCU  : SD DE RESOLUTION DU CONTACT
! IN  QUESTI  : VALEUR A LIRE/ECRIRE
!   NBLIAC : NOMBRE DE LIAISON DE CONTACT ACTIVES
!
!
!
!
    character(len=24) :: questi
    character(len=24) :: coco
    integer :: jcoco
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    questi = questz
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    coco = resocu(1:14)//'.COCO'
    call jeveuo(coco, 'L', jcoco)
!
    if (questi .eq. 'NBLIAC') then
        cudisd = zi(jcoco+3-1)
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end function
