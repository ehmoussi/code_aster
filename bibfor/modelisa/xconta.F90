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

subroutine xconta(sdcont, mesh, model, nb_dim)
!
implicit none
!
#include "asterfort/celces.h"
#include "asterfort/cescel.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/imprsd.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mminfi.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/xbarvi.h"
#include "asterfort/xdefco.h"
#include "asterfort/xxconi.h"
!
!
    character(len=8), intent(in) :: sdcont
    integer, intent(in) :: nb_dim
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
!
! --------------------------------------------------------------------------------------------------
!
! XFEM - Contact definition
!
! Preparing informations for linear relations
!
! --------------------------------------------------------------------------------------------------
!
! In  model          : name of model
! In  mesh           : name of mesh
! In  nb_dim         : dimension of space
! In  sdcont         : name of contact datastructure 
! In  sdline         : name of datastructure  for linear relations
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_crack_max
    parameter    (nb_crack_max=100)
!
    integer :: i_crack, algo_lagr, izone
    integer :: nb_crack, nb_elem, ibid
    character(len=8) :: crack
    character(len=24) :: sdcont_defi, sdline
    character(len=14) :: sdline_crack
    character(len=19) :: faclon, ainter, tabai
    character(len=8), pointer :: v_crack(:) => null()
    integer, pointer :: v_crack_nb(:) => null()
    character(len=24), pointer :: v_sdline(:) => null()
    integer, pointer :: v_dummy(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    sdcont_defi = sdcont(1:8)//'.CONTACT'
    faclon = '&&XCONTA.FACLON'
    ainter = '&&XCONTA.AINTER'
    tabai  = '&&XCONTA.TABAI'
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi=nb_elem)
!
! - Access to cracks datastructure
!
    call jeveuo(model(1:8)//'.FISS', 'L', vk8=v_crack)
    call jeveuo(model(1:8)//'.NFIS', 'L', vi=v_crack_nb)
    nb_crack = v_crack_nb(1)
    if (nb_crack .gt. nb_crack_max) then
        call utmess('F', 'XFEM_2', si=nb_crack_max)
    endif
!
! - Create datastructure for linear relation
!
    sdline = sdcont_defi(1:16)//'.XNRELL'
    call wkvect(sdline, 'G V K24', nb_crack, vk24 = v_sdline)
!
! - Datstructure to count cracks for multi-heaviside
!
    call wkvect('&&XCONTA.NBSP', 'V V I', nb_elem, vi = v_dummy)
!
! - Convert TRANSFO CHAM_ELEM -> CHAM_ELEM_S
!
    call celces(model//'.TOPOFAC.LO', 'V', faclon)
    call celces(model//'.TOPOFAC.AI', 'V', ainter)
!
! - Select Lagrange multiplier space for contact
!
    do i_crack = 1, nb_crack
!
! ----- Current crack
!
        crack = v_crack(i_crack)
!
! ----- Datastructure name for current crack
!
        sdline_crack = crack(1:8)//'.LISEQ'
        v_sdline(i_crack) = sdline_crack
!
! ----- Contact zone
!
        izone = xxconi(sdcont_defi,crack,'MAIT')
!
! ----- Linear relation type
!
        algo_lagr = mminfi(sdcont_defi,'XFEM_ALGO_LAGR',izone )
!
! ----- Lagrange multiplier space selection
!
        call xdefco(mesh        , model, crack, algo_lagr, nb_dim,&
                    sdline_crack, tabai)
!
! ----- "ARETE VITALE" detection
!
        call xbarvi(mesh, model, crack, faclon, ainter, tabai)
    end do
!
! - Convert CHAM_ELEM_S -> CHAM_ELEM
!
    call cescel(ainter, model//'.MODELE', 'TOPOFA', 'PAINTER', 'OUI',&
                ibid, 'G', model//'.TOPOFAC.AI', 'F', ibid)
!
    call jedetr('&&XCONTA.NBSP')
    call detrsd('CHAM_ELEM_S', faclon)
    call detrsd('CHAM_ELEM_S', ainter)
!
    call jedema()
end subroutine
