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
! aslint: disable=W1504
! person_in_charge: mickael.abbas at edf.fr
!
subroutine varcCalcPrep(modelz    , cara_elemz, matez     ,&
                        nume_harm , time_comp ,&
                        l_temp    , l_meta    ,&
                        varc_refez, varc_prevz, varc_currz,&
                        comporz   , mult_compz, chsithz   ,&
                        sigmz     , variz     ,&
                        mxchin    , mxchout   ,&
                        nbin      , nbout     ,&
                        lpain     , lchin     ,&
                        lpaout    , lchout)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/exixfe.h"
#include "asterfort/megeom.h"
#include "asterfort/nmvcex.h"
#include "asterfort/mecara.h"
#include "asterfort/meharm.h"
#include "asterfort/xajcin.h"
#include "asterfort/detrsd.h"
#include "asterfort/alchml.h"
!
character(len=*), intent(in) :: modelz, cara_elemz, matez
aster_logical, intent(in) :: l_temp, l_meta
integer, intent(in) :: nume_harm
character(len=1), intent(in) :: time_comp
character(len=*), intent(in) :: varc_refez, varc_prevz, varc_currz
character(len=*), intent(in) :: comporz, mult_compz, chsithz
character(len=*), intent(in) :: sigmz, variz
integer, intent(in) :: mxchin, mxchout
integer, intent(out) :: nbin, nbout
character(len=8), intent(out)  :: lpaout(mxchout), lpain(mxchin)
character(len=19), intent(out)  :: lchout(mxchout), lchin(mxchin)
!
! --------------------------------------------------------------------------------------------------
!
! Material - External state variables (VARC)
!
! Preparation to compute elementary vectors
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  mate             : name of material characteristics (field)
! In  nume_harm        : Fourier harmonic number
! In  time_comp        :  '-' or '+' for command variables evaluation
! In  l_temp           : for temperature
! In  l_meta           : for metallurgy
! In  varc_refe        : name of reference command variables vector
! In  varc_prev        : command variables at previous step
! In  varc_curr        : command variables at current step
! In  compor           : name of comportment definition (field)
! In  mult_comp        : multi-comportment (DEFI_COMPOR for PMF)
! In  chsith           : commande variable for temperature in XFEM
! In  sigm             : stress
! In  vari             : internal variables
! In  mxchin           : maximum number of input fields
! In  mxchout          : maximum number of output fields
! Out nbin             : effective number of input fields
! Out nbout            : effective number of output fields
! In  base             : JEVEUX base to create objects
! In  vect_elem        : name of elementary vectors
! Out lpain            : list of input parameters
! Out lchin            : list of input fields
! Out lpaout           : list of output parameters
! Out lchout           : list of output fields
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    aster_logical :: l_xfem
    character(len=8) :: model
    character(len=24) :: cara_elem, mate
    character(len=19) :: ligrmo
    character(len=24) :: chgeom, chcara(18), chharm
    character(len=24) :: vrcref, vrcmoi, vrcplu, time_curr, time_prev
!
! --------------------------------------------------------------------------------------------------
!
    model     = modelz
    cara_elem = cara_elemz
    mate      = matez
    nbin      = 0
    nbout     = 0
    lpaout(:) = ' '
    lpain(:)  = ' '
    lchout(:) = ' '
    lchin(:)  = ' '
!
! - Initializations
!
    call exixfe(model, iret)
    l_xfem = iret.ne.0
    ligrmo = model(1:8)//'.MODELE'
    chharm = '&&NMVCPR.CHHARM'
!
! - Get fields for external state variables
!
    call nmvcex('TOUT', varc_refez, vrcref)
    if (time_comp .eq. '-') then
        call nmvcex('TOUT', varc_prevz, vrcmoi)
    elseif (time_comp .eq. '+') then
        call nmvcex('TOUT', varc_prevz, vrcmoi)
        call nmvcex('TOUT', varc_currz, vrcplu)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Get fields for time
!
    if (time_comp .eq. '-') then
        call nmvcex('INST', varc_prevz, time_prev)
    elseif (time_comp .eq. '+') then
        call nmvcex('INST', varc_currz, time_curr)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Geometry field
!
    call megeom(model, chgeom)
!
! - Elementary characteristics
!
    call mecara(cara_elem, chcara)
!
! - Fourier
!
    call meharm(model, nume_harm, chharm)
!
! - Input fields
!
    lpain(1)  = 'PVARCRR'
    lchin(1)  = vrcref(1:19)
    lpain(2)  = 'PGEOMER'
    lchin(2)  = chgeom(1:19)
    lpain(3)  = 'PMATERC'
    lchin(3)  = mate(1:19)
    lpain(4)  = 'PCACOQU'
    lchin(4)  = chcara(7)(1:19)
    lpain(5)  = 'PCAGNPO'
    lchin(5)  = chcara(6)(1:19)
    lpain(6)  = 'PCADISM'
    lchin(6)  = chcara(3)(1:19)
    lpain(7)  = 'PCAORIE'
    lchin(7)  = chcara(1)(1:19)
    lpain(8)  = 'PCAGNBA'
    lchin(8)  = chcara(11)(1:19)
    lpain(9)  = 'PCAARPO'
    lchin(9)  = chcara(9)(1:19)
    lpain(10) = 'PCAMASS'
    lchin(10) = chcara(12)(1:19)
    lpain(11) = 'PCAGEPO'
    lchin(11) = chcara(5)(1:19)
    lpain(12) = 'PCONTMR'
    lchin(12) = sigmz(1:19)
    lpain(13) = 'PVARIPR'
    lchin(13) = variz(1:19)
    lpain(14) = 'PNBSP_I'
    lchin(14) = chcara(1) (1:8)//'.CANBSP'
    lpain(15) = 'PFIBRES'
    lchin(15) = chcara(1) (1:8)//'.CAFIBR'
    lpain(16) = 'PHARMON'
    lchin(16) = chharm(1:19)
    nbin = 16
!
! - Behaviour => only for metallurgy (non-linear)
!
    nbin = nbin + 1
    lpain(nbin) = 'PCOMPOR'
    if (l_meta) then
        lchin(nbin) = comporz(1:19)
    else
        lchin(nbin) = mult_compz(1:19)
    endif
!
! - Computation of elementary vectors - Previous
!
    if (time_comp .eq. '-') then
        nbin = nbin + 1
        lpain(nbin) = 'PTEMPSR'
        lchin(nbin) = time_prev(1:19)
        nbin = nbin + 1
        lpain(nbin) = 'PVARCPR'
        lchin(nbin) = vrcmoi(1:19)
    elseif (time_comp .eq. '+') then
        nbin = nbin + 1
        lpain(nbin) = 'PTEMPSR'
        lchin(nbin) = time_curr(1:19)
        nbin = nbin + 1
        lpain(nbin) = 'PVARCPR'
        lchin(nbin) = vrcplu(1:19)
        nbin = nbin + 1
        lpain(nbin) = 'PVARCMR'
        lchin(nbin) = vrcmoi(1:19)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - XFEM input fields
!
    if (l_xfem .and. l_temp) then
        call xajcin(model, 'CHAR_MECA_TEMP_R', mxchin, lchin, lpain, nbin) 
    endif
!
! - Output fields
!
    lpaout(1) = 'PVECTUR'
    nbout = 1
!
! - XFEM output field
!
    if (l_xfem .and. l_temp) then
        call detrsd('CHAM_ELEM', chsithz)
        call alchml(ligrmo, 'SIEF_ELGA', 'PCONTRR', 'V', chsithz, iret, ' ')
        nbout = nbout+1
        lpaout(nbout) = 'PCONTRT'
    endif
!
end subroutine
