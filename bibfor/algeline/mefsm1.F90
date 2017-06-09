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

subroutine mefsm1(vale, matgen, base, nomnum, nomsto,&
                  nbmode, nbloc, nterm)
    implicit none
#include "jeveux.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/ualfva.h"
#include "asterfort/wkvect.h"
!
    integer :: nbmode, nbloc, nterm
    real(kind=8) :: vale(*)
    character(len=19) :: matgen
    character(len=1) :: base
    character(len=19) :: nomnum, nomsto
!
    integer :: i, j, iblo, iadesc, ialime, iaconl, jrefa, ldblo
    character(len=19) :: matrge
! DEB------------------------------------------------------------------
!
    call jemarq()
!
    matrge = matgen
!
    call wkvect(matrge//'.DESC', 'G V I', 3, iadesc)
    zi(iadesc) = 2
    zi(iadesc+1) = nbmode
    zi(iadesc+2) = 2
!
    call wkvect(matrge//'.LIME', 'G V K24', 1, ialime)
    zk24(ialime) = '                        '
!
    call wkvect(matrge//'.CONL', 'G V R', nbmode, iaconl)
    do i = 1, nbmode
        zr(iaconl+i-1) = 1.0d0
    end do
!
    call wkvect(matrge//'.REFA', 'G V K24', 20, jrefa)
    zk24(jrefa-1+11)='MPI_COMPLET'
    zk24(jrefa-1+1) = base
    zk24(jrefa-1+2) = nomnum
    zk24(jrefa-1+9) = 'MS'
    zk24(jrefa-1+10) = 'GENE'
!
    call jecrec(matrge//'.UALF', 'G V R', 'NU', 'DISPERSE', 'CONSTANT',&
                nbloc)
    call jeecra(matrge//'.UALF', 'LONMAX', nterm)
!
    iblo = 1
!
    call jecroc(jexnum(matrge//'.UALF', iblo))
    call jeveuo(jexnum(matrge//'.UALF', iblo), 'E', ldblo)
!
    nterm = 0
    do i = 1, nbmode
        do j = 1, i
            nterm = nterm + 1
            zr(ldblo+nterm-1) = vale( j + (i-1)*nbmode )
        end do
    end do
!
    call ualfva(matrge, 'G')
!
!
    call jedema()
!
end subroutine
