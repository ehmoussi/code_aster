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

subroutine vetnth_nonl(model      , cara_elem   , mate      , time , compor   ,&
                       temp_iter  , varc_curr,&
                       vect_elem_l, vect_elem_nl, base,&
                       dry_prev_  , dry_curr_   , hydr_prev_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/inical.h"
#include "asterfort/gcnco2.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/mecara.h"
#include "asterfort/megeom.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
!
character(len=24), intent(in) :: model
character(len=24), intent(in) :: cara_elem
character(len=24), intent(in) :: mate
character(len=24), intent(in) :: time
character(len=24), intent(in) :: compor
character(len=24), intent(in) :: temp_iter
character(len=19), intent(in) :: varc_curr
character(len=24), intent(in) :: vect_elem_l
character(len=24), intent(in) :: vect_elem_nl
character(len=1),  intent(in) :: base
character(len=24), optional,intent(in) :: dry_prev_
character(len=24), optional,intent(in) :: dry_curr_
character(len=24), optional,intent(in) :: hydr_prev_
!
! --------------------------------------------------------------------------------------------------
!
! Thermic - Residuals
! 
! Evolution for non-linear (CHAR_THER_EVOLNI)
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of the model
! In  cara_elem        : name of elementary characteristics (field)
! In  mate             : name of material characteristics (field)
! In  time             : time (<CARTE>)
! In  compor           : name of <CARTE> COMPOR
! In  temp_iter        : temperature field at current Newton iteration
! In  varc_curr        : command variable for current time
! In  vect_elem_l      : name of vect_elem result (linear part)
! In  vect_elem_nl     : name of vect_elem result (non linear part)
! In  base             : JEVEUX base for object
! In  dry_prev         : previous drying
! In  dry_curr         : current drying
! In  hydr_prev        : previous hydratation
!
! --------------------------------------------------------------------------------------------------
!
    integer , parameter :: nbin = 10
    integer , parameter :: nbout = 2
    character(len=8) :: lpain(nbin), lpaout(nbout)
    character(len=19) :: lchin(nbin), lchout(nbout)
    integer :: iret, ibid
    character(len=8) :: newnom
    character(len=16) :: option
    character(len=24) :: ligrmo
    character(len=19) :: resu_elem_l, resu_elem_nl
    character(len=24) :: chgeom, chcara(18)
    character(len=24) :: hydr_prev, dry_prev, dry_curr
!
! --------------------------------------------------------------------------------------------------
!
    resu_elem_l  = vect_elem_l(1:8)//'.0000000'
    resu_elem_nl = vect_elem_nl(1:8)//'.0000000'
    newnom       = '.0000000'
    option       = 'CHAR_THER_EVOLNI'
    ligrmo       = model(1:8)//'.MODELE'
!
! - Get fields
!
    hydr_prev = ' '
    if (present(hydr_prev_)) then
        hydr_prev = hydr_prev_
    endif
    dry_prev = ' '
    if (present(dry_prev_)) then
        dry_prev = dry_prev_
    endif
    dry_curr = ' '
    if (present(dry_curr_)) then
        dry_curr = dry_curr_
    endif
!
! - Init fields
!
    call inical(nbin, lpain, lchin, nbout, lpaout, lchout)
!
! - Prepare VECT_ELEM
!
    call jeexin(vect_elem_l(1:19)//'.RELR', iret)
    if (iret .eq. 0) then
        call memare(base, vect_elem_l, model, mate, cara_elem, 'MASS_THER')
    else
        call jedetr(vect_elem_l(1:19)//'.RELR')
    endif
    call jeexin(vect_elem_nl(1:19)//'.RELR', iret)
    if (iret .eq. 0) then
        call memare(base, vect_elem_nl, model, mate, cara_elem,&
                    'MASS_THER')
    else
        call jedetr(vect_elem_nl(1:19)//'.RELR')
    endif
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
    lchin(3)  = mate(1:19)
    lpain(4)  = 'PTEMPSR'
    lchin(4)  = time(1:19)
    lpain(5)  = 'PCACOQU'
    lchin(5)  = chcara(7)(1:19)
    lpain(6)  = 'PVARCPR'
    lchin(6)  = varc_curr(1:19)
    lpain(7)  = 'PHYDRPM'
    lchin(7)  = hydr_prev(1:19)
    lpain(8)  = 'PCOMPOR'
    lchin(8)  = compor(1:19)
    lpain(9)  = 'PTMPCHI'
    lchin(9)  = dry_prev(1:19)
    lpain(10) = 'PTMPCHF'
    lchin(10) = dry_curr(1:19)
!
! - Generate new RESU_ELEM name
!
    newnom = resu_elem_nl(10:16)
    call gcnco2(newnom)
    resu_elem_nl(10:16) = newnom(2:8)
!
! - Output fields
!
    lpaout(1) = 'PVECTTI'
    lchout(1) = resu_elem_nl
    call corich('E', lchout(1), -1, ibid)
!
! - Generate new RESU_ELEM name
!
    newnom = resu_elem_l(10:16)
    call gcnco2(newnom)
    resu_elem_l(10:16) = newnom(2:8)
!
! - Output fields
!
    lpaout(2) = 'PVECTTR'
    lchout(2) = resu_elem_l
    call corich('E', lchout(2), -1, ibid)
!
! - Compute
!
    call calcul('S'  , option, ligrmo, nbin  , lchin,&
                lpain, nbout , lchout, lpaout, base ,&
                'OUI')
!
! - Add RESU_ELEM in VECT_ELEM
!
    call reajre(vect_elem_nl, lchout(1), base)
    call reajre(vect_elem_l , lchout(2), base)
!
end subroutine
