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

subroutine op0002()
    implicit none
!     LECTURE DE LA COMMANDE DEFI_CONSTANTE
!     STOCKAGE DANS UN OBJET DE TYPE FONCTION
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
!     OBJETS SIMPLES CREES:
!        NOMFON//'.PROL'
!        NOMFON//'.VALE
!     ------------------------------------------------------------------
!
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lxlgut.h"
#include "asterfort/titre.h"
#include "asterfort/wkvect.h"
    integer :: nbval, lval, jpro
    character(len=8) :: typfon
    character(len=16) :: consta
    character(len=19) :: nomfon
    character(len=24) :: chpro, chval, nomres
!     ------------------------------------------------------------------
    call jemarq()
    call infmaj()
!
!     CREATION ET REMPLISSAGE DE L'OBJET NOMFON.PROL
    call getres(nomfon, typfon, consta)
    chpro = nomfon//'.PROL'
    ASSERT(lxlgut(nomfon).le.24)
    call wkvect(chpro, 'G V K24', 6, jpro)
    zk24(jpro) = 'CONSTANT'
    zk24(jpro+1) = 'LIN LIN '
    call getvtx(' ', 'NOM_RESU', scal=nomres, nbret=nbval)
    zk24(jpro+2) = 'TOUTPARA'
    zk24(jpro+3) = nomres(1:8)
    zk24(jpro+4) = 'CC      '
    zk24(jpro+5) = nomfon(1:19)
!
!     CREATION ET REMPLISSAGE DE L'OBJET NOMFON.VALE
!
    chval = nomfon//'.VALE'
    call wkvect(chval, 'G V R', 2, lval)
    zr(lval) = 1.0d0
    call getvr8(' ', 'VALE', scal=zr(lval+1), nbret=nbval)
!
!     --- LIBERATIONS ---
!
!     --- CREATION D'UN TITRE ---
    call titre()
!
    call jedema()
end subroutine
