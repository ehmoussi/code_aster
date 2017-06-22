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

function cudisi(deficz, questz)
!
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit      none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: cudisi
    character(len=*) :: deficz
    character(len=*) :: questz
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES)
!
! RETOURNE DES INFOS DIVERSES POUR LIAISON_UNIL (ENTIER)
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICU  : SD DE DEFINITION DE LIAISON_UNILATER (DEFI_CONTACT)
! IN  QUESTI  : QUESTION (PARAMETRE INTERROGE)
!
!
!
!
    character(len=24) :: ndimcu
    integer :: jdim
    character(len=24) :: deficu, questi
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    deficu = deficz
    questi = questz
!
! --- LECTURE DES STRUCTURES DE DONNEES
!
    ndimcu = deficu(1:16)//'.NDIMCU'
    if (questi .eq. 'NNOCU') then
        call jeveuo(ndimcu, 'L', jdim)
        cudisi = zi(jdim)
    else if (questi.eq.'NCMPG') then
        call jeveuo(ndimcu, 'L', jdim)
        cudisi = zi(jdim+1)
    else if (questi.eq.'NB_RESOL') then
        cudisi = 10
!
    else
        write(6,*) 'QUESTION: ',questi
        ASSERT(.false.)
    endif
!
    call jedema()
!
end function
