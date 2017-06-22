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

subroutine nlvint(sd_nl_)
    implicit none
! nlvint : create the internal variables real vector and its corresponding
!          index
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nlget.h"
#include "asterfort/nlinivec.h"
!
!   -0.1- Input/output arguments
    character(len=*) , intent(in) :: sd_nl_
!
!   -0.2- Local variables
    integer           :: i, mxlevel, nltype_i, add, vint_reclen
    character(len=8)  :: sd_nl
    integer, pointer  :: vindx(:) => null()   
!
    call jemarq()
!
    sd_nl  = sd_nl_
!
    call nlget   (sd_nl, _MAX_LEVEL, iscal=mxlevel)
    call nlinivec(sd_nl, _INTERNAL_VARS_INDEX, mxlevel+1, vi=vindx)
    vindx(1) = 1
    do i =1, mxlevel
        call nlget(sd_nl, _NL_TYPE, iocc=i, iscal=nltype_i)
        select case (nltype_i)
            case(NL_CHOC)
                add = NBVARINT_CHOC
            case(NL_BUCKLING)
                add = NBVARINT_FLAM
            case(NL_ANTI_SISMIC)
                add = NBVARINT_ANTS
            case(NL_DIS_VISC)
                add = NBVARINT_DVIS
            case(NL_DIS_ECRO_TRAC)
                add = NBVARINT_DECR
            case(NL_CRACKED_ROTOR)
                add = NBVARINT_ROTF
            case(NL_LUBRICATION)
                add = NBVARINT_LUB
            case(NL_FX_RELATIONSHIP)
                add = NBVARINT_FXRL
            case(NL_FV_RELATIONSHIP)
                add = NBVARINT_FVRL
            case(NL_YACS)
                add = NBVARINT_YACS
 
            case default
                ASSERT(.false.)
        end select
        vindx(i+1) = vindx(i)+add
    end do

    vint_reclen = vindx(mxlevel+1)-1
    call nlinivec(sd_nl, _INTERNAL_VARS, vint_reclen)

    call jedema()
end subroutine
