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
! person_in_charge: j-pierre.lefebvre at edf.fr
!
subroutine op0005()
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getmat.h"
#include "asterc/getmjm.h"
#include "asterc/getres.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/aniver.h"
#include "asterfort/codent.h"
#include "asterfort/deprecated_material.h"
#include "asterfort/mateGetList.h"
#include "asterfort/mateReuseMngt.h"
#include "asterfort/mateGetProperties.h"
#include "asterfort/mateInfo.h"
#include "asterfort/getvid.h"
#include "asterfort/indk32.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedupc.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lxlgut.h"
#include "asterfort/rcstoc.h"
#include "asterfort/utmess.h"
#include "asterfort/verif_loi_mater.h"
#include "asterfort/wkvect.h"
!
! --------------------------------------------------------------------------------------------------
!
!   DEFI_MATERIAU
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_mate_elas, i_mate_mfront
    integer :: ifm, niv
    integer :: nb_prop
    integer :: i_mate, jvalrm, jvalcm, jvalkm
    integer :: mate_nb, mate_nb_read
    integer :: nbr, nbc, nbk
    integer :: mateREUSE_nb, mate_shift
    character(len=8) :: mate, mateREUSE
    character(len=16) :: k16bid
    character(len=19) :: noobrc
    character(len=32) :: nomrc
    character(len=32), pointer :: v_mate_read(:) => null()
    character(len=32), pointer :: v_mateREUSE(:) => null()
    character(len=32), pointer :: v_mate(:) => null()
    aster_logical, pointer :: v_mate_func(:) => null()
    aster_logical :: l_mfront_elas, l_elas, l_elas_func, l_elas_istr, l_elas_orth, l_elas_meta
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
    call infniv(ifm, niv)
!
! - Get result
!
    call getres(mate, k16bid, k16bid)
!
! - Get list of materials
!
    call mateGetList(mate_nb_read , v_mate_read  ,&
                     l_mfront_elas,&
                     l_elas       , l_elas_func  , l_elas_istr,&
                     l_elas_orth  , l_elas_meta  ,&
                     i_mate_elas  , i_mate_mfront)
!
! - Manage REUSE
!
    call mateReuseMngt(mate     , mate_nb     , v_mate_read,&
                       mateREUSE, mateREUSE_nb)
    mate_nb = mate_nb_read
!
! - Create NOMRC object
!
    call wkvect(mate//'.MATERIAU.NOMRC', 'G V K32', mate_nb+mateREUSE_nb, vk32 = v_mate)
!
! - Copy old material parameters (from REUSE)
!
    if (mateREUSE_nb .gt. 0) then
        call jeveuo(mateREUSE//'.MATERIAU.NOMRC', 'L', vk32 = v_mateREUSE)
        v_mate(1:mateREUSE_nb) = v_mateREUSE(1:mateREUSE_nb)
    endif
!
! - Save properties (standard)
!
    mate_shift = mateREUSE_nb
    AS_ALLOCATE(vl = v_mate_func, size = mate_nb)
    do i_mate = 1, mate_nb_read
! ----- Get current keyword
        nomrc = v_mate_read(i_mate)
! ----- Get properties for one material factor keyword
        call mateGetProperties(mate      , i_mate , nomrc,&
                               mate_shift, v_mate ,&
                               noobrc    , nb_prop, v_mate_func)
! ----- Create properties for one material factor keyword
        call wkvect(noobrc//'.VALR', 'G V R', nb_prop, jvalrm)
        call wkvect(noobrc//'.VALC', 'G V C', nb_prop, jvalcm)
        call wkvect(noobrc//'.VALK', 'G V K16', 2*nb_prop, jvalkm)
! ----- Read properties for one material factor keyword
        call rcstoc(mate, nomrc, noobrc, nb_prop, zr(jvalrm), zc(jvalcm),&
                    zk16(jvalkm), nbr, nbc, nbk)
! ----- Update length for one material factor keyword
        call jeecra(noobrc//'.VALR', 'LONUTI', nbr)
        call jeecra(noobrc//'.VALC', 'LONUTI', nbc)
        call jeecra(noobrc//'.VALK', 'LONUTI', nbr+nbc+2*nbk)
    end do
!
! - Debug write
!
    call jeveuo(mate//'.MATERIAU.NOMRC', 'L', vk32 = v_mate)
    do i_mate = 1, mate_nb
        call utmess('I', 'MATERIAL2_3', sk = v_mate(i_mate))
    end do
    if (niv .eq. 2) then
        call mateInfo(mate, mate_nb)
    endif
!
!   Vérification que les paramètres matériaux de certaines lois sont corrects
    call verif_loi_mater(mate)
!   
! - Compute eigenvalues for Hooke matrix (check stability)
!
    call aniver(mate, v_mate_func)
!
! - Cleaning
!
    AS_DEALLOCATE(vk32 = v_mate_read)
    AS_DEALLOCATE(vl = v_mate_func)
!
    call jedema()
end subroutine
