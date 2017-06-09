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

subroutine op0013()
    implicit none
!
!
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/gettco.h"
#include "asterfort/assvec.h"
#include "asterfort/getvid.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jecreo.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=8) :: nu, vecas, vprof
    character(len=16) :: typv, oper
    integer :: type
!
!     FONCTIONS JEVEUX
!
!
!
!
    character(len=19) :: ch19
!-----------------------------------------------------------------------
    integer :: i, ibid, ifm,  ilivec, nbvec, niv
    real(kind=8), pointer :: licoef(:) => null()
!
!-----------------------------------------------------------------------
    call jemarq()
!
    call infmaj()
    call infniv(ifm, niv)
    call getres(vecas, typv, oper)
!
    call getvid(' ', 'VECT_ELEM', nbval=0, nbret=nbvec)
    nbvec = -nbvec
!
!
    call jecreo(vecas//'.LI2VECEL', 'V V K8 ')
    call jeecra(vecas//'.LI2VECEL', 'LONMAX', nbvec)
    call jeveuo(vecas//'.LI2VECEL', 'E', ilivec)
    call getvid(' ', 'VECT_ELEM', nbval=nbvec, vect=zk8(ilivec))
    call gettco(zk8(ilivec), typv)
    if (typv(16:16) .eq. 'R') type=1
    if (typv(16:16) .eq. 'C') type=2
!
!
    call jecreo(vecas//'.LICOEF', 'V V R ')
    call jeecra(vecas//'.LICOEF', 'LONMAX', nbvec)
    call jeveuo(vecas//'.LICOEF', 'E', vr=licoef)
    do 5 i = 1, nbvec
        licoef(i) = 1.0d0
 5  end do
!
    call getvid(' ', 'NUME_DDL', scal=nu, nbret=ibid)
    vprof = '        '
    call assvec('G', vecas, nbvec, zk8(ilivec), licoef,&
                nu, vprof, 'ZERO', type)
    ch19 = vecas
    call jedetr(ch19//'.LILI')
    call jedetr(ch19//'.ADNE')
    call jedetr(ch19//'.ADLI')
!
    call jedema()
end subroutine
