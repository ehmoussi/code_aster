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

subroutine jjvern(noml32, icre, iret)
! person_in_charge: j-pierre.lefebvre at edf.fr
! aslint: disable=
    implicit none
#include "jeveux_private.h"
#include "asterfort/jjcren.h"
#include "asterfort/utmess.h"
    character(len=32) :: noml32
    integer :: icre, iret
!     ------------------------------------------------------------------
    character(len=24) :: nomco
    character(len=32) :: nomuti, nomos, nomoc, bl32
    common /nomcje/  nomuti , nomos , nomco , nomoc , bl32
    integer :: illici, jclass(0:255)
    common /jchaje/  illici , jclass
    integer :: iclas, iclaos, iclaco, idatos, idatco, idatoc
    common /iatcje/  iclas ,iclaos , iclaco , idatos , idatco , idatoc
!-----------------------------------------------------------------------
    integer :: jdocu, jgenr, jorig, jrnom, jtype, k, n
!
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    common /jkatje/  jgenr(n), jtype(n), jdocu(n), jorig(n), jrnom(n)
!     ------------------------------------------------------------------
    character(len=24) :: noml24
    character(len=32) :: nom32, blan32
    character(len=8) :: nume, nome, nomatr, noml8
    data             nume     , nome     , nomatr&
     &               /'$$XNUM  ','$$XNOM  ','$$XATR  '/
! DEB ------------------------------------------------------------------
    iret = 0
    blan32='                                '
    nom32=blan32
    nomuti = noml32
    noml8 = noml32(25:32)
    noml24 = noml32(1:24)
    if (noml8 .ne. '        ') then
        if (noml8 .ne. nome .and. noml8 .ne. nume .and. noml8 .ne. nomatr) then
            call utmess('F', 'JEVEUX1_56', sk=noml8)
        endif
    endif
    if (noml24 .eq. nomos(1:24) .and. nomos(25:32) .eq. '        ') then
        iret = 1
    else if (noml24 .eq. nomco(1:24)) then
        iret = 2
    else
        nom32 = noml24
! ----- RECHERCHE DU NOM DANS LES BASES PAR JJCREN
!
        call jjcren(nom32, icre, iret)
! ----- VALIDITE DES CARACTERES COMPOSANT LE NOM
!
        if (iret .ne. 0 .and. icre .ne. 0) then
            if (index ( noml24 , '$' ) .ne. 0) then
                call utmess('F', 'JEVEUX1_57', sk=noml24)
            endif
            do 10 k = 1, 32
                if (jclass(ichar( nom32(k:k) )) .eq. illici) then
                    call utmess('F', 'JEVEUX1_58', sk=nom32(k:k))
                endif
10          continue
        endif
        if (noml8 .ne. '        ') then
            if (iret .eq. 1) then
                if (genr(jgenr(iclaos)+idatos) .ne. 'N') then
                    call utmess('F', 'JEVEUX1_68', sk=noml24)
                endif
            endif
        endif
    endif
! FIN ------------------------------------------------------------------
end subroutine
