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

subroutine conqua(macor, nbcor, macoc, nbcoc, lface,&
                  lomodi, locorr, loreor, ma)
!
!  ROUTINE CONQUA
!    TRAITEMENT DE KTYC = QUAD4, KTYR = QUAD4,TRIA3
!            ET DE KTYC = QUAD8, KTYR = QUAD9,QUAD8,TRIA6
!  DECLARATIONS
!    LOMODI : LOGICAL PRECISANT SI LA MAILLE EST UNE MAILLE MODIFIEE
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
#include "asterfort/conper.h"
#include "asterfort/utmess.h"
    integer :: nbnoco
    integer :: nblir, nbcor
    integer :: nblic, nbcoc, nococ(4)
    integer :: vali
!
    character(len=8) :: macor(nbcor+2), macoc(nbcoc+2), ma
!
    aster_logical :: lomodi, locorr, lface, quadra, loreor
    integer :: i1, i2
!-----------------------------------------------------------------------
#define face(i1,i2) nococ(1).eq.i1.and.nococ(2).eq.i2
!
!     ------------------------------------------------------------------
!
    quadra=nbcoc.eq.8
    if (quadra) then
        nblir = nbcor/2
    else
        nblir = nbcor
    endif
    nblic = 4
    call concom(macor, nblir, macoc, nblic, nbnoco,&
                nococ)
!
    if (nbnoco .eq. 2) then
        if (face(1,2) .or. face(3,4)) then
            locorr=.true.
            lface=face(1,2)
        else if (face(1,4).or.face(2,3)) then
!     ------------------------------------------------------------------
!     MODIFICATION DE LA MAILLE DE FISSURE
!     ------------------------------------------------------------------
            lomodi = .true.
            lface=face(2,3)
            call conper(macoc, 1, 2, 3, 4)
            if (quadra) call conper(macoc, 5, 6, 7, 8)
        else
            ASSERT(.false.)
        endif
        if (lface) then
            i1=1
            i2=2
        else
            i1=3
            i2=4
        endif
        call conors(i1, i2, 0, macoc, nbcoc,&
                    macor, nbcor, loreor, ma)
        if (loreor) then
            call conech(macoc, 1, 4)
            call conech(macoc, 2, 3)
            if (quadra) call conech(macoc, 5, 7)
        endif
        call conjac(1, 4, 2, 0, macoc,&
                    nbcoc, ma)
        call conjac(2, 1, 3, 0, macoc,&
                    nbcoc, ma)
        call conjac(3, 2, 4, 0, macoc,&
                    nbcoc, ma)
        call conjac(4, 3, 1, 0, macoc,&
                    nbcoc, ma)
!
!
    else if (nbnoco.gt.1) then
        vali = nbnoco
        call utmess('E', 'ALGORITH12_59', si=vali)
    endif
!
end subroutine
