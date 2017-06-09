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

subroutine jacopo(long, tpscaz, iad1, iad2)
! person_in_charge: jacques.pellet at edf.fr
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
    integer :: long, iad1, iad2
    character(len=*) :: tpscaz
! ----------------------------------------------------------------------
!     IN:
!      LONG: LONGUEUR A RECOPIER
!     TPSCAZ : 'R', 'I', 'K8/16/24/32/80','C'
!      LONG: LONGUEUR A RECOPIER
!      IAD1: ADRESSE DANS LE COMMON ZI (OU ZR...) DE L'OBJET A COPIER.
!      IAD2: ADRESSE DANS LE COMMON ZI (OU ZR...) DE L'OBJET RECOPIE.
!
    character(len=3) :: t
    character(len=8) :: typsca
! DEB-------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    typsca = tpscaz
!
    t = typsca(1:3)
!
!     -- QUELQUES VERIFICATIONS:
!
    ASSERT(long.ge.0)
!
!     -- RECOPIE SELON LE TYPE DE SCALAIRE:
!
    if (t .eq. 'I  ') then
        do 10,i = 1,long
        zi(iad2-1+i) = zi(iad1-1+i)
10      continue
    else if (t.eq.'R  ') then
        do 20,i = 1,long
        zr(iad2-1+i) = zr(iad1-1+i)
20      continue
    else if (t.eq.'C  ') then
        do 30,i = 1,long
        zc(iad2-1+i) = zc(iad1-1+i)
30      continue
    else if (t.eq.'L  ') then
        do 40,i = 1,long
        zl(iad2-1+i) = zl(iad1-1+i)
40      continue
    else if (t.eq.'K8 ') then
        do 50,i = 1,long
        zk8(iad2-1+i) = zk8(iad1-1+i)
50      continue
    else if (t.eq.'K16') then
        do 60,i = 1,long
        zk16(iad2-1+i) = zk16(iad1-1+i)
60      continue
    else if (t.eq.'K24') then
        do 70,i = 1,long
        zk24(iad2-1+i) = zk24(iad1-1+i)
70      continue
    else if (t.eq.'K32') then
        do 80,i = 1,long
        zk32(iad2-1+i) = zk32(iad1-1+i)
80      continue
    else if (t.eq.'K80') then
        do 90,i = 1,long
        zk80(iad2-1+i) = zk80(iad1-1+i)
90      continue
    else
        ASSERT(.false.)
    endif
!
!
end subroutine
