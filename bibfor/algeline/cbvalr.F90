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

subroutine cbvalr(rouc, neq, smhc, smdi, idlexc,&
                  coefr, coefc, valmi, valmr, valmc)
! aslint: disable=W1304
    implicit none
!     BUT : ACCUMULTATION DANS VALMR (OU VALMC) DE COEF*VALMI
!     ROUC=
!        /'RR' : ON UTILISE VALMR ET COEFR
!        /'RC' : ON UTILISE VALMR ET COEFC
!        /'CR' : ON UTILISE VALMC ET COEFR
!        /'CC' : ON UTILISE VALMC ET COEFC
!-------------------------------------------------------------------
#include "asterfort/assert.h"
    character(len=2) :: rouc
    integer(kind=4) :: smhc(*)
    integer :: neq, smdi(*), idlexc(*)
    integer :: kin, idebli, ilig, ifinli, ind, jcol
    real(kind=8) :: coefr, valmi(*), valmr(*)
    complex(kind=8) :: coefc, valmc(*)
!     ------------------------------------------------------------------
    kin = 0
    idebli = 1
!
!
    if (rouc .eq. 'RR') then
!     -------------------------------
        do 20 ilig = 1, neq
            ifinli = smdi(ilig)
            do 10 ind = idebli, ifinli
                kin = kin + 1
                jcol = smhc(ind)
                valmr(kin) = valmr(kin) + coefr*valmi(kin)* (1-idlexc( jcol))* (1-idlexc(ilig))
10          continue
            idebli = smdi(ilig) + 1
20      continue
!
!
    else if (rouc.eq.'RC') then
!     -------------------------------
        do 40 ilig = 1, neq
            ifinli = smdi(ilig)
            do 30 ind = idebli, ifinli
                kin = kin + 1
                jcol = smhc(ind)
                valmr(kin) = valmr(kin) + dble(coefc*valmi(kin)* (1-idlexc(jcol))* (1-idlexc(ilig&
                             &)))
30          continue
            idebli = smdi(ilig) + 1
40      continue
!
!
    else if (rouc.eq.'CR') then
!     -------------------------------
        do 60 ilig = 1, neq
            ifinli = smdi(ilig)
            do 50 ind = idebli, ifinli
                kin = kin + 1
                jcol = smhc(ind)
                valmc(kin) = valmc(kin) + coefr*valmi(kin)* (1-idlexc( jcol))* (1-idlexc(ilig))
50          continue
            idebli = smdi(ilig) + 1
60      continue
!
!
    else if (rouc.eq.'CC') then
!     -------------------------------
        do 80 ilig = 1, neq
            ifinli = smdi(ilig)
            do 70 ind = idebli, ifinli
                kin = kin + 1
                jcol = smhc(ind)
                valmc(kin) = valmc(kin) + coefc*valmi(kin)* (1-idlexc( jcol))* (1-idlexc(ilig))
70          continue
            idebli = smdi(ilig) + 1
80      continue
!
!
    else
        ASSERT(.false.)
    endif
!
end subroutine
