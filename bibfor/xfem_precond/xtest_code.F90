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

function xtest_code(id1, id2, lfno, nfh, nfissmax, fno1, fno2)
!
!-----------------------------------------------------------------------
! BUT : COMPARER LES INDICES DE DOMAINES
!       ET GERER LES INDICES CODéS SUR DES LONGUEURS DIFFERENTES (NFISS1<>NFISS2)
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!   - ID1     : IDENTIFIANT DU DOMAINE 1
!   - ID2     : IDENTIFIANT DU DOMAINE 2
!   - LFNO    : VERIFICATION DE LA BASE DE CODAGE AU BESOIN
!   - NFH     : NOMBRE DE CHIFFRES SIGNIFICATIFS POUR LA VERIFICATION
!   - FNO1    : FISNO DU DOMAINE 1 (C EST A DIRE LE FISNO DANS L ELEMENT Où ID1 A ETE CALCULE)
!   - FNO2    : FISNO DU DOMAINE 2 (C EST A DIRE LE FISNO DANS L ELEMENT Où ID2 A ETE CALCULE)
!
!-----------------------------------------------------------------------
    implicit none
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/xcalc_code.h"
#include "asterfort/xcalc_digit.h"
#include "asterfort/xextr_uplet.h"
!-----------------------------------------------------------------------
    integer :: id1, id2, nfissmax, nfh
    integer :: fno1(nfissmax), fno2(nfissmax)
    aster_logical :: xtest_code, lfno
!-----------------------------------------------------------------------
    integer :: n1, n2, idigi, up1(nfissmax), up2(nfissmax), n1_red, n2_red
!-----------------------------------------------------------------------
!
    xtest_code=.true.
!
    if (id1.le.0 .or. id2.le.0) then
      xtest_code=.false.
      goto 99
    endif
!
    if (.not.lfno) then
      if (id1.ne.id2) xtest_code=.false.
    else
      n1=xcalc_digit(id1)
      n2=xcalc_digit(id2)
      up1(1:n1)=xextr_uplet(n1,id1)
      up2(1:n2)=xextr_uplet(n2,id2)
      n1_red=count(fno1(1:n1).gt.0)
      n2_red=count(fno2(1:n2).gt.0)
      ASSERT((n1_red.ge.nfh).and.(n2_red.ge.nfh))
      up1(1:n1_red)=up1(pack(fno1(1:n1_red),fno1(1:n1).gt.0))
      up2(1:n2_red)=up2(pack(fno2(1:n2_red),fno2(1:n2).gt.0)) 
      do idigi=1,nfh
        if (up1(idigi).ne.up2(idigi)) xtest_code=.false.
     enddo
! 
    endif
!
99  continue
!
end function
