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

subroutine wkvect(nom, carac, dim, jadr, vl,&
                  vi, vi4, vr, vc, vk8,&
                  vk16, vk24, vk32, vk80)
! person_in_charge: jacques.pellet at edf.fr
! aslint: disable=W1304
    use iso_c_binding, only: c_loc, c_ptr, c_f_pointer
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jecreo.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/assert.h"
#include "asterfort/jgetptc.h"
!
    character(len=*), intent(in) :: nom
    character(len=*), intent(in) :: carac
    integer, intent(in) :: dim
    integer, intent(out), optional :: jadr
!
    aster_logical, pointer, optional :: vl(:)
    integer, pointer, optional :: vi(:)
    integer(kind=4), pointer, optional :: vi4(:)
    real(kind=8), pointer, optional :: vr(:)
    complex(kind=8), pointer, optional :: vc(:)
    character(len=8), pointer, optional :: vk8(:)
    character(len=16), pointer, optional :: vk16(:)
    character(len=24), pointer, optional :: vk24(:)
    character(len=32), pointer, optional :: vk32(:)
    character(len=80), pointer, optional :: vk80(:)
!
!
! ------------------------------------------------------------------
! Creation d'un vecteur jeveux
! ------------------------------------------------------------------
! in  nom   : ch*24 : nom du vecteur jeveux
! in  carac : ch    : descrivion des caracteristiques pour jecreo
! in  dim   : is    : taille du vecteur
! out jadr  : is    : adresse de l'objet dans ZI, ZR ...
! out vl   : l     : vecteur de logiques
! out vi   : i     : vecteur d'entiers
! ...
! Deux usages differents :
! ------------------------
! 1) recuperation de l'adresse de l'objet 'XXX' (jxxx) dans les COMMON zi, zr, ... :
!    call wkvect('XXX', 'V V R', 10, jxxx)
! 2) recuperation du contenu de l'objet 'XXX' dans le vecteur XXX
!    call wkvect('XXX', 'V V R', 10, vr=XXX)
!-----------------------------------------------------------------------
    integer :: jad
    character(len=8) :: ktyp
    type(c_ptr) :: pc
!---------------------------------------------------------------------------
    call jecreo(nom, carac)
    call jeecra(nom, 'LONMAX', ival=dim)
    call jeecra(nom, 'LONUTI', ival=dim)
    call jeveuo(nom, 'E', jad)
!
!
!     -- cas : on veut l'adresse
    if (present(jadr)) then
        jadr=jad
        goto 999
    endif
!
!
!     -- cas : on veut un pointeur
    call jelira(nom, 'TYPELONG', cval=ktyp)
    if (present(vl)) then
        ASSERT(ktyp.eq.'L')
        call jgetptc(jad, pc, vl=zl(1))
        call c_f_pointer(pc, vl, [dim])
!
    else if (present(vi)) then
        ASSERT(ktyp.eq.'I')
        call jgetptc(jad, pc, vi=zi(1))
        call c_f_pointer(pc, vi, [dim])
!
    else if (present(vi4)) then
        ASSERT(ktyp.eq.'S')
        call jgetptc(jad, pc, vi4=zi4(1))
        call c_f_pointer(pc, vi4, [dim])
!
    else if (present(vr)) then
        ASSERT(ktyp.eq.'R')
        call jgetptc(jad, pc, vr=zr(1))
        call c_f_pointer(pc, vr, [dim])
!
    else if (present(vc)) then
        ASSERT(ktyp.eq.'C')
        call jgetptc(jad, pc, vc=zc(1))
        call c_f_pointer(pc, vc, [dim])
!
    else if (present(vk8)) then
        ASSERT(ktyp.eq.'K8')
        call jgetptc(jad, pc, vk8=zk8(1))
        call c_f_pointer(pc, vk8, [dim])
!
    else if (present(vk16)) then
        ASSERT(ktyp.eq.'K16')
        call jgetptc(jad, pc, vk16=zk16(1))
        call c_f_pointer(pc, vk16, [dim])
!
    else if (present(vk24)) then
        ASSERT(ktyp.eq.'K24')
        call jgetptc(jad, pc, vk24=zk24(1))
        call c_f_pointer(pc, vk24, [dim])
!
    else if (present(vk32)) then
        ASSERT(ktyp.eq.'K32')
        call jgetptc(jad, pc, vk32=zk32(1))
        call c_f_pointer(pc, vk32, [dim])
!
    else if (present(vk80)) then
        ASSERT(ktyp.eq.'K80')
        call jgetptc(jad, pc, vk80=zk80(1))
        call c_f_pointer(pc, vk80, [dim])
!
    else
        ASSERT(.false.)
    endif
!
999 continue
!
end subroutine
