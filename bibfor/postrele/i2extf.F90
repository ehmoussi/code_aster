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

subroutine i2extf(m, f, conec, type, n1,&
                  n2)
    implicit none
!
!
!**********************************************************************
!
!     SAISIE DES EXTREMITES D' UNE FACE D' UNE MAILLE EN 2D
!
!       M     (IN)  : NUMERO DE LA MAILLE
!
!       F     (IN)  : NUMERO DE LA FACE
!
!       CONEC (IN)  : NOM DE L' OBJET CONECTIVITE
!
!       TYPE  (IN)  : NOM DE L' OBJET CONTENANT LES TYPES DES MAILLES
!
!       N1    (OUT) : NUMERO DU NOEUD ORIGINE
!
!       N2    (OUT) : NUMERO DU NOEUD EXTREMITE
!
!**********************************************************************
!
#include "jeveux.h"
!
#include "asterfort/i2nbrf.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    character(len=*) :: conec
    character(len=*) :: type
    integer :: m, f, n1, n2
!
    integer :: adrm, atypm, nbn, nbf
    character(len=8) :: typm
!
!
!
!
!-----------------------------------------------------------------------
    integer :: iatyma
!-----------------------------------------------------------------------
    call jemarq()
    nbn = 0
    nbf = 0
    adrm = 0
    atypm = 0
    typm = ' '
!
    call jeveuo(jexnum(conec, m), 'L', adrm)
    call jeveuo(type, 'L', iatyma)
    atypm=iatyma-1+m
    call jenuno(jexnum('&CATA.TM.NOMTM', zi(atypm)), typm)
!
    if ((typm .eq. 'SEG2') .or. (typm .eq. 'SEG3')) then
!
        n1 = zi(adrm)
        n2 = zi(adrm + 1)
!
    else
!
        call jelira(jexnum(conec, m), 'LONMAX', nbn)
        call i2nbrf(nbn, nbf)
!
        n1 = zi(adrm + f-1)
!
        if (f .eq. nbf) then
!
            n2 = zi(adrm)
!
        else
!
            n2 = zi(adrm + f)
!
        endif
!
    endif
!
    call jedema()
end subroutine
