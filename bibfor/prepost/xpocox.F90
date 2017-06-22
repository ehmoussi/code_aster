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

subroutine xpocox(nbmac, ima, inmtot, nbcmpc, jresd1,&
                  jresv1, jresl1, jresd2, jresv2, jresl2)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cesexi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: nbmac, ima, inmtot, jresd1, jresv1, jresl1, nbcmpc
    integer :: jresd2, jresv2, jresl2
!
! person_in_charge: samuel.geniaut at edf.fr
!
!   ECRITURE DU COMPORTEMENT SUR LE RESU X-FEM POUR LES MAILLES X-FEM
!
!   IN
!     IMA    : NUMÉRO DE LA MAILLE PARENT
!     INMTOT : NB MAILLES X-FEM DEJA CREES
!     NBCMPC : NB DE CMP DU COMPORTEMENT
!     JRESD1 : ADRESSE DU .CESD DU CHAM_ELEM_S DE COMPORTEMENT ENTREE
!     JRESV1 : ADRESSE DU .CESV DU CHAM_ELEM_S DE COMPORTEMENT ENTREE
!     JRESL1 : ADRESSE DU .CESL DU CHAM_ELEM_S DE COMPORTEMENT ENTREE
!
!   OUT
!     JRESD1 : ADRESSE DU .CESD DU CHAM_ELEM_S DE COMPORTEMENT SORTIE
!     JRESV1 : ADRESSE DU .CESV DU CHAM_ELEM_S DE COMPORTEMENT SORTIE
!     JRESL1 : ADRESSE DU .CESL DU CHAM_ELEM_S DE COMPORTEMENT SORTIE
!
!
!
!
!
    integer :: icmp, iadr1, iadr2, ima2
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
!     NUMERO DE LA NOUVELLE MAILLE
    ima2 = nbmac + inmtot
!
!     COMPORTEMENT
    do 310 icmp = 1, nbcmpc
!
        call cesexi('C', jresd1, jresl1, ima, 1,&
                    1, icmp, iadr1)
        call cesexi('C', jresd2, jresl2, ima2, 1,&
                    1, icmp, iadr2)
!
        if (iadr1 .gt. 0) then
            ASSERT(iadr2.lt.0)
            zk16(jresv2-1-iadr2) = zk16(jresv1-1+iadr1)
            zl(jresl2-1-iadr2) = .true.
        endif
!
310  end do
!
    call jedema()
end subroutine
