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

subroutine refdag(resin)
!
    implicit none
#include "jeveux.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedup1.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
!
    character(len=8) :: resin
! person_in_charge: hassan.berro at edf.fr
! ----------------------------------------------------------------------
!
!   DOUBLER LA TAILLE DES OBJETS CONTENEURS DES REFERENCES DYNAMIQUES (.REFD ET INDI)
!
    integer :: nbrefs, ibid, jbid, jindi, jindi2, jrefe, jrefe2
    character(len=1) :: jvb
    character(len=8) :: restmp, k8bid
    character(len=16) :: refd, indi
!
    call jemarq()
!
    restmp = '&&REFDAJ'
!
    refd = '           .REFD'
    indi = '           .INDI'
!
    jvb = 'G'
    if (resin(1:2) .eq. '&&') jvb = 'V'
!
!   Save the existing information in a temporary location
    call jedup1(resin//refd, 'V', restmp//refd)
    call jedup1(resin//indi, 'V', restmp//indi)
    call jelira(resin//refd, 'NUTIOC', nbrefs, k8bid)
!
!   Clear all initial information
    call jedetr(resin//refd)
    call jedetr(resin//indi)
!
!   Initialize the REFD and INDI with the new size (double nbrefs)
    call wkvect(resin//indi, jvb//' V I', 2*nbrefs, jindi)
    call jecrec(resin//refd, jvb//' V K24', 'NU', 'CONTIG', 'CONSTANT',&
                2*nbrefs)
    call jeecra(resin//refd, 'LONT', (2*nbrefs)*5, k8bid)
!
!   Set all INDI entries to -100 (default/empty reference value)
    do 10 ibid = 1, 2*nbrefs
        zi(jindi+ibid-1) = -100
10  continue
!
!   Copy the temporary-saved information to the newly created objects
    call jeveuo(restmp//indi, 'L', jindi2)
    do 20 ibid = 1, nbrefs
!       INDI entry
        zi(jindi+ibid-1) = zi(jindi2+ibid-1)
!       REFD entry
        call jeveuo(jexnum(restmp//refd, ibid), 'L', jrefe2)
        call jecroc(jexnum( resin//refd, ibid))
        call jeveuo(jexnum( resin//refd, ibid), 'E', jrefe)
        do 30 jbid = 1, 5
            zk24(jrefe+jbid-1) = zk24(jrefe2+jbid-1)
30      continue 
!
20  continue
!
!   Cleanup the temporary objects
    call jedetr(restmp//refd)
    call jedetr(restmp//indi)
!
!
    call jedema()
end subroutine
