! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
!
subroutine compEnergyPotential(option , modelz , ligrel, compor, l_temp,&
                               chdispz, chtempz,&
                               chharm , chgeom , chmate, chcara, chtime,&
                               chvarc , chvref , &
                               basez  , chelemz, codret)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/ajchca.h"
#include "asterfort/assert.h"
#include "asterfort/cesvar.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/exisd.h"
#include "asterfort/jeexin.h"
#include "asterfort/meceuc.h"
#include "asterfort/utmess.h"
!
character(len=*), intent(in) :: option, modelz, ligrel, compor
aster_logical, intent(in) :: l_temp
character(len=*), intent(in) :: chdispz, chtempz
character(len=*), intent(in) :: chharm, chgeom, chmate, chcara(*), chtime
character(len=*), intent(in) :: chvarc, chvref
character(len=*), intent(in) :: chelemz, basez
integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Fields computation
!
! Utility to compute ETHE_ELEM and EPOT_ELEM
!
! --------------------------------------------------------------------------------------------------
!
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: maxin=65, maxout=1
    character(len=8) :: lpain(maxin), lpaout(maxout)
    character(len=24) :: lchin(maxin), lchout(maxout)
    character(len=1) :: base
    character(len=8) :: model, cara_elem
    character(len=24) :: chdisp, chelem, chtemp
    integer :: iret
    integer :: nbin, nbout
!
! --------------------------------------------------------------------------------------------------
!
    cara_elem = chcara(1)
    chtemp    = chtempz
    chdisp    = chdispz
    chelem    = chelemz
    codret    = 0
    base      = basez
    model     = modelz
    lpain(:)  = ' '
    lchin(:)  = ' '
!
! - Output field
!
    nbout     = 1
    lchout(1) = chelem
    lpaout(1) = 'PENERDR'
!
! - Add input fields
!
    nbin     = 1
    
    if (l_temp) then
        lpain(1) = 'PTEMPER'
        lchin(1) = chtemp
    else
        lpain(1) = 'PDEPLAR'
        lchin(1) = chdisp
    endif
!
! - Fields for structural elements
!
    call ajchca('PNBSP_I', cara_elem//'.CANBSP', lpain, lchin, nbin, maxin, 'N')
    call ajchca('PFIBRES', cara_elem//'.CAFIBR', lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCACOQU', chcara(7), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCINFDI', chcara(15), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCADISK', chcara(2), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAGNBA', chcara(11), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAGNPO', chcara(6), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAMASS', chcara(12), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAORIE', chcara(1), lpain, lchin, nbin, maxin, 'N')
!
! - Other fields
!
    call ajchca('PCOMPOR', compor, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PGEOMER', chgeom, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PHARMON', chharm, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PMATERC', chmate, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PVARCRR', chvref, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PVARCPR', chvarc, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PTEMPSR', chtime, lpain, lchin, nbin, maxin, 'N')
!
! - Computation (with preparation for COMPLEX fields)
!
    call meceuc('C'   , option, cara_elem, ligrel,&
                nbin  , lchin , lpain    ,&
                nbout , lchout, lpaout   , base)
    call exisd('CHAMP_GD', lchout(1), iret)
    if (iret .eq. 0) then
        codret = 1
        call utmess('A', 'CALCCHAMP_89', sk=option)
    endif
!
! - Clean
!
    call detrsd('CHAM_ELEM_S', chelem)
!
end subroutine
