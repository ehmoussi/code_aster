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

subroutine focstc(nomfon, nomres, rval, ival, base)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lxlgut.h"
#include "asterfort/wkvect.h"
    character(len=1) :: base
    character(len=*) :: nomfon, nomres
    real(kind=8) :: rval, ival
!     CREATION D'UN OBJET DE TYPE FONCTION CONSTANTE COMPLEXE
!     ------------------------------------------------------------------
! IN  NOMFON : K19 : NOM DE LA FONCTION CONSTANTE A CREER
! IN  NOMRES : K8  : NOM_RESU DE LA FONCTION
! IN  RVAL   : R   : VALEUR REELLE DE LA CONSTANTE
! IN  IVAL   : R   : VALEUR IMAGINAIRE DE LA CONSTANTE
! IN  BASE   : K1  : TYPE DE LA BASE 'G','V'
!     ------------------------------------------------------------------
!     OBJETS SIMPLES CREES:
!        NOMFON//'.PROL'
!        NOMFON//'.VALE
!     ------------------------------------------------------------------
    character(len=19) :: nomf
    character(len=24) :: chpro, chval
    integer :: jpro, lval
    integer :: iret
!
!     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.PROL ---
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    nomf = nomfon
    chpro = nomf//'.PROL'
    chval = nomf//'.VALE'
    call jeexin(chpro, iret)
    if (iret .eq. 0) then
!
        ASSERT(lxlgut(nomf).le.24)
        call wkvect(chpro, base//' V K24', 6, jpro)
        zk24(jpro) = 'FONCT_C '
        zk24(jpro+1) = 'LIN LIN '
        zk24(jpro+2) = 'TOUTPARA'
        zk24(jpro+3) = nomres
        zk24(jpro+4) = 'CC      '
        zk24(jpro+5) = nomf
!
!        --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.VALE ---
        chval(1:19) = nomf
        chval(20:24) = '.VALE'
        call wkvect(chval, base//' V R', 3, lval)
        zr(lval) = 1.0d0
        zr(lval+1) = rval
        zr(lval+2) = ival
    else
        call jeveuo(chval, 'E', lval)
        zr(lval+1) = rval
        zr(lval+2) = ival
    endif
!
!     --- LIBERATIONS ---
    call jedema()
end subroutine
