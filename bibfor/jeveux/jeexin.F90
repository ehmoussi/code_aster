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

subroutine jeexin(nomlu, iret)
    implicit none
#include "jeveux_private.h"
#include "asterfort/jjallc.h"
#include "asterfort/jjcroc.h"
#include "asterfort/jjvern.h"
#include "asterfort/jxveuo.h"
    character(len=*), intent(in) :: nomlu
    integer, intent(out) :: iret
! ----------------------------------------------------------------------
! ROUTINE UTILISATEUR : TESTE L'EXISTENCE DU DESCRIPTEUR CREE PAR
!                       JECREO OU JECROC
! IN  NOMLU  : NOM DE L'OBJET JEVEUX
! OUT IRET   : =0 LE DESCRIPTEUR N'EXISTE PAS
! ----------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: ibacol, iblong, ibnum, ic, icre, id, ilong
    integer :: itab(1), ixlong, ixnom, ixnum, jcara, jctab, jdate
    integer :: jhcod, jiadd, jiadm, jlong, jlono, jltyp, jluti
    integer :: jmarq, n, nuti
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    common /jiatje/  jltyp(n), jlong(n), jdate(n), jiadd(n), jiadm(n),&
     &                 jlono(n), jhcod(n), jcara(n), jluti(n), jmarq(n)
    integer :: iclas, iclaos, iclaco, idatos, idatco, idatoc
    common /iatcje/  iclas ,iclaos , iclaco , idatos , idatco , idatoc
! ----------------------------------------------------------------------
    integer :: idnom, idlong, idnum
    parameter    ( idnom  = 5 , idlong = 7 ,idnum  = 10 )
! ----------------------------------------------------------------------
    character(len=32) :: noml32
! DEB ------------------------------------------------------------------
    noml32 = nomlu
    iret = 0
    icre = 0
    id = 0
    call jjvern(noml32, icre, iret)
    if (iret .eq. 1) then
        if (noml32(25:32) .eq. '        ') then
            id = idatos
        else
            if (iadm(jiadm(iclaos)+2*idatos-1) .eq. 0) then
                call jxveuo('L', itab, iret, jctab)
            endif
            call jjcroc('        ', icre)
            id = idatoc
        endif
    else if (iret .eq. 2) then
        ic = iclaco
        if (noml32(25:32) .eq. '        ') then
            id = idatco
        else
            call jjallc(ic, idatco, 'L', ibacol)
            call jjcroc(noml32(25:32), icre)
            ixnum = iszon(jiszon+ibacol+idnum )
            ixnom = iszon(jiszon+ibacol+idnom )
            ixlong = iszon(jiszon+ibacol+idlong)
            if (ixnum .ne. 0) then
                ibnum = iadm(jiadm(ic)+2*ixnum-1)
                nuti = iszon(jiszon+ibnum+1)
            else
                nuti = luti ( jluti(ic) + ixnom )
            endif
            id = idatoc
            if (ixlong .ne. 0) then
                iblong = iadm(jiadm(ic)+2*ixlong-1)
                ilong = iszon(jiszon+iblong - 1 + idatoc)
                if (ilong .le. 0) id = 0
            else
                if (idatoc .gt. nuti) id = 0
            endif
        endif
    endif
    iret = id
! FIN ------------------------------------------------------------------
end subroutine
