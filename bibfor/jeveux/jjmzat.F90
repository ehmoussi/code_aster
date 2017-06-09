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

subroutine jjmzat(iclas, idat)
    implicit none
!     ==================================================================
#include "jeveux_private.h"
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
!-----------------------------------------------------------------------
    integer :: iadmar, iclas, idat, jcara, jdate, jdocu, jgenr
    integer :: jhcod, jiadd, jiadm, jlong, jlono, jltyp, jluti
    integer :: jmarq, jorig, jrnom, jtype, n
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    common /jiatje/  jltyp(n), jlong(n), jdate(n), jiadd(n), jiadm(n),&
     &                 jlono(n), jhcod(n), jcara(n), jluti(n), jmarq(n)
!
    common /jkatje/  jgenr(n), jtype(n), jdocu(n), jorig(n), jrnom(n)
    integer :: ipgc, kdesma(2), lgd, lgduti, kposma(2), lgp, lgputi
    common /iadmje/  ipgc,kdesma,   lgd,lgduti,kposma,   lgp,lgputi
! DEB ------------------------------------------------------------------
    ltyp( jltyp(iclas) + idat ) = 0
    long( jlong(iclas) + idat ) = 0
    date( jdate(iclas) + idat ) = 0
    iadd( jiadd(iclas) + 2*idat-1 ) = 0
    iadd( jiadd(iclas) + 2*idat ) = 0
    iadm( jiadm(iclas) + 2*idat-1 ) = 0
    iadm( jiadm(iclas) + 2*idat ) = 0
    lono( jlono(iclas) + idat ) = 0
    luti( jluti(iclas) + idat ) = 0
    genr( jgenr(iclas) + idat ) = ' '
    type( jtype(iclas) + idat ) = ' '
    docu( jdocu(iclas) + idat ) = '    '
    orig( jorig(iclas) + idat ) = '        '
    imarq(jmarq(iclas) + 2*idat-1 ) = 0
    iadmar = imarq(jmarq(iclas) + 2*idat)
    if (iadmar .gt. 0) then
        iszon(jiszon+kdesma(1)+iadmar-1) = 0
        imarq(jmarq(iclas) + 2*idat) = 0
    endif
! FIN ------------------------------------------------------------------
end subroutine
