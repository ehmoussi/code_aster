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

subroutine xstami(noma, nmafon, nmaen1, nmaen2, nmaen3,&
                  jmafon, jmaen1, jmaen2, jmaen3)
!
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    integer :: nmafon, nmaen1, nmaen2, nmaen3
    integer :: jmafon, jmaen1, jmaen2, jmaen3
    character(len=8) :: noma
!
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM
!
! IMPRESSION DU STATUT DES MAILLES
!
! ----------------------------------------------------------------------
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  NMAFON : NOMBRE DE MAILLES CONTENANT LE FOND DE FISSURE
! IN  NMAEN1 : NOMBRE DE MAILLES 'HEAVISIDE'
! IN  NMAEN2 : NOMBRE DE MAILLES 'CRACKTIP'
! IN  NMAEN3 : NOMBRE DE MAILLES 'HEAVISIDE-CRACKTIP'
! IN  JMAFON : POINTEUR SUR MAILLES 'CONTENANT LE FOND DE FISSURE
! IN  JMAEN1 : POINTEUR SUR MAILLES 'HEAVISIDE'
! IN  JMAEN2 : POINTEUR SUR MAILLES 'CRACKTIP'
! IN  JMAEN3 : POINTEUR SUR MAILLES 'HEAVISIDE-CRACKTIP'
!
!
!
!
    integer :: ifm, niv, ima
    character(len=8) :: nomail
    character(len=19) :: nommai
!
    call jemarq()
    call infdbg('XFEM', ifm, niv)
!
    nommai = noma//'.NOMMAI'
!
    if (niv .ge. 2) then
        call utmess('I', 'XFEM_29', si=nmafon)
    endif
    if (niv .ge. 3) then
        do 320 ima = 1, nmafon
            call jenuno(jexnum(nommai, zi(jmafon-1+ima)), nomail)
            write(ifm,*)'MAILLE ',nomail
320      continue
    endif
!
    if (niv .ge. 2) then
        call utmess('I', 'XFEM_30', si=nmaen1)
    endif
    if (niv .ge. 3) then
        do 321 ima = 1, nmaen1
            call jenuno(jexnum(nommai, zi(jmaen1-1+ima)), nomail)
            write(ifm,*)'MAILLE ',nomail
321      continue
    endif
!
    if (niv .ge. 2) then
        call utmess('I', 'XFEM_31', si=nmaen2)
    endif
    if (niv .ge. 3) then
        do 322 ima = 1, nmaen2
            call jenuno(jexnum(nommai, zi(jmaen2-1+ima)), nomail)
            write(ifm,*)'MAILLE ',nomail
322      continue
    endif
!
    if (niv .ge. 2) then
        call utmess('I', 'XFEM_32', si=nmaen3)
    endif
    if (niv .ge. 3) then
        do 323 ima = 1, nmaen3
            call jenuno(jexnum(nommai, zi(jmaen3-1+ima)), nomail)
            write(ifm,*)'MAILLE ',nomail
323      continue
    endif
!
    call jedema()
end subroutine
