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

subroutine focain(method, nomfon, cste, sortie, base)
    implicit none
#include "jeveux.h"
#include "asterfort/gettco.h"
#include "asterfort/assert.h"
#include "asterfort/foc2in.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=*) :: method, nomfon, sortie
    character(len=1) :: base
    real(kind=8) :: cste
!     INTEGRATION D'UNE FONCTION
! IN  METHOD : K : METHODE D'INTEGRATION
!           TRAPEZE   : DISPONIBLE
!           SIMPSON    : DISPONIBLE
!           VILLARCEAU : NON DISPONIBLE
!           HARDY      : NON DISPONIBLE
!     ------------------------------------------------------------------
!     RAPPEL DES FORMULES PARTICULIERES DE NEWTON-COTES (PAS CONSTANT)
!
!     NOM DE LA FORMULE: N :    A   A0   A1   A2   A3   A4   A5   A6
!     -----------------------------------------------------------
!     TRAPEZES         : 1 :    2    1    1   --   --   --   --   --
!     SIMPSON          : 2 :    6    1    4    1   --   --   --   --
!     VILLARCEAU       : 4 :   45   14   64   24   64   14   --   --
!     HARDY            : 6 :  140   41  216   27  272   27  216   41
!     ----------------------------------------------------------------
    character(len=8) :: nomres
    character(len=16) :: typres
    character(len=19) :: nomfi, nomfs
    character(len=24) :: vale, prol
!     ----------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, lfon, lpro, lpros, lres, lvar
    integer :: nbpts, nbval
!-----------------------------------------------------------------------
    call jemarq()
    nomfi = nomfon
    nomfs = sortie
!
!     ---  NOMBRE DE POINTS ----
    call gettco(nomfi, typres)
    if (typres .eq. 'FORMULE') then
        call utmess('F', 'MODELISA2_5', sk=nomfi)
    endif
    vale = nomfi//'.VALE'
    call jelira(vale, 'LONUTI', nbval)
    call jeveuo(vale, 'L', lvar)
    nbpts = nbval/2
    lfon = lvar + nbpts
!
    if (nbpts .ge. 2) then
!
!       --- CREATION DU TABLEAU DES VALEURS ---
        call wkvect(nomfs//'.VALE', base//' V R', nbval, lres)
!
!       --- RECOPIE DES VARIABLES ---
        do 410 i = 0, nbpts-1
            zr(lres+i) = zr(lvar+i)
410      continue
        lres = lres + nbpts
!
!       --- INTEGRATION ---
        if (method .eq. 'SIMPSON') then
            call foc2in(method, nbpts, zr(lvar), zr(lfon), cste,&
                        zr(lres))
        else if (method .eq. 'TRAPEZE' .or. method .eq. '  ') then
            call foc2in(method, nbpts, zr(lvar), zr(lfon), cste,&
                        zr(lres))
        else
            call utmess('F', 'UTILITAI_82')
        endif
    else if (nbpts.eq.1) then
!
!       --- CREATION DU TABLEAU DES VALEURS ---
        call wkvect(nomfs//'.VALE', base//' V R', 4, lres)
!
!       --- RECOPIE DES VARIABLES ---
        zr(lres) = zr(lvar)
        zr(lres+1) = zr(lvar)+1.d0
        zr(lres+2) = 0.d0
        zr(lres+3) = zr(lvar+1)
    endif
!
!     --- AFFECTATION DU .PROL ---
    prol = nomfi//'.PROL'
    call jeveuo(prol, 'L', lpro)
    nomres = zk24(lpro+3)(1:8)
    if (nomres(1:4) .eq. 'ACCE') then
        nomres = 'VITE'
    else if (nomres(1:4) .eq. 'VITE') then
        nomres = 'DEPL'
    else
        nomres = 'TOUTRESU'
    endif
    prol = nomfs//'.PROL'
    ASSERT(lxlgut(nomfs).le.24)
    call wkvect(prol, 'G V K24', 6, lpros)
    zk24(lpros ) = 'FONCTION'
    if (zk24(lpro+1)(1:3) .eq. 'INT') then
        zk24(lpros+1) = 'LIN LIN '
    else
        zk24(lpros+1) = zk24(lpro+1)
    endif
    zk24(lpros+2) = zk24(lpro+2)
    zk24(lpros+3) = nomres
    if (zk24(lpro+4)(1:1) .eq. 'I' .or. zk24(lpro+4)(2:2) .eq. 'I') then
        zk24(lpros+4) = 'EE      '
    else
        zk24(lpros+4) = zk24(lpro+4)
    endif
!
    zk24(lpros+5) = nomfs
    call jedema()
end subroutine
