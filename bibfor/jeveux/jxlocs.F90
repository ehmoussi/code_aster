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

subroutine jxlocs(itab, gen1, lty1, lon1, jadm,&
                  ldeps, jitab)
! person_in_charge: j-pierre.lefebvre at edf.fr
! aslint: disable=
    implicit none
#include "asterf_types.h"
#include "jeveux_private.h"
#include "asterfort/jxdeps.h"
#include "asterfort/utmess.h"
    integer :: itab(*), lty1, lon1, jadm, jitab
    aster_logical :: ldeps
    character(len=*) :: gen1
! ----------------------------------------------------------------------
! RENVOIE L'ADRESSE DU SEGMENT DE VALEUR PAR RAPPORT A ITAB
! ROUTINE AVEC APPEL SYSTEME : LOC
!
! IN  ITAB   : TABLEAU PAR RAPPORT AUQUEL L'ADRESSE EST RENVOYEE
! IN  GEN1   : GENRE DE L'OBJET ASSOCIE
! IN  LTY1   : LONGUEUR DU TYPE DE L'OBJET ASSOCIE
! IN  LON1   : LONGUEUR DU SEGMENT DE VALEUR EN OCTET
! IN  JADM   : ADRESSE MEMOIRE DU SEGMENT DE VALEUR EN OCTET
! IN  LDEPS  : .TRUE. SI ON AUTUORISE LE DEPLACEMENT EN MEMOIRE
! OUT JITAB  : ADRESSE DANS ITAB DU SEGMENT DE VALEUR
! ----------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
    integer :: iloc
    common /ilocje/  iloc
!
    integer :: idec
    integer(kind=8) :: valloc, ia, ltyp2
! DEB-------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: ir, kadm, ladm
!-----------------------------------------------------------------------
    kadm = jadm
    ladm = iszon(jiszon + kadm - 3)
    jitab = 0
    valloc = loc(itab)
    ia = (iloc-valloc) + kadm*lois
    ir = 0
    ltyp2 = lty1
    idec = mod(ia,ltyp2)
    if (idec .ne. 0 .and. gen1(1:1) .ne. 'N') then
        if (idec .gt. 0) then
            ir = lty1 - idec
        else
            ir = -idec
        endif
    endif
    if (lty1 .ne. lois .and. gen1(1:1) .ne. 'N') then
        if (ir .ne. ladm) then
            if (ldeps) then
                call jxdeps((kadm-1)*lois + ladm + 1, (kadm-1)* lois + ir + 1, lon1)
            else
                call utmess('F', 'JEVEUX1_60')
            endif
        endif
    endif
    jitab = 1 + (ia+ir)/lty1
    iszon(jiszon + kadm - 3 ) = ir
! FIN ------------------------------------------------------------------
end subroutine
