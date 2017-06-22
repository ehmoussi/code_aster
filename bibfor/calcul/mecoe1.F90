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

subroutine mecoe1(opt, te)

use calcul_module, only : ca_iamloc_, ca_iaoppa_, ca_iawlo2_, ca_igr_,&
     ca_ilmloc_, ca_nbgr_, ca_npario_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterfort/modatt.h"
#include "asterfort/nbpara.h"
#include "asterfort/nopara.h"

    integer :: opt, te
!-----------------------------------------------------------------------
! but : initialisation de '&&CALCUL.IA_CHLO2'
! entrees:
!      opt : option
!      te  : type d'element
!-----------------------------------------------------------------------
    integer :: icode
    integer :: iparg, m2, modloc, nbpoin, nbscal, npara
    integer :: ipar
    character(len=8) :: nompar
!-----------------------------------------------------------------------

!   -- on met a "-1" lgcata pour les parametres inconnus
!      des type_element
    do iparg = 1,ca_npario_
        zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+2)=-1
    end do


    npara = nbpara(opt,te,'IN ')
    do ipar = 1, npara
        nompar = nopara(opt,te,'IN ',ipar)
        iparg = indik8(zk8(ca_iaoppa_),nompar,1,ca_npario_)
        m2 = modatt(opt,te,'IN ',ipar)
        modloc = ca_iamloc_ - 1 + zi(ca_ilmloc_-1+m2)
        icode = zi(modloc-1+1)
        nbscal = zi(modloc-1+3)
        if (icode .le. 3) then
            nbpoin = zi(modloc-1+4)
        else
            nbpoin = 0
        endif

        zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+1)=m2
        zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+2)=nbscal
        zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+3)=nbpoin
    end do


    npara = nbpara(opt,te,'OUT')
    do ipar = 1, npara
        nompar = nopara(opt,te,'OUT',ipar)
        iparg = indik8(zk8(ca_iaoppa_),nompar,1,ca_npario_)
        m2 = modatt(opt,te,'OUT',ipar)
        modloc = ca_iamloc_ - 1 + zi(ca_ilmloc_-1+m2)
        icode = zi(modloc-1+1)
        nbscal = zi(modloc-1+3)
        if (icode .le. 3) then
            nbpoin = zi(modloc-1+4)
        else
            nbpoin = 0
        endif

        zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+1)=m2
        zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+2)=nbscal
        zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+3)=nbpoin
    end do

end subroutine
