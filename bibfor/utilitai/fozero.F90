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

subroutine fozero(nomfon)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/lxlgut.h"
#include "asterfort/wkvect.h"
    character(len=*) :: nomfon
!     CREATION D'UN OBJET DE TYPE FONCTION CONSTANTE DE VALEUR NULLE
!     ------------------------------------------------------------------
! IN  NOM DE LA FONCTION CONSTANTE A CREER
!     ------------------------------------------------------------------
!     OBJETS SIMPLES CREES:
!        NOMFON//'.PROL'
!        NOMFON//'.VALE
!     ------------------------------------------------------------------
!
    character(len=19) :: nomf
    character(len=24) :: chpro, chval
!-----------------------------------------------------------------------
    integer :: iret, jpro, lval
!-----------------------------------------------------------------------
    call jemarq()
!
!     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.PROL ---
    nomf = nomfon
    chpro = nomf//'.PROL'
    call jeexin(chpro, iret)
    if (iret .ne. 0) goto 9999
!
    ASSERT(lxlgut(nomf).le.24)
    call wkvect(chpro, 'G V K24', 6, jpro)
    zk24(jpro) = 'CONSTANT'
    zk24(jpro+1) = 'LIN LIN '
    zk24(jpro+2) = 'TOUTPARA'
    zk24(jpro+3) = 'TOUTRESU'
    zk24(jpro+4) = 'CC      '
    zk24(jpro+5) = nomf
!
!     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.VALE ---
    chval(1:19) = nomf
    chval(20:24) = '.VALE'
    call wkvect(chval, 'G V R', 2, lval)
    zr(lval) = 1.0d0
    zr(lval+1) = 0.d0
!
!     --- LIBERATIONS ---
9999  continue
    call jedema()
end subroutine
