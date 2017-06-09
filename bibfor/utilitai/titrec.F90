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

subroutine titrec(donnee, iligd, icold, nbtitr, mxpara,&
                  para, nbpara)
    implicit none
#include "asterc/getres.h"
#include "asterfort/lxscan.h"
    character(len=*) :: donnee(*), para(*)
    integer :: iligd, icold, nbtitr, mxpara, nbpara
!     EXTRACTION DES PARAMETRES
!     ------------------------------------------------------------------
! IN  MXPARA : I  : NOMBRE MAXIMUM DE PARAMETRES ATTENDUS
! OUT PARA   : K* : LISTE DES PARAMETRES RECUS
! OUT NBPARA : I  : NOMBRE DE PARAMETRES RECUS
!     ------------------------------------------------------------------
    integer :: ival, icol, ilig
    real(kind=8) :: rval
    character(len=80) :: cval
    character(len=8) :: k8bid
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: iclass, ipara
!-----------------------------------------------------------------------
    nbpara = 0
    ilig = iligd
    icol = icold
 1  continue
    call lxscan(donnee(ilig), icol, iclass, ival, rval,&
                cval)
    if (iclass .eq. -1) then
!-DEL                WRITE(6,*) ' TITREC EOF '
        icol = 1
        ilig = ilig + 1
        if (ilig .le. nbtitr) goto 1
    else if (iclass .eq. 5 .and. cval(1:1) .eq. '(') then
!-DEL                WRITE(6,*) ' TITREC "(" '
        icold = icol
        iligd = ilig
11      continue
        call lxscan(donnee(iligd), icold, iclass, ival, rval,&
                    cval)
12      continue
        if (iclass .eq. -1) then
            icold = 1
            iligd = iligd + 1
            if (iligd .gt. nbtitr) then
!CC  EXPRESSION INCORRECTE
                nbpara = 0
                goto 20
            endif
            goto 11
        else if (iclass .eq. 3 .or. iclass .eq.4) then
            nbpara = nbpara + 1
            para(nbpara) = cval(1:ival)
!CC            CALL LXCAPS(PARA(NBPARA))
            call lxscan(donnee(iligd), icold, iclass, ival, rval,&
                        cval)
            if (iclass .eq. 5 .and. cval(1:1) .eq. ',') goto 11
            goto 12
        else if (iclass .eq. 5 .and. cval(1:1) .eq. ')') then
            if (nbpara .ne. mxpara) then
                nbpara = 0
            endif
            goto 20
        else
!CC  PARAMETRE INCORRECT
            nbpara = 0
        endif
20      continue
    endif
    if (nbpara .eq. 0) then
        do 30 ipara = 1, mxpara
            call getres(para(ipara), k8bid, k8bid)
            nbpara = nbpara + 1
30      continue
    endif
end subroutine
