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

subroutine tbimpr(table, formaz, ifr, nparim, lipaim,&
                  nparpg, formar)
!      IMPRESSION DE LA TABLE "TABLE".
! ----------------------------------------------------------------------
! IN  : TABLE  : NOM D'UNE STRUCTURE "TABLE"
! IN  : FORMAZ : FORMAT D'IMPRESSION DE LA TABLE
! IN  : IFR    : UNITE LOGIQUE D'IMPRESSION
! IN  : NPARIM : NOMBRE DE PARAMETRES D'IMPRESSION
! IN  : LIPAIM : LISTE DES PARAMETRES D'IMPRESSION
! IN  : NPARPG : PLUS UTILISE (DOIT ETRE PASSE A ZERO)
! IN  : FORMAR : FORMAT D'IMPRESSION DES REELS
! ----------------------------------------------------------------------
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "jeveux.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/tbimex.h"
#include "asterfort/tbimta.h"
#include "asterfort/utmess.h"
!
    integer :: nparim, nparpg, ifr
    character(len=*) :: table
    character(len=*) :: formaz, lipaim(*)
    character(len=*) :: formar
!
! 0.2. ==> COMMUNS
!
! 0.3. ==> VARIABLES LOCALES
!
!
    integer :: iret,  nbpara, nblign
    integer ::  lonmax, ititr
    character(len=8) :: format
    character(len=19) :: nomtab
    integer, pointer :: tbnp(:) => null()
    character(len=80), pointer :: titr(:) => null()
!     ------------------------------------------------------------------
!
!====
! 1. PREALABLES
!====
!
    call jemarq()
!
    nomtab = table
    format = formaz
!
!====
!  2. DECODAGE DES ARGUMENTS
!====
!
    call exisd('TABLE', nomtab, iret)
    if (iret .eq. 0) then
        call utmess('A', 'UTILITAI4_64')
        goto 9999
    endif
!
    call jeveuo(nomtab//'.TBNP', 'L', vi=tbnp)
    nbpara = tbnp(1)
    nblign = tbnp(2)
    if (nbpara .eq. 0) then
        call utmess('A', 'UTILITAI4_65')
        goto 9999
    endif
    if (nblign .eq. 0) then
        call utmess('A', 'UTILITAI4_76')
        goto 9999
    endif
!SV
    write(ifr,*) ' '
    if (format .eq. 'ASTER') then
        write(ifr,1000) '#DEBUT_TABLE'
    endif
!
!     --- IMPRESSION DU TITRE ---
!
    call jeexin(nomtab//'.TITR', iret)
    if (iret .ne. 0) then
        call jeveuo(nomtab//'.TITR', 'L', vk80=titr)
        call jelira(nomtab//'.TITR', 'LONMAX', lonmax)
        do 10 ititr = 1, lonmax
            if (format .eq. 'ASTER') then
                write(ifr,2000) '#TITRE',titr(ititr)
            else
                write(ifr,'(1X,A)') titr(ititr)
            endif
10      continue
    endif
!
    if (nparpg .eq. 0) then
!
!        --- FORMAT "EXCEL" OU "AGRAF" ---
!
        if (format .eq. 'EXCEL' .or. format .eq. 'AGRAF' .or. format .eq. 'ASTER') then
            call tbimex(table, ifr, nparim, lipaim, format,&
                        formar)
!
!        --- FORMAT "TABLEAU" ---
!
        else if (format .eq. 'TABLEAU') then
            call tbimta(table, ifr, nparim, lipaim, formar)
        endif
    else
!               --- TRAITEMENT DE LA "PAGINATION" ---
        call utmess('F', 'UTILITAI4_85')
!
    endif
!
    if (format .eq. 'ASTER') then
        write(ifr,1000) '#FIN_TABLE'
    endif
!
9999  continue
    1000 format(a)
    2000 format(a,1x,a)
!
    call jedema()
!
end subroutine
