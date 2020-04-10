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
subroutine plateChckHomo(l_nonlin, option, lcqhom)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/jevech.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvalb.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
!
aster_logical, intent(in) :: l_nonlin
character(len=*), intent(in) :: option
aster_logical, intent(out) :: lcqhom
!
! --------------------------------------------------------------------------------------------------
!
! Plate elements
!
! Check consistency between DEFI_COQU_MULT/AFFE_CARA_ELEM
!
! --------------------------------------------------------------------------------------------------
!
! In  l_nonlin         : flag for non-linear cases
! Out lcqhom           : flag for multi-layers plate
!
! --------------------------------------------------------------------------------------------------
!
    integer :: codret(1), kpg, spt, iret
    integer :: jv_mate, jv_cacoqu, jv_pnbsp 
    integer :: i_layer, nb_layer, vali(2)
    real(kind=8) :: thick_lay(1), thick_tot, valr(2), thick
    character(len=2) :: layer_name
    character(len=3) :: layer_nume
    character(len=16) :: para_name
    character(len=8) :: fami, poum
    character(len=32) :: phenom
!
! --------------------------------------------------------------------------------------------------
!
    fami         = 'FPG1'
    kpg          = 1
    spt          = 1
    poum         = '+'
    jv_pnbsp     = 0
    lcqhom       = ASTER_FALSE
    i_layer      = 0
    thick_tot    = 0.d0
    thick_lay(1) = 0.d0
!
! - Input fields
!
    call tecach('NNO', 'PNBSP_I', 'L', iret, iad=jv_pnbsp)
!
! - Homogenized plate ?
!
    if (l_nonlin .or. option(1:9) .eq. 'RIGI_MECA') then
        call jevech('PMATERC', 'L', jv_mate)
        call rccoma(zi(jv_mate), 'ELAS', 1, phenom, codret(1))
        if ((phenom.eq.'ELAS_COQUE') .or. (phenom.eq.'ELAS_COQMU') .or.&
            (phenom.eq.'ELAS_ORTH')) then
            lcqhom = ASTER_TRUE
        endif
    else
        iret = 1
    endif
!
! - Check between DEFI_COQU_MULT/AFFE_CARA_ELEM
!
    if (iret .eq. 0) then
! ----- Get thickness of plate
        call jevech('PCACOQU', 'L', jv_cacoqu)
        thick        = zr(jv_cacoqu)
! ----- Number of layers
        nb_layer     = zi(jv_pnbsp)
10      continue
! ----- Get current layer
        i_layer = i_layer + 1
        call codent(i_layer, 'G', layer_nume)
        call codent(1, 'G', layer_name)
        para_name = 'C'//layer_nume//'_V'//layer_name
! ----- Get thickness of layer
        call rcvalb(fami, kpg, spt, poum, zi(jv_mate),&
                    ' ', 'ELAS_COQMU', 0, ' ', [0.d0],&
                    1, para_name, thick_lay, codret, 0)
        if (codret(1) .eq. 0) then
            thick_tot = thick_tot + thick_lay(1)
            goto 10
        endif
        if (nint(thick_tot) .ne. 0) then
            if ((i_layer-1) .ne. nb_layer) then
                vali(1) = i_layer-1
                vali(2) = nb_layer
                call utmess('F', 'PLATE1_2', ni=2, vali=vali)
            endif
            if (abs(thick-thick_tot)/thick .gt. 1.d-2) then
                valr(1) = thick_tot
                valr(2) = thick
                call utmess('F', 'PLATE1_3', nr=2, valr=valr)
            endif
        endif
    endif
!
end subroutine
