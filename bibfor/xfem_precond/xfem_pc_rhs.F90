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

subroutine xfem_pc_rhs(matas1, nsecm, secm, trav)
    implicit none
! person_in_charge: jacques.pellet at edf.fr
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mmtmul.h"
#include "asterfort/wkvect.h"
!
    character(len=19) :: matas1
    integer :: nsecm
    real(kind=8) :: secm(*)
    real(kind=8), optional ::  trav(*)
!--------------------------------------------------------------
! BUT :
!   calculer le(s) second-membre(s) réduits correspondant à
!   un (ou plusieurs) second-membre(s) complets.
!
! IN  : MATAS1 : sd_matr_asse avec ses conditions dualisées
!                à eliminer
! IN  : NSECM  :  nombre de seconds membres
! IN  : SECM(*)  : vecteur de réels de dimension nsecm*neq1
!                  (valeurs de(s) second-membre(s) complets)
! IN/JXOUT : TRAV(*)  : vecteur qui contiendra le résultat
!---------------------------------------------------------------
!================================================================
    character(len=24) :: chtrav2
    character(len=19) :: pc
    character(len=14) :: nu_pc
    integer ::  lmat_pc, neq, jtrav2, kvect, ieq
!----------------------------------------------------------------
    call jemarq()
!
    ASSERT(( present(trav) .and. nsecm .eq. 0 ) .or. (.not. present(trav) .and.  nsecm .gt. 0))
!
    call dismoi('XFEM_PC', matas1, 'MATR_ASSE', repk=pc)
    ASSERT( pc .ne. ' ' )
!
    call dismoi('NOM_NUME_DDL', pc, 'MATR_ASSE', repk=nu_pc)
    ASSERT( nu_pc .ne. ' ' )
    call jelira(nu_pc//'.SMOS.SMDI', 'LONMAX', neq)
!
    call jeveuo(pc//'.&INT', 'E', lmat_pc)
!
    if ( nsecm .eq. 0 ) then
!
       call mmtmul('ZERO', lmat_pc, secm, trav, 1, .false._1)
!
    elseif ( nsecm .gt. 0 ) then
       chtrav2='&&XFEM_PC_RHS.TRAV'
       call wkvect(chtrav2, 'V V R', neq*nsecm, jtrav2)
       call mmtmul('ZERO', lmat_pc, secm, zr(jtrav2), nsecm, .false._1)
       do kvect=1,nsecm
          do ieq=1,neq
              secm(neq*(kvect-1)+ieq)=zr(jtrav2-1+neq*(kvect-1)+ieq)
          enddo
       enddo
       call jedetr(chtrav2)
!
     else
       ASSERT( .false. )   
    endif
!
    call jedema()
!
end subroutine
