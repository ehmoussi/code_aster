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

subroutine jgetlmx(nomlu, ival)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
#include "asterf_types.h"
#include "jeveux_private.h"
#include "asterfort/codent.h"
#include "asterfort/jjallc.h"
#include "asterfort/jjcroc.h"
#include "asterfort/jjlide.h"
#include "asterfort/jjlirs.h"
#include "asterfort/jjvern.h"
#include "asterfort/utmess.h"
    character(len=*), intent(in) :: nomlu
    integer, intent(out) :: ival
!     ------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
!     ------------------------------------------------------------------
    integer :: ib, ibacol, ic, id, ipgcex
    integer :: ixdeso, ixiadd
    integer :: ixlong, ixlono, ixluti, ixnom, ixnum, jcara
    integer :: jdate, jdocu, jgenr, jhcod, jiadd, jiadm, jlong
    integer :: jlono, jltyp, jluti, jmarq, jorig, jrnom, jtype
    integer :: ltypi, n
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    common /jiatje/  jltyp(n), jlong(n), jdate(n), jiadd(n), jiadm(n),&
     &                 jlono(n), jhcod(n), jcara(n), jluti(n), jmarq(n)
!
    common /jkatje/  jgenr(n), jtype(n), jdocu(n), jorig(n), jrnom(n)
!     ------------------------------------------------------------------
    integer :: iclas, iclaos, iclaco, idatos, idatco, idatoc
    common /iatcje/  iclas ,iclaos , iclaco , idatos , idatco , idatoc
!
    integer :: ipgc, kdesma(2), lgd, lgduti, kposma(2), lgp, lgputi
    common /iadmje/  ipgc,kdesma,   lgd,lgduti,kposma,   lgp,lgputi
!     ------------------------------------------------------------------
    integer :: iddeso, idiadd, idnom, idlong, idlono, idluti
    integer :: idnum
    parameter    ( iddeso = 1 ,idiadd = 2 , &
     &                          idnom  = 5 ,             idlong = 7 ,&
     &             idlono = 8 , idluti = 9 ,idnum  = 10 )
!     ------------------------------------------------------------------
    character(len=32) :: noml32
    character(len=1) :: genri
    integer :: icre, iret
    aster_logical :: lconst, lcol
! DEB ------------------------------------------------------------------
!
    ipgcex = ipgc
    noml32 = nomlu
!
    ival = -1
    icre = 0
    call jjvern(noml32, icre, iret)
!
    ic = iclas
    if (iret .eq. 0) then
        call utmess('F', 'JEVEUX_26', sk=noml32(1:24))
    else if (iret .eq. 1) then
        lcol = .false.
        ic = iclaos
        id = idatos
        lconst = .true.
        if (noml32(25:32) .ne. '        ') then
            call utmess('F', 'JEVEUX1_09', sk=noml32(1:24))
        endif
    else
        lcol = .true.
        ipgc = -2
        ic = iclaco
        call jjallc(ic, idatco, 'L', ibacol)
        if (noml32(25:32) .ne. '        ') then
            iret = 3
            call jjcroc(noml32(25:32), icre)
            if (idatoc .eq. 0) then
                call utmess('F', 'JEVEUX_30', sk=noml32(1:24))
            endif
        endif
        ixdeso = iszon ( jiszon + ibacol + iddeso )
        id = ixdeso
        ixiadd = iszon ( jiszon + ibacol + idiadd )
        ixlong = iszon ( jiszon + ibacol + idlong )
        ixlono = iszon ( jiszon + ibacol + idlono )
        ixluti = iszon ( jiszon + ibacol + idluti )
        ixnom = iszon ( jiszon + ibacol + idnom )
        ixnum = iszon ( jiszon + ibacol + idnum )
        lconst = (ixlong .eq. 0 )
    endif
    genri = genr ( jgenr(ic) + id )
    ltypi = ltyp ( jltyp(ic) + id )
    if (lconst) then
        ival = long ( jlong(ic) + id )
    else if (iret .eq. 3) then
        ib = jiszon + iadm ( jiadm(ic) + 2*ixlong-1 ) - 1 + idatoc
        ival = iszon (ib)
    endif
!
    if (lcol) then
        call jjlide('JELIBE', noml32(1:24), 2)
    endif
    ipgc = ipgcex
!
end subroutine
