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

subroutine jecreo(nomlu, listat)
! person_in_charge: j-pierre.lefebvre at edf.fr
!
! ROUTINE UTILISATEUR DE CREATION D'UN OBJET JEVEUX
!
! IN  NOMLU  : NOM DE L'OBJET JEVEUX
! IN  LISTAT : CHAINE DE CARACTERES CONTENANT LA LISTES DES ATTRIBUTS
!
! ----------------------------------------------------------------------
    implicit none
#include "jeveux_private.h"
#include "asterfort/jjanal.h"
#include "asterfort/jjvern.h"
#include "asterfort/utmess.h"
    character(len=*), intent(in) :: nomlu, listat
!     ==================================================================
!-----------------------------------------------------------------------
    integer :: iv, jcara, jdate, jdocu, jgenr, jhcod, jiadd
    integer :: jiadm, jlong, jlono, jltyp, jluti, jmarq, jorig
    integer :: jrnom, jtype, n
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
!
    character(len=2) :: dn2
    character(len=5) :: classe
    character(len=8) :: nomfic, kstout, kstini
    common /kficje/  classe    , nomfic(n) , kstout(n) , kstini(n) ,&
     &                 dn2(n)
!     ------------------------------------------------------------------
    common /jiatje/  jltyp(n), jlong(n), jdate(n), jiadd(n), jiadm(n),&
     &                 jlono(n), jhcod(n), jcara(n), jluti(n), jmarq(n)
    common /jkatje/  jgenr(n), jtype(n), jdocu(n), jorig(n), jrnom(n)
!     ------------------------------------------------------------------
    integer :: iclas, iclaos, iclaco, idatos, idatco, idatoc
    common /iatcje/  iclas ,iclaos , iclaco , idatos , idatco , idatoc
!     ------------------------------------------------------------------
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
!     ------------------------------------------------------------------
    character(len=1) :: typei, genri
    integer :: nv, icre, iret
    parameter      ( nv = 3 )
    integer :: lval(nv)
    character(len=8) :: cval(nv)
    character(len=32) :: noml32
    character(len=4) :: ifmt
!     ------------------------------------------------------------------
    if (len(nomlu) .gt. 24) then
        call utmess('F', 'JEVEUX_84', sk=nomlu)
    endif
    noml32 = nomlu(1:min(24,len(nomlu)))
!
    call jjanal(listat, nv, nv, lval, cval)
    iclas = index ( classe , cval(1)(1:1) )
    if (iclas .eq. 0) then
        call utmess('F', 'JEVEUX_68', sk=cval(1))
    endif
!
    icre = 1
    call jjvern(noml32, icre, iret)
!
    if (iret .eq. 2) then
        call utmess('F', 'JEVEUX_85', sk=noml32)
    else
        genr(jgenr(iclaos)+idatos) = cval(2)(1:1)
        type(jtype(iclaos)+idatos) = cval(3)(1:1)
        if (cval(3)(1:1) .eq. 'K' .and. lval(3) .eq. 1) then
            call utmess('F', 'JEVEUX_86', sk=noml32)
        else
            genri = genr ( jgenr(iclaos) + idatos )
            typei = type ( jtype(iclaos) + idatos )
            if (genri .eq. 'N' .and. typei .ne. 'K') then
                call utmess('F', 'JEVEUX_87', sk=noml32)
            endif
            if (typei .eq. 'K') then
                write(ifmt,'(''(I'',I1,'')'')') lval(3) - 1
                read ( cval(3)(2:lval(3)) , ifmt ) iv
                if (iv .le. 0 .or. iv .gt. 512) then
                    call utmess('F', 'JEVEUX_88', sk=cval(3))
                endif
                if (genri .eq. 'N') then
                    if (mod ( iv , lois ) .ne. 0) then
                        call utmess('F', 'JEVEUX_89', sk=noml32)
                    endif
                    if (iv .gt. 24) then
                        call utmess('F', 'JEVEUX_90', sk=noml32)
                    endif
                endif
            else if (typei .eq. 'I') then
                iv = lois
            else if (typei .eq. 'R') then
                iv = lor8
            else if (typei .eq. 'C') then
                iv = loc8
            else if (typei .eq. 'L') then
                iv = lols
            else if (typei .eq. 'S') then
                iv = lor8/2
            else
                call utmess('F', 'JEVEUX_91', sk=cval(3))
            endif
            ltyp ( jltyp(iclaos) + idatos ) = iv
        endif
        if (cval(2)(1:1) .eq. 'E') then
            long(jlong(iclaos)+idatos) = 1
            lono(jlono(iclaos)+idatos) = 1
        endif
    endif
!
end subroutine
