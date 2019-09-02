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
subroutine nmetca(model , mesh     , mate         , hval_incr,&
                  sddisc, nume_inst, ds_errorindic)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infdbg.h"
#include "asterfort/calcul.h"
#include "asterfort/detrsd.h"
#include "asterfort/diinst.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mecact.h"
#include "asterfort/mechti.h"
#include "asterfort/megeom.h"
#include "asterfort/mesomm.h"
#include "asterfort/nmchex.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: model, mate
character(len=19), intent(in) :: hval_incr(*)
character(len=19), intent(in) :: sddisc
integer, intent(in) :: nume_inst
type(NL_DS_ErrorIndic), intent(inout) :: ds_errorindic
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Error indicators
!
! Evaluate THM error (SM)
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! In  mate             : name of material characteristics (field)
! In  hval_incr        : hat-variable for incremental values
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! IO  ds_errorindic    : datastructure for error indicator
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: nbout = 1
    integer, parameter :: nbin = 6
    character(len=8) :: lpaout(nbout), lpain(nbin)
    character(len=19) :: lchout(nbout), lchin(nbin)
    integer, parameter :: npara  = 2
    character(len=8) :: licmp(npara)
    real(kind=8) :: rcmp(npara)
    integer :: iret
    character(len=1) :: base
    character(len=24) :: ligrmo, chgeom, chtime, cartca
    character(len=19) :: sigm_prev, sigm_curr, chelem
    real(kind=8) :: somme(1)
    real(kind=8) :: time_curr, time_prev, deltat
    real(kind=8) :: r8bid
    real(kind=8) :: taberr(2)
    character(len=16) :: option
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_87')
    endif
!
! - Initializations
!
    option = 'ERRE_TEMPS_THM'
    ligrmo = model(1:8)//'.MODELE'
    base   = 'V'
    cartca = '&&NMETCA.GRDCA'
    chelem = '&&NMETCA.ERRE'
!
! - Times
!
    time_curr = diinst(sddisc, nume_inst)
    time_prev = diinst(sddisc, nume_inst-1)
    deltat    = time_curr-time_prev
!
! - Previous errors
!
    taberr(1) = ds_errorindic%erre_thm_loca
    taberr(2) = ds_errorindic%erre_thm_glob
!
! - Stresses
!
    call nmchex(hval_incr, 'VALINC', 'SIGMOI', sigm_prev)
    call nmchex(hval_incr, 'VALINC', 'SIGPLU', sigm_curr)
!
! - For geometry
!
    call megeom(model, chgeom)
!
! - For time
!
    call mechti(mesh, time_curr, r8bid, r8bid, chtime)
!
! - For parameters
!
    licmp(1) = 'X1'
    licmp(2) = 'X2'
    rcmp(1)  = ds_errorindic%adim_l
    rcmp(2)  = ds_errorindic%adim_p
    call mecact(base, cartca, 'MODELE', ligrmo, 'NEUT_R',&
                ncmp=npara, lnomcmp=licmp, vr=rcmp)
!
! - Input fields
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom(1:19)
    lpain(2) = 'PMATERC'
    lchin(2) = mate(1:19)
    lpain(3) = 'PCONTGP'
    lchin(3) = sigm_curr(1:19)
    lpain(4) = 'PCONTGM'
    lchin(4) = sigm_prev(1:19)
    lpain(5) = 'PTEMPSR'
    lchin(5) = chtime(1:19)
    lpain(6) = 'PGRDCA'
    lchin(6) = cartca(1:19)
!
! - Output fields
!
    lpaout(1) = 'PERREUR'
    lchout(1) = chelem
!
! - Compute
!
    call calcul('C', option, ligrmo, nbin, lchin,&
                lpain, nbout, lchout, lpaout, base,&
                'OUI')
!
    call exisd('CHAMP_GD', lchout(1), iret)
    if (iret .eq. 0) then
        call utmess('F', 'CALCULEL2_88', sk=option)
    endif
!
! - Compute
!
    call mesomm(lchout(1), 1, vr=somme)
    taberr(1) = sqrt(deltat*somme(1))
    taberr(2) = sqrt(taberr(2)**2 + taberr(1)**2)
    ds_errorindic%erre_thm_loca = taberr(1)
    ds_errorindic%erre_thm_glob = taberr(2)
!
! - Clean
!
    call detrsd('CARTE'   , cartca)
    call detrsd('CHAMP_GD', chelem)
!
    call jedema()
!
end subroutine
