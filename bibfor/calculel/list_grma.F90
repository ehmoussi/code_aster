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

subroutine list_grma(mailla,ima,n1,lgrma,nbgrma)
    implicit none
!
! person_in_charge: jacques.pellet at edf.fr
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/assert.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexnom.h"
!

    character(len=8), intent(in) :: mailla
    integer, intent(in) :: ima
    integer, intent(in) :: n1
    character(len=*), intent(out) :: lgrma(n1)
    integer, intent(out) :: nbgrma
!
!-----------------------------------------------------------------------
!   But :
!     retourner la liste des noms des GROUP_MA qui contiennent la maille ima
!
!   Entrees:
!     mailla     :  nom du maillage
!     ima        :  numero de la maille cherchee
!     n1         :  dimension du vecteur lgrma
!   Sorties:
!     lgrma      :  liste des noms des GROUP_MA
!     nbgrma     :  nombre de GROUP_MA renseignes  (<=n1)
!
!-----------------------------------------------------------------------
    character(len=24) :: nomgrma
    integer :: nbgroup,igrma,jgrma,nbma,kma,iexi

!-----------------------------------------------------------------------
!
    call jemarq()


    nbgrma=0
    call jeexin(mailla//'.GROUPEMA',iexi)
    if (iexi.eq.0) goto 999

    call jelira(mailla//'.GROUPEMA','NUTIOC',nbgroup)
    do igrma=1,nbgroup
       call jeveuo(jexnum(mailla//'.GROUPEMA', igrma), 'L',jgrma)
       call jelira(jexnum(mailla//'.GROUPEMA', igrma), 'LONMAX',nbma)
       do kma=1,nbma
           if (zi(jgrma-1+kma).eq.ima) then
               call jenuno(jexnum(mailla//'.PTRNOMMAI', igrma), nomgrma)
               nbgrma=nbgrma+1
               lgrma(nbgrma)=nomgrma
               goto 1
           endif
       enddo
1      continue
    enddo

999 continue
    call jedema()
end subroutine
