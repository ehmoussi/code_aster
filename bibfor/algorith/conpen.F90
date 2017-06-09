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

subroutine conpen(macor, nbcor, macoc, nbcoc, lface,&
                  locorr, loreor, ma)
!
!  ROUTINE CONPEN
!    TRAITEMENT DE KTYC = PENTA6 , KTYR = PENTA6 , TETRA4
!            ET DE KTYC = PENTA15, KTYR = PENTA15, TETRA10
!  DECLARATIONS
!    MACOC  : TABLEAU DES NOMS DES NOEUDS   POUR UNE MAILLE FISSURE
!    MACOR  : TABLEAU DES NOMS DES NOEUDS   POUR UNE MAILLE REFERENCE
!    NBCOC  : NOMBRE DE CONNEX              POUR UNE MAILLE FISSURE
!    NBCOR  : NOMBRE DE CONNEX              POUR UNE MAILLE REFERENCE
!    NBLIC  : NOMBRE DE NOEUD TESTES        POUR UNE MAILLE FISSURE
!    NBLIR  : NOMBRE DE NOEUD TESTES        POUR UNE MAILLE REFERENCE
!    NBNOCO : NOMBRE DE NOEUD COMMUNS
!    NOCOC  : TABLEAU DE RANG DES NOEUDS    POUR UNE MAILLE FISSURE
!
!  MOT_CLEF : ORIE_FISSURE
!
!
    implicit none
!
!     ------------------------------------------------------------------
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/concom.h"
#include "asterfort/conech.h"
#include "asterfort/conjac.h"
#include "asterfort/conors.h"
#include "asterfort/utmess.h"
    integer :: nbnoco
    integer :: nblir, nbcor
    integer :: nblic, nbcoc, nococ(6)
    integer :: vali
!
    character(len=8) :: macor(nbcor+2), macoc(nbcoc+2), ma
!
    aster_logical :: locorr, lface, quadra, loreor
    integer :: i1, i2, i3
!-----------------------------------------------------------------------
#define face(i1,i2,i3) nococ(1).eq.i1.and.nococ(2).eq.i2.and. \
    nococ(3).eq.i3
!
!     ------------------------------------------------------------------
!
    quadra=nbcoc.eq.15
    if (quadra) then
        if (nbcor .eq. 15) nblir=6
        if (nbcor .eq. 10) nblir=4
    else
        nblir = nbcor
    endif
    nblic = 6
!
!     -----------------------------------------------------------------
!
    call concom(macor, nblir, macoc, nblic, nbnoco,&
                nococ)
!
    if (nbnoco .eq. 3) then
        if (face(1,2,3) .or. face(4,5,6)) then
            locorr=.true.
            lface=face(1,2,3)
        else
            ASSERT(.false.)
        endif
        if (lface) then
            i1=1
            i2=2
            i3=3
        else
            i1=6
            i2=5
            i3=4
        endif
        call conors(i1, i2, i3, macoc, nbcoc,&
                    macor, nbcor, loreor, ma)
        if (loreor) then
            call conech(macoc, 1, 4)
            call conech(macoc, 2, 5)
            call conech(macoc, 3, 6)
            if (quadra) then
                call conech(macoc, 7, 13)
                call conech(macoc, 8, 14)
                call conech(macoc, 9, 15)
            endif
        endif
        call conjac(1, 2, 3, 4, macoc,&
                    nbcoc, ma)
        call conjac(2, 3, 1, 5, macoc,&
                    nbcoc, ma)
        call conjac(3, 1, 2, 6, macoc,&
                    nbcoc, ma)
        call conjac(4, 6, 5, 1, macoc,&
                    nbcoc, ma)
        call conjac(5, 4, 6, 2, macoc,&
                    nbcoc, ma)
        call conjac(6, 5, 4, 3, macoc,&
                    nbcoc, ma)
!
    else if (nbnoco.gt.2) then
        vali = nbnoco
        call utmess('E', 'ALGORITH12_59', si=vali)
    endif
!
end subroutine
