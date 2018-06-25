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

subroutine as_deallocate(vl, vi, vi4, vr, vc,&
                         vk8, vk16, vk24, vk32, vk80,&
                         strdbg)
    use allocate_module
! person_in_charge: jacques.pellet at edf.fr
! aslint: disable=W0104,W1304
!
    implicit none
#include "asterf_types.h"
#include "asterf_debug.h"
#include "jeveux_private.h"
#include "asterc/hpalloc.h"
#include "asterfort/assert.h"
#include "asterfort/jeimpm.h"
#include "asterfort/jjldyn.h"
#include "asterfort/jxlocs.h"
#include "asterfort/utmess.h"
!
    aster_logical, optional, pointer :: vl(:)
    integer, optional, pointer :: vi(:)
    integer(kind=4), optional, pointer :: vi4(:)
    real(kind=8), optional, pointer :: vr(:)
    complex(kind=8), optional, pointer :: vc(:)
    character(len=8), optional, pointer :: vk8(:)
    character(len=16), optional, pointer :: vk16(:)
    character(len=24), optional, pointer :: vk24(:)
    character(len=32), optional, pointer :: vk32(:)
    character(len=80), optional, pointer :: vk80(:)
!
    character(len=*) :: strdbg
!
! ----------------------------------------------------------------------
! DESALLOUER un vecteur de travail
!
! INOUT vl      : vecteur de logiques
! INOUT vi      : vecteur d'entiers
! INOUT vi4     : vecteur d'entiers 4
! INOUT vr      : vecteur de reels 8
! INOUT vc      : vecteur de complexes 16
! INOUT vk8     : vecteur de k8
! INOUT vk16    : vecteur de k16
! ...
! ----------------------------------------------------------------------
    integer :: ierr, lonty, lsic, lonvec
    character(len=4) :: typv
!
! -------------------------------------------------------------------
    if (present(vi)) then
        typv='I'
        lonty=lois
    else if (present(vi4)) then
        typv='S'
        lonty=4
    else if (present(vl)) then
        typv='L'
        lonty=lois
    else if (present(vr)) then
        typv='R'
        lonty=8
    else if (present(vc)) then
        typv='C'
        lonty=16
    else if (present(vk8)) then
        typv='K8'
        lonty=8
    else if (present(vk16)) then
        typv='K16'
        lonty=16
    else if (present(vk24)) then
        typv='K24'
        lonty=24
    else if (present(vk32)) then
        typv='K32'
        lonty=32
    else if (present(vk80)) then
        typv='K80'
        lonty=80
    else
        ASSERT(.false.)
    endif
!
!   -- taille du vecteur :
!   ----------------------------
    lonvec=0
    if (typv .eq. 'I') then
        if (associated(vi)) lonvec=size(vi)
    else if (typv.eq.'S') then
        if (associated(vi4)) lonvec=size(vi4)
    else if (typv.eq.'L') then
        if (associated(vl)) lonvec=size(vl)
    else if (typv.eq.'R') then
        if (associated(vr)) lonvec=size(vr)
    else if (typv.eq.'C') then
        if (associated(vc)) lonvec=size(vc)
    else if (typv.eq.'K8') then
        if (associated(vk8)) lonvec=size(vk8)
    else if (typv.eq.'K16') then
        if (associated(vk16)) lonvec=size(vk16)
    else if (typv.eq.'K24') then
        if (associated(vk24)) lonvec=size(vk24)
    else if (typv.eq.'K32') then
        if (associated(vk32)) lonvec=size(vk32)
    else if (typv.eq.'K80') then
        if (associated(vk80)) lonvec=size(vk80)
!
    else
        ASSERT(.false.)
    endif
!
!   -- on desalloue le vecteur :
!   ----------------------------
    ierr=1
    if (typv .eq. 'I') then
        call deallocate_slvec(vi=vi, ierr=ierr)
    else if (typv.eq.'S') then
        call deallocate_slvec(vi4=vi4, ierr=ierr)
    else if (typv.eq.'L') then
        call deallocate_slvec(vl=vl, ierr=ierr)
    else if (typv.eq.'R') then
        call deallocate_slvec(vr=vr, ierr=ierr)
    else if (typv.eq.'C') then
        call deallocate_slvec(vc=vc, ierr=ierr)
    else if (typv.eq.'K8') then
        call deallocate_slvec(vk8=vk8, ierr=ierr)
    else if (typv.eq.'K16') then
        call deallocate_slvec(vk16=vk16, ierr=ierr)
    else if (typv.eq.'K24') then
        call deallocate_slvec(vk24=vk24, ierr=ierr)
    else if (typv.eq.'K32') then
        call deallocate_slvec(vk32=vk32, ierr=ierr)
    else if (typv.eq.'K80') then
        call deallocate_slvec(vk80=vk80, ierr=ierr)
!
    else
        ASSERT(.false.)
    endif
!
    DEBUG_ALLOCATE('free ', strdbg, lonvec)
!   -- Si le deallocate s'est bien passe, c'est que le vecteur etait alloue.
!      il faut "rendre" la memoire a JEVEUX
!   -------------------------------------------------
    if (ierr .eq. 0) then
        lsic=lonvec*lonty/lois
        mcdyn=mcdyn-lsic
        cuvtrav=cuvtrav-lsic
    endif
!
end subroutine
