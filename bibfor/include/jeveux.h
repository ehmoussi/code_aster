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

#ifndef JEVEUX_H
#define JEVEUX_H
!
!---------- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
! aslint: disable=W1304
#include "asterf_types.h"
!
    volatile           zi4, zi, zr, zc, zl
    volatile           zk8, zk16, zk24, zk32, zk80
!
    integer(kind=4)           :: zi4
    common  / i4vaje / zi4(1)
    integer :: zi
    common  / ivarje / zi(1)
    real(kind=8)              :: zr
    common  / rvarje / zr(1)
    complex(kind=8)          :: zc
    common  / cvarje / zc(1)
    aster_logical          :: zl
    common  / lvarje / zl(1)
    character(len=8)         :: zk8
    character(len=16)                :: zk16
    character(len=24)                         :: zk24
    character(len=32)                                  :: zk32
    character(len=80)                                           :: zk80
    common  / kvarje / zk8(1), zk16(1), zk24(1), zk32(1), zk80(1)
!---------- FIN  COMMUNS NORMALISES  JEVEUX ----------------------------
#endif
