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
subroutine mateInfo(mate, mate_nb)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
!
character(len=8), intent(in) :: mate
integer, intent(in) :: mate_nb
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_MATERIAU
!
! Print properties
!
! --------------------------------------------------------------------------------------------------
!
! In  mate             : name of output datastructure
! In  mate_nb          : number of material properties
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6) :: nom
    character(len=19) :: noobrc
    integer :: i_mate, ifm, niv, i
    character(len=32), pointer :: v_mate(:) => null()
    character(len=16), pointer :: v_mate_valk(:) => null()
    complex(kind=8), pointer :: v_mate_valc(:) => null()
    real(kind=8), pointer :: v_mate_valr(:) => null()
    integer :: nbk, nbr, nbc, nbk2
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    call jeveuo(mate//'.MATERIAU.NOMRC', 'L', vk32 = v_mate)
    do i_mate = 1, mate_nb
        call codent(i_mate, 'D0', nom)
        noobrc = mate//'.CPT.'//nom
        call jeveuo(noobrc//'.VALR', 'L', vr   = v_mate_valr)
        call jeveuo(noobrc//'.VALC', 'L', vc   = v_mate_valc)
        call jeveuo(noobrc//'.VALK', 'L', vk16 = v_mate_valk)
        call jelira(noobrc//'.VALR', 'LONUTI', nbr)
        call jelira(noobrc//'.VALC', 'LONUTI', nbc)
        call jelira(noobrc//'.VALK', 'LONUTI', nbk2)
        nbk = (nbk2-nbr-nbc)/2
        call utmess('I', 'MATERIAL2_4', sk = v_mate(i_mate))
        write(ifm,'(5(3X,A16,5X))')     (v_mate_valk(i),i=1,nbr)
        write(ifm,'(5(3X,G16.9,5X))')   (v_mate_valr(i),i=1,nbr)
        write(ifm,'(5(3X,A16,16X,5X))') (v_mate_valk(i),i=nbr+1,nbr+nbc)
        write(ifm,'(5(3X,2G16.9))')     (v_mate_valc(i),i=nbr+1,nbr+nbc)
        write(ifm,'(5(3X,A16,5X))')     (v_mate_valk(i),i=nbr+nbc+1,nbr+nbc+nbk)
        write(ifm,'(5(3X,A16,5X))')     (v_mate_valk(i),i=nbr+nbc+nbk+1,nbr+nbc+2*nbk)
        write(ifm,'(1X)')
    end do
!
end subroutine
