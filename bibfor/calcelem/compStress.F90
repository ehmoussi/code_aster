! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine compStress(modelz , ligrel , compor,&
                      chdispz, chgeom , chmate,&
                      chcara , chtime , chharm,&
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
character(len=*), intent(in) :: modelz, ligrel, compor
character(len=*), intent(in) :: chdispz, chgeom, chmate
character(len=*), intent(in) :: chcara(*), chtime, chharm
character(len=*), intent(in) :: chvarc, chvref
character(len=*), intent(in) :: chelemz, basez
integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Fields computation
!
! Utility to compute SIEF_ELGA
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
    character(len=19) :: canbsp, chxfem(12)
    character(len=24) :: chdisp, chelem
    integer :: iret1, nbin, nbout, iret
    integer :: ifiss
!
! --------------------------------------------------------------------------------------------------
!
    chdisp   = chdispz
    chelem   = chelemz
    codret   = 0
    base     = basez
    model    = modelz
    option   = 'SIEF_ELGA'
    lpain(:) = ' '
    lchin(:) = ' '
!
! - Output field
!
    nbout     = 1
    lchout(1) = chelem
    lpaout(1) = 'PCONTRR'
!
! - Preparation for dynamic fields ('sub-points')
!
    cara_elem = chcara(1)
    canbsp = '&&MECALC.NBSP'
    call exisd('CHAM_ELEM_S', canbsp, iret1)
    if (iret1 .ne. 1) then
        call cesvar(cara_elem, ' ', ligrel, canbsp)
    endif
    call copisd('CHAM_ELEM_S', 'V', canbsp, chelem)
!
! - Add input fields
!
    nbin      = 1
    lpain(1)  = 'PDEPLAR'
    lchin(1)  = chdisp
    call ajchca('PABSCUR', chgeom(1:8)//'.ABSC_CURV', lpain, lchin, nbin, maxin, 'N')
!
! - Fields for XFEM
!
    call jeexin(modelz(1:8)//'.FISS', ifiss)
    if (ifiss .ne. 0) then
        chxfem(1) = model(1:8)//'.TOPOSE.PIN'
        chxfem(2) = model(1:8)//'.TOPOSE.CNS'
        chxfem(3) = model(1:8)//'.TOPOSE.HEA'
        chxfem(4) = model(1:8)//'.TOPOSE.LON'
        chxfem(5) = model(1:8)//'.TOPOSE.PMI'
        chxfem(6) = model(1:8)//'.BASLOC'
        chxfem(7) = model(1:8)//'.LNNO'
        chxfem(8) = model(1:8)//'.LTNO'
        chxfem(9) = model(1:8)//'.STNO'
        chxfem(10) = model(1:8)//'.FISSNO'
        chxfem(12) = model(1:8)//'.TOPONO.HNO'
        call ajchca('PPINTTO', chxfem(1), lpain, lchin, nbin, maxin, 'N')
        call ajchca('PCNSETO', chxfem(2), lpain, lchin, nbin, maxin, 'N')
        call ajchca('PHEAVTO', chxfem(3), lpain, lchin, nbin, maxin, 'N')
        call ajchca('PLONCHA', chxfem(4), lpain, lchin, nbin, maxin, 'N')
        call ajchca('PPMILTO', chxfem(5), lpain, lchin, nbin, maxin, 'N')
        call ajchca('PBASLOR', chxfem(6), lpain, lchin, nbin, maxin, 'N')
        call ajchca('PLSN', chxfem(7), lpain, lchin, nbin, maxin, 'N')
        call ajchca('PLST', chxfem(8), lpain, lchin, nbin, maxin, 'N')
        call ajchca('PSTANO', chxfem(9), lpain, lchin, nbin, maxin, 'N')
        call ajchca('PFISNO', chxfem(10), lpain, lchin, nbin, maxin, 'N')
        call ajchca('PHEA_NO', chxfem(12), lpain, lchin, nbin, maxin, 'N')
    endif
!
! - Fields for structural elements
!
    call ajchca('PNBSP_I', cara_elem//'.CANBSP', lpain, lchin, nbin, maxin, 'N')
    call ajchca('PFIBRES', cara_elem//'.CAFIBR', lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAARPO', chcara(9), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCACOQU', chcara(7), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCINFDI', chcara(15), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCADISK', chcara(2), lpain, lchin, nbin, maxin, 'N')
    call ajchca('PCAGEPO', chcara(5), lpain, lchin, nbin, maxin, 'N')
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
