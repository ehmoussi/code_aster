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

function modat2(iopt, ite, nompar)
    implicit none
    integer :: modat2
!
! person_in_charge: jacques.pellet at edf.fr
#include "jeveux.h"
!
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/jelira.h"
    integer :: iopt, ite
    character(len=8) :: nompar
! ----------------------------------------------------------------------
! BUT : TROUVER LE NUMERO DU MODE LOCAL ASSOCIE A UN PARAMETRE
!       D'UNE OPTION POUR UN TYPE_ELEM DONNE.
!
! ARGUMENTS :
!  IOPT    IN    I    : NUMERO DE L'OPTION DE CALCUL
!  ITE     IN    I    : NUMERO  DU TYPE_ELEM
!  NOMPAR  IN    K8   : NOM DU PARAMETRE POUR L'OPTION
!  MODAT2  OUT   I    : NUMERO DU MODE_LOCAL TROUVE DANS LE
!                       CATALOGUE DU TYPE_ELEM
!                       = 0 SI LE TYPE_ELEM NE CONNAIT PAS
!                       L'OPTION OU NE CONNAIT PAS LE PARAMETRE.
! ----------------------------------------------------------------------
!
!     VARIABLES LOCALES:
!     ------------------
    integer :: iopte, lgco, n1
    integer :: nucalc, nbpar, k, joptmo, joptno
    integer, pointer :: nbligcol(:) => null()
    integer, pointer :: optte(:) => null()
! ----------------------------------------------------------------------

    modat2 = 0

    call jeveuo('&CATA.TE.OPTTE', 'L', vi=optte)
    call jeveuo('&CATA.TE.NBLIGCOL', 'L', vi=nbligcol)
    lgco = nbligcol(1)
    iopte = optte((ite-1)*lgco+iopt)


    if (iopte .eq. 0) goto 20

    call jeveuo(jexnum('&CATA.TE.OPTMOD', iopte), 'L', joptmo)
    nucalc = zi(joptmo-1+1)
    if (nucalc .le. 0) goto 20

    call jeveuo(jexnum('&CATA.TE.OPTNOM', iopte), 'L', joptno)
    nbpar = zi(joptmo-1+2) + zi(joptmo-1+3)
    do k = 1,nbpar
        if (nompar .ne. zk8(joptno-1+k)) cycle
        modat2 = zi(joptmo-1+3+k)
    end do

!
20  continue
end function
