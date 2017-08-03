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
      subroutine cnoadd(chno,chnop)
      implicit none
      character*(*) chno,chnop
!----------------------------------------------------------------
! BUT :
! pour un cham_no (chno) provenant d'un assemblage,
! on met à zéro les entrées dont on n'est pas strictement propriétaires
!----------------------------------------------------------------
#include "asterf_config.h"
#include "asterf.h"
#include "asterf_types.h"
#ifdef _USE_MPI
#include "mpif.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/copisd.h"
#include "asterfort/codent.h"
#include "asterfort/jelira.h"
#include "asterfort/gettco.h"
#include "asterfort/assert.h"
      integer :: jnbjoi,nbjoin,numpro,jjointe,jjointr
      integer :: lgenvo,jtmpe,jtmpr,iaux,jaux,neq,lgrecep
      integer :: ibid,jvale,k
      character(len=4)  :: chnbjo,kbid,ktyp
      character(len=8)  :: k8bid
      character(len=24) :: nonbjo,nojoinr
      character(len=14) :: numddl
      character(len=16) :: typsd='****'
      character(len=19) :: cn19,pfchno,cn19p,nommai
!----------------------------------------------------------------
    call jemarq()

!   copie du champ en entrée
!   ------------------------
    cn19=chno
    cn19p=chnop
    call copisd('CHAMP','V',cn19,cn19p)


!   si le maillage support n'est pas distribué, on sort
!   ---------------------------------------------------
    call dismoi('PROF_CHNO',cn19,'CHAM_NO', repk=pfchno)
    ASSERT(pfchno(15:19).eq.'.NUME')
    numddl=pfchno(1:14)
    call dismoi('NOM_MAILLA', numddl, 'NUME_DDL', repk=nommai)
    call gettco(nommai(1:8), typsd)
    if( typsd.ne.'MAILLAGE_P' ) then
        goto 9999
    endif


    nonbjo = numddl//'.NUME.NBJO'
    call jeveuo(nonbjo, 'L', jnbjoi)
    nbjoin = zi(jnbjoi)

    call jeveuo(cn19p//'.VALE','E',jvale)
    call jelira(cn19p//'.VALE','TYPE',cval=ktyp)
    ASSERT(ktyp.eq.'R')
    call jelira(cn19p//'.VALE','LONMAX',neq)


!     on annule les ddl que l'on ne possède pas (les valeurs sont fausses)
!     --------------------------------------------------------------------
      do 10, iaux=1,nbjoin
        numpro=zi(jnbjoi+iaux)
        if ( numpro.eq.-1 ) goto 10

        call codent(iaux-1,'G',chnbjo)
        nojoinr = numddl//'.NUME.R'//chnbjo(1:3)
        call jeveuo(nojoinr, 'L', jjointr)
        call jelira(nojoinr, 'LONMAX', lgrecep, k8bid)
        ASSERT(lgrecep .gt. 0)

        do 50, k=1,lgrecep
          zr(jvale-1+zi(jjointr-1+k))=0.d0
  50    continue

  10  continue


9999 continue

      call jedema()
#endif

      end



