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
subroutine compStrx(modelz , ligrel , compor    ,&
                    chdispz, chgeom , chmate    , chcara ,&
                    chvarc , chvref , &
                    basez  , chelemz, codret    ,&
                    l_poux_, load_d_, coef_type_, coef_real_, coef_cplx_)
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
#include "asterfort/mechpo.h"
#include "asterfort/jedetc.h"
!
character(len=*), intent(in) :: modelz, ligrel, compor
character(len=*), intent(in) :: chdispz, chgeom, chmate
character(len=*), intent(in) :: chcara(*)
character(len=*), intent(in) :: chvarc, chvref
character(len=*), intent(in) :: chelemz, basez
integer, intent(out) :: codret
aster_logical, intent(in), optional :: l_poux_
character(len=*), intent(in), optional :: load_d_, coef_type_
real(kind=8), intent(in), optional :: coef_real_
complex(kind=8), intent(in), optional :: coef_cplx_
!
! --------------------------------------------------------------------------------------------------
!
! Fields computation
!
! Utility to compute STRX_ELGA
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
    character(len=24) :: chdisp, chelem, chdynr, suropt
    integer :: iret, ifiss
    integer :: nbin, nbout, nbopt
    aster_logical :: l_poux, l_xfem
!
! --------------------------------------------------------------------------------------------------
!
    cara_elem = chcara(1)
    chdisp    = chdispz
    chelem    = chelemz
    codret    = 0
    base      = basez
    model     = modelz
    option    = 'STRX_ELGA'
    lpain(:)  = ' '
    lchin(:)  = ' '
    chdynr    = ' '
    suropt    = ' '
    l_poux    = ASTER_FALSE
    if (present(l_poux_)) then
        l_poux = l_poux_
    endif
!
! - XFEM
!
    call jeexin(modelz(1:8)//'.FISS', ifiss)
    l_xfem = ifiss .gt. 0
    if (l_xfem) then
        codret = 1
        call utmess('A', 'CALCCHAMP_7')
        goto 99
    endif
!
! - Output field
!
    nbout     = 1
    lchout(1) = chelem
    lpaout(1) = 'PSTRXRR'
!
! - Add input fields
!
    nbin      = 1
    lchin(1)  = chdisp
    lpain(1)  = 'PDEPLAR'
!
! - Fields for structural elements
!
    call ajchca('PNBSP_I', cara_elem//'.CANBSP', lpain, lchin, nbin, maxin, 'N')
    call ajchca('PFIBRES', cara_elem//'.CAFIBR', lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAGNPO', chcara(6), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAORIE', chcara(1), lpain, lchin, nbin, maxin, 'N')
!
! - Other fields
!
    call ajchca('PCOMPOR', compor, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PGEOMER', chgeom, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PMATERC', chmate, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PVARCRR', chvref, lpain, lchin, nbin, maxin, 'N')
    call ajchca('PVARCPR', chvarc, lpain, lchin, nbin, maxin, 'N')
!
! - For beams
!
    if (l_poux) then
        call mechpo('&&MECHPO', load_d_, model, chdisp, chdynr,&
                    suropt, lpain(nbin+1), lchin(nbin+1), nbopt, coef_type_,&
                    coef_real_, coef_cplx_)
        nbin = nbin + nbopt
    endif
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
    if (l_poux) then
        call jedetc('V', '&&MECHPO', 1)
    endif
!
99  continue
!
end subroutine
