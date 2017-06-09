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

function lexseg(connex, typmai, nbrma, n1, n2)
    implicit none
!     FONCTION BOOLEENNE INDIQUANT L'EXISTENCE DANS LE MAILLAGE D'UNE
!     MAILLE SEGMENT DE NOEUD ORIGINE DE NUMERO N1 ET NOEUD EXTREMITE
!     DE NUMERO N2
!     APPELANT : FENEXC
!-----------------------------------------------------------------------
! IN : CONNEX : CHARACTER*24 , NOM DE L'OBJET CONNECTIVITE
! IN : TYPMAI : CHARACTER*24 , NOM DE L'OBJET CONTENANT LES TYPES
!               DES MAILLES
! IN : NBRMA  : INTEGER , NOMBRE DE MAILLES DU MAILLAGE
! IN : N1     : INTEGER , NUMERO DU NOEUD ORIGINE
! IN : N2     : INTEGER , NUMERO DU NOEUD EXTREMITE
!-----------------------------------------------------------------------
#include "asterf_types.h"
#include "asterfort/i2extf.h"
    aster_logical :: lexseg
    character(len=24) :: connex, typmai
    integer :: nbrma, n1, n2
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: mi, nuextr, nuorig
!-----------------------------------------------------------------------
    lexseg = .false.
    do 10 mi = 1, nbrma
        call i2extf(mi, 1, connex(1:15), typmai(1:16), nuorig,&
                    nuextr)
        if (nuorig .eq. n1 .and. nuextr .eq. n2) then
            lexseg = .true.
            goto 11
        endif
 10 end do
 11 continue
end function
