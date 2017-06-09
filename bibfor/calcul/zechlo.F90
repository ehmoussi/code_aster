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

subroutine zechlo(opt, te)
use calcul_module, only : ca_calvoi_, ca_iaoppa_, ca_iawlo2_, ca_iawloc_,&
     ca_iawtyp_, ca_igr_, ca_nbgr_, ca_npario_
implicit none

! person_in_charge: jacques.pellet at edf.fr
#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/nbpara.h"
#include "asterfort/nopara.h"

    integer :: opt, te
!-----------------------------------------------------------------------
!     But:
!      Remettre les champs locaux de sortie a zero (entre 2 grels)
!-----------------------------------------------------------------------
    integer :: np, ipar
    integer :: lggrel, i, iachlo
    integer ::  iparg
    character(len=1) :: typsca
    character(len=8) :: nompar
    integer :: debugr
!----------------------------------------------------------------------

!   -- si calvoi==1 : il n'y a rien a faire car les champs locaux
!      viennent d'etre alloues et sont donc deja a zero.
    if (ca_calvoi_ .eq. 1) goto 9999


    np = nbpara(opt,te,'OUT')
    do ipar = 1, np
        nompar = nopara(opt,te,'OUT',ipar)

        iparg = indik8(zk8(ca_iaoppa_),nompar,1,ca_npario_)
        iachlo=zi(ca_iawloc_-1+3*(iparg-1)+1)
        if (iachlo .eq. -1) cycle

        typsca = zk8(ca_iawtyp_-1+iparg) (1:1)
        ASSERT(typsca.eq.'R'.or.typsca.eq.'C'.or.typsca.eq.'I')

        lggrel=zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+4)
        debugr=zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+5)
        ASSERT(debugr.eq.1)


        if (typsca .eq. 'R') then
            do i = 1, lggrel
                zr(iachlo-1+i) = 0.0d0
            enddo
        else if (typsca.eq.'C') then
            do i = 1, lggrel
                zc(iachlo-1+i) = dcmplx(0.d0,0.d0)
            enddo
        else if (typsca.eq.'I') then
            do i = 1, lggrel
                zi(iachlo-1+i) = 0
            enddo
        endif
    end do

9999  continue
end subroutine
