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

subroutine xfem_pc_sol(matas1, nsolu, solu)
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
#include "asterfort/mrmult.h"
#include "asterfort/wkvect.h"
!
    character(len=19) :: matas1
    integer :: nsolu
    real(kind=8) :: solu(*)
!--------------------------------------------------------------
! BUT :
!   calculer le(s) second-membre(s) réduits correspondant à
!   un (ou plusieurs) second-membre(s) complets.
!
! IN  : MATAS1 : sd_matr_asse avec ses conditions dualisées
!                à eliminer
! IN  : NSOLU  :  nombre de seconds membres
! IN  : SOLU(*)  : vecteur de réels de dimension nsolu*neq1
!                  (valeurs de(s) second-membre(s) complets)
! IN/JXOUT : TRAV  : vecteur(s) qui contiendra le résultat
!---------------------------------------------------------------
!================================================================
    character(len=24) :: chtrav2
    character(len=19) :: pc
    character(len=14) :: nu_pc
    integer ::  lmat_pc, neq, jtrav2, kvect, ieq
!----------------------------------------------------------------
    call jemarq()
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
    chtrav2='&&XFEM_PC_SOL.TRAV'
!
    if ( nsolu .eq. 0 ) then
       call wkvect(chtrav2, 'V V R', neq, jtrav2)
       call mrmult('ZERO', lmat_pc, solu, zr(jtrav2), 1, .false._1)
       do ieq=1,neq
!          write(40,*) ieq,solu(ieq)
!          write(41,*) ieq,zr(jtrav2-1+ieq)
          solu(ieq)=zr(jtrav2-1+ieq)
       enddo
!
    elseif ( nsolu .gt. 0 ) then
       call wkvect(chtrav2, 'V V R', neq*nsolu, jtrav2)
       call mrmult('ZERO', lmat_pc, solu, zr(jtrav2), nsolu, .false._1)
       do kvect=1,nsolu
          do ieq=1,neq
              solu(neq*(kvect-1)+ieq)=zr(jtrav2-1+neq*(kvect-1)+ieq)
          enddo
       enddo
!
     else
       ASSERT( .false. )   
    endif
!
    call jedetr(chtrav2)
    call jedema()
!
end subroutine
