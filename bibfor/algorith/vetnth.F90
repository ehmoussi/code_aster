! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine vetnth(model    , cara_elem, mate     , mateco     , time ,&
                  temp_iter, varc_curr, vect_elem, base)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/exisd.h"
#include "asterfort/exixfe.h"
#include "asterfort/gcnco2.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/mecara.h"
#include "asterfort/megeom.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
#include "asterfort/xajcin.h"
#include "asterfort/inical.h"
!
character(len=24), intent(in) :: model
character(len=24), intent(in) :: cara_elem
character(len=24), intent(in) :: mateco, mate
character(len=24), intent(in) :: time
character(len=24), intent(in) :: temp_iter
character(len=19), intent(in) :: varc_curr
character(len=24), intent(in) :: vect_elem
character(len=1), intent(in) :: base
!
! --------------------------------------------------------------------------------------------------
!
! Thermic - Residuals
!
! Evolution for non-linear (CHAR_THER_EVOL)
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of the model
! In  cara_elem        : name of elementary characteristics (field)
! In  mate             : name of matecorial characteristics (field)
! In  time             : time (<CARTE>)
! In  temp_iter        : temperature field at current Newton iteration
! In  varc_curr        : command variable for current time
! In  vect_elem        : name of vect_elem result
! In  base             : JEVEUX base for object
!
! --------------------------------------------------------------------------------------------------
!
    integer , parameter :: nb_in_maxi = 24
    integer , parameter :: nbout = 1
    character(len=8) :: lpain(nb_in_maxi), lpaout(nbout)
    character(len=19) :: lchin(nb_in_maxi), lchout(nbout)
    integer :: iret, ibid, nbin
    character(len=8) :: newnom
    character(len=16) :: option
    character(len=24) :: ligrmo
    character(len=19) :: resu_elem
    character(len=24) :: chgeom, chcara(18)
    aster_logical :: l_xfem
!
! --------------------------------------------------------------------------------------------------
!
    resu_elem = vect_elem(1:8)//'.0000000'
    newnom    = '.0000000'
    option    = 'CHAR_THER_EVOL'
    ligrmo    = model(1:8)//'.MODELE'
    call exixfe(model, iret)
    l_xfem = (iret .ne. 0)
!
! - Init fields
!
    call inical(nb_in_maxi, lpain, lchin, nbout, lpaout, lchout)
!
! - Prepare VECT_ELEM
!
    call jeexin(vect_elem(1:19)//'.RELR', iret)
    if (iret .eq. 0) then
        call memare(base, vect_elem, model, mate, cara_elem, 'MASS_THER')
    else
        call jedetr(vect_elem(1:19)//'.RELR')
    endif
!
! - Generate new RESU_ELEM name
!
    newnom = resu_elem(10:16)
    call gcnco2(newnom)
    resu_elem(10:16) = newnom(2:8)
!
! - Geometry field
!
    call megeom(model, chgeom)
!
! - Elementary characteristics field
!
    call mecara(cara_elem, chcara)
!
! - Input fields
!
    lpain(1)  = 'PGEOMER'
    lchin(1)  = chgeom(1:19)
    lpain(2)  = 'PTEMPER'
    lchin(2)  = temp_iter(1:19)
    lpain(3)  = 'PMATERC'
    lchin(3)  = mateco(1:19)
    lpain(4)  = 'PTEMPSR'
    lchin(4)  = time(1:19)
    lpain(5)  = 'PCACOQU'
    lchin(5)  = chcara(7)(1:19)
    lpain(6)  = 'PVARCPR'
    lchin(6)  = varc_curr(1:19)
    lpain(7)  = 'PCAMASS'
    lchin(7)  = chcara(12)(1:19)
    nbin = 7
    if (l_xfem) then
        call xajcin(model, option, nb_in_maxi, lchin, lpain,&
                    nbin)
    endif
!
! - Output fields
!
    lpaout(1) = 'PVECTTR'
    lchout(1) = resu_elem
    call corich('E', lchout(1), -1, ibid)
!
! - Compute
!
    call calcul('S'  , option, ligrmo, nbin  , lchin,&
                lpain, nbout , lchout, lpaout, base ,&
                'OUI')
!
! - Add RESU_ELEM in VECT_ELEM
!
    call reajre(vect_elem, lchout(1), base)
!
end subroutine
