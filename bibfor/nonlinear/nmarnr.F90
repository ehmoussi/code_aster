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

subroutine nmarnr(result, typtaz, numreu)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbexip.h"
#include "asterfort/tbexve.h"
    character(len=8) :: result
    character(len=*) :: typtaz
    integer :: numreu
!
! ----------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (ARCHIVAGE)
!
! RECUPERATION NUMERO DE REUSE COURANT POUR LA TABLE
!
! ----------------------------------------------------------------------
!
!
! IN  RESULT : NOM DE LA SD RESULTAT
! IN  TYPTAB : TYPE DE LA TABLE
! OUT NUMREU : NUMERO DE REUSE POUR LA TABLE
!
! ----------------------------------------------------------------------
!
    integer :: iret, nblign
    character(len=19) :: nomtab
    character(len=16) :: typtab
    character(len=2) :: typvar
    aster_logical :: lexist
    character(len=19) :: lisres
    integer :: jlisre, nval, ival, vali
    integer, pointer :: tbnp(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    numreu = -1
    lisres = '&&NMARNR.NUME_REUSE'
    typtab = typtaz
!
! --- RECUPERATION DE LA LISTE DE TABLES SI ELLE EXISTE
!
    call jeexin(result//'           .LTNT', iret)
    if (iret .eq. 0) then
        numreu = 0
        goto 99
    endif
!
! --- RECUPERATION DU NOM DE LA TABLE
!
    nomtab = ' '
    call ltnotb(result, typtab, nomtab)
!
! --- LA TABLE EXISTE-T-ELLE ?
!
    call exisd('TABLE', nomtab, iret)
    if (iret .eq. 0) then
        numreu = 0
        goto 99
    else
        call tbexip(nomtab, 'NUME_REUSE', lexist, typvar)
        if (.not.lexist .or. typvar .ne. 'I') then
            ASSERT(.false.)
        endif
!
! ----- NOMBRE DE LIGNES
!
        call jeveuo(nomtab//'.TBNP', 'L', vi=tbnp)
        nblign = tbnp(2)
        if (nblign .eq. 0) then
            numreu = 0
            goto 99
        endif
!
! ----- EXTRACTION DE LA COLONNE 'NUME_REUSE' DANS UN OBJET TEMPORAIRE
!
        call tbexve(nomtab, 'NUME_REUSE', lisres, 'V', nval,&
                    typvar)
        call jeveuo(lisres, 'L', jlisre)
!
! ----- RECUPERATION DU MAX
!
        do 10 ival = 1, nval
            vali = zi(jlisre-1+ival)
            if (vali .gt. numreu) numreu = vali
 10     continue
        numreu = numreu + 1
    endif
!
 99 continue
!
    call jedetr(lisres)
    ASSERT(numreu.ge.0)
!
    call jedema()
end subroutine
