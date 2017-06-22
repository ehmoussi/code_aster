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

#ifndef JEVEUX_PRIVATE_H
#define JEVEUX_PRIVATE_H
!
! --------- DEBUT COMMONS INTERNES JEVEUX
! aslint: disable=W1304,C1002
#include "asterf_types.h"
    volatile         iacce
    volatile         ltyp,    long,    date,    iadd,    iadm
    volatile         lono,    hcod,    cara,    luti,    imarq
    volatile         genr,    type,    docu,    orig,    rnom
    volatile         indir
    volatile         iusadi
    volatile         iszon
    volatile         i4zon
    volatile         lszon
    volatile         r8zon
    volatile         k1zon
!
    integer :: iacce
    common /iacced/  iacce(1)
    integer :: ltyp   , long   , date   , iadd   , iadm
    integer :: lono   , hcod   , cara   , luti   , imarq
    common /iatrje/  ltyp(1), long(1), date(1), iadd(1), iadm(1),&
     &                 lono(1), hcod(1), cara(1), luti(1), imarq(1)
    character(len=1)       :: genr   , type
    character(len=4)       :: docu
    character(len=8)       :: orig
    character(len=32)      :: rnom
    common /katrje/  genr(8), type(8), docu(2), orig(1), rnom(1)
    integer :: indir
    common /kindir/  indir(1)
    integer :: iusadi
    common /kusadi/  iusadi(1)
!
    integer :: iszon(1)
    integer(kind=4)         :: i4zon(1)
    aster_logical          lszon(1)
    real(kind=8)            :: r8zon(1)
    character(len=1)       :: k1zon
    common /kzonje/  k1zon(8)
    equivalence    ( iszon(1), k1zon(1), r8zon(1), lszon(1), i4zon(1))
!---------- FIN COMMONS INTERNES JEVEUX
#endif
