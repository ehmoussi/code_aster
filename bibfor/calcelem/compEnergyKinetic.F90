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
subroutine compEnergyKinetic(modelz , ligrel , l_modal,&
                             chdispz, chvitez, chfreqz, chgeom , chmate,&
                             chcara , chmasd , chvarc , &
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
character(len=*), intent(in) :: modelz, ligrel
aster_logical, intent(in) :: l_modal
character(len=*), intent(in) :: chdispz, chvitez, chgeom, chmate, chmasd
character(len=*), intent(in) :: chcara(*), chfreqz
character(len=*), intent(in) :: chvarc
character(len=*), intent(in) :: chelemz, basez
integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Fields computation
!
! Utility to compute ECIN_ELEM
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
    character(len=16) :: option
    character(len=24) :: chdisp, chvite, chfreq, chelem
    integer :: iret
    integer :: nbin, nbout
!
! --------------------------------------------------------------------------------------------------
!
    cara_elem = chcara(1)
    chdisp    = chdispz
    chvite    = chvitez
    chfreq    = chfreqz
    chelem    = chelemz
    codret    = 0
    base      = basez
    model     = modelz
    option    = 'ECIN_ELEM'
    lpain(:)  = ' '
    lchin(:)  = ' '
!
! - Output field
!
    nbout     = 1
    lchout(1) = chelem
    lpaout(1) = 'PENERCR'
!
! - Add input fields
!
    nbin     = 1
    lpain(1) = 'PDEPLAR'
    if (l_modal) then
        lchin(1) = chdisp
    else
        lchin(1) = chvite
    endif
!
! - Fields for structural elements
!
    call ajchca('PNBSP_I', cara_elem//'.CANBSP', lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCACOQU', chcara(7), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCINFDI', chcara(15), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAGNBA', chcara(11), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAGNPO', chcara(6), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAORIE', chcara(1), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCADISM', chcara(3), lpain, lchin, nbin, maxin, 'N')
!
! - Other fields
!
    call ajchca('POMEGA2', chfreq, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PMASDIA', chmasd, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PGEOMER', chgeom, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PMATERC', chmate, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PVARCPR', chvarc, lpain, lchin, nbin, maxin, 'N')
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
