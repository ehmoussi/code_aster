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

subroutine ddllag(nume, iddl, neq, lagr1, lagr2)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: iddl, neq, lagr1, lagr2
    character(len=*) :: nume
!
!     RECHERCHE LES DEUX LAGRANGES ASSOCIES AU DDL IDDL.
!     CE IDDL DDL EST BLOQUE ET ON NE LE VERIFIE PAS.
!     DANS LE CAS OU IDDL N'EST PAS BLOQUE, LAGR1=LAGR2=0
!
! IN  : NUME   : NOM D'UN NUME_DDL
! IN  : IDDL   : NUMERO D'UN DDL BLOQUE
! IN  : NEQ    : NOMBRE D'EQUATIONS
! OUT : LAGR1  : PREMIER LAGRANGE ASSOCIE
! OUT : LAGR2  : DEUXIEME LAGRANGE ASSOCIE
! ----------------------------------------------------------------------
    character(len=24) :: nomnu
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i,  icas, icmp, inoe, nc, nn
    integer, pointer :: deeq(:) => null()
!
!-----------------------------------------------------------------------
    call jemarq()
    lagr1 = 0
    lagr2 = 0
    nomnu(1:14) = nume
    nomnu(15:19) = '.NUME'
    call jeveuo(nomnu(1:19)//'.DEEQ', 'L', vi=deeq)
!
    inoe = deeq(1+ (2*(iddl-1)) + 1 - 1 )
    icmp = -deeq(1+ (2*(iddl-1)) + 2 - 1 )
    icas = 1
    do 10 i = 1, neq
        nn = deeq(1+ (2*(i-1)) + 1 - 1 )
        nc = deeq(1+ (2*(i-1)) + 2 - 1 )
        if (nn .eq. inoe .and. nc .eq. icmp) then
            if (icas .eq. 1) then
                lagr1 = i
                icas = 2
            else
                lagr2 = i
                goto 9999
            endif
        endif
10  end do
!
9999  continue
    call jedema()
end subroutine
