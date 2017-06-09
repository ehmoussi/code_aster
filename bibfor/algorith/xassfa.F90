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

subroutine xassfa(elp, npts, nintar, lst, noeud, cface, nface, pinter, jgrlsn)
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/iselli.h"
#include "blas/ddot.h"
!
    integer :: npts, nintar, noeud(9), cface(30,6), nface, jgrlsn
    real(kind=8) :: lst(6), pinter(*)
    character(len=8) :: elp
!
! ======================================================================
! person_in_charge: daniele.colombo at ifpen.fr
!                TROUVER LES CONNECTIVITES DES MAILLES DE LA FISSURE POUR UN
!                ELEMENT EN FOND DE FISSURE EN 3D
!
!     ENTREE
!       NPTS    : NOMBRE DE NOEUDS SOMMET DU TRIA TELS QUE LST<=0
!       NINTAR  : NOMBRE DE POINTS D'INTERSECTION DU FOND DE FISSURE AVEC LES
!                 ARETES DU TRIA
!       LST     : LST AUX SOMMETS DU TRIA
!       NOEUD   : INDICE DES NOEUDS DE LA FISSURE DANS LE TRIA
!
!     SORTIE
!       NFACE   : NOMBRE DE FACETTES
!       CFACE   : CONNECTIVITE DES NOEUDS DES FACETTES
!
!     ----------------------------------------------------------------
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      3 CAS SONT POSSIBLES:
!         -UN DES NOEUDS SOMMETS A LST=0, ET LES DEUX AUTRES ONT
!          RESPECTIVEMENT LST<0 et LST >0
!         -UN NOEUD SOMMET A LST<0 ET LES DEUX AUTRES ONT LST>0
!         -DEUX NOEUDS SOMMETS ONT LST<0 ET LE DERNIER A LST>0
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
!   PREMIER CAS
    if (npts.eq.1.and.nintar.eq.2) then
       nface = nface+1
       if (lst(2).lt.0.d0.or.lst(3).lt.0.d0) then
          cface(nface,1) = noeud(3)
          cface(nface,2) = noeud(1)
          cface(nface,3) = noeud(4)
          if (.not.iselli(elp)) then
             cface(nface,4) = noeud(5)
             cface(nface,5) = noeud(6)
             cface(nface,6) = noeud(8)
          endif
       else if (lst(1).lt.0.d0) then
          cface(nface,1) = noeud(1)
          cface(nface,2) = noeud(3)
          cface(nface,3) = noeud(4)
          if (.not.iselli(elp)) then
             cface(nface,4) = noeud(5)
             cface(nface,5) = noeud(8)
             cface(nface,6) = noeud(6)
          endif
       else 
          ASSERT(.false.)
       endif
!   DEUXIEME CAS
    else if (npts.eq.2.and.nintar.eq.2) then
       nface = nface+2
       if (lst(1).gt.0.d0) then
          cface(nface-1,1) = noeud(1)
          cface(nface-1,2) = noeud(2)
          cface(nface-1,3) = noeud(4)
          if (.not.iselli(elp)) then
             cface(nface-1,4) = noeud(7)
             cface(nface-1,5) = noeud(6)
             cface(nface-1,6) = noeud(9)
          endif
          cface(nface,1) = noeud(1)
          cface(nface,2) = noeud(4)
          cface(nface,3) = noeud(3)
          if (.not.iselli(elp)) then
             cface(nface,4) = noeud(9)
             cface(nface,5) = noeud(8)
             cface(nface,6) = noeud(5)
          endif
       else if (lst(2).gt.0.d0) then
          cface(nface-1,1) = noeud(1)
          cface(nface-1,2) = noeud(3)
          cface(nface-1,3) = noeud(2)
          if (.not.iselli(elp)) then
             cface(nface-1,4) = noeud(5)
             cface(nface-1,5) = noeud(9)
             cface(nface-1,6) = noeud(7)
          endif
          cface(nface,1) = noeud(3)
          cface(nface,2) = noeud(4)
          cface(nface,3) = noeud(2)
          if (.not.iselli(elp)) then
             cface(nface,4) = noeud(8)
             cface(nface,5) = noeud(6)
             cface(nface,6) = noeud(9)
          endif
       else if (lst(3).gt.0.d0) then
          cface(nface-1,1) = noeud(1)
          cface(nface-1,2) = noeud(2)
          cface(nface-1,3) = noeud(3)
          if (.not.iselli(elp)) then
             cface(nface-1,4) = noeud(7)
             cface(nface-1,5) = noeud(5)
             cface(nface-1,6) = noeud(9)
          endif
          cface(nface,1) = noeud(1)
          cface(nface,2) = noeud(3)
          cface(nface,3) = noeud(4)
          if (.not.iselli(elp)) then
             cface(nface,4) = noeud(9)
             cface(nface,5) = noeud(8)
             cface(nface,6) = noeud(6)
          endif
       else
          ASSERT(.false.)
       endif
!   TROISIEME CAS
    else if (npts.eq.2.and.nintar.eq.1) then
       nface = nface+1
       if ((lst(1).eq.0.d0.or.lst(3).gt.0.d0) .or. (lst(2).eq.0.d0.or.lst(1).gt.0.d0)) then
          cface(nface,1) = noeud(1)
          cface(nface,2) = noeud(2)
          cface(nface,3) = noeud(3)
          if (.not.iselli(elp)) then
             cface(nface,4) = noeud(7)
             cface(nface,5) = noeud(5)
             cface(nface,6) = noeud(8)
          endif
       else if ((lst(2).eq.0.d0.or.lst(3).gt.0.d0) .or. (lst(3).eq.0.d0.or.lst(1).gt.0.d0)) then
          cface(nface,1) = noeud(1)
          cface(nface,2) = noeud(2)
          cface(nface,3) = noeud(3)
          if (.not.iselli(elp)) then
             cface(nface,4) = noeud(7)
             cface(nface,5) = noeud(8)
             cface(nface,6) = noeud(5)
          endif
       else if (lst(1).eq.0.d0.or.lst(2).gt.0.d0) then
          cface(nface,1) = noeud(1)
          cface(nface,2) = noeud(3)
          cface(nface,3) = noeud(2)
          if (.not.iselli(elp)) then
             cface(nface,4) = noeud(8)
             cface(nface,5) = noeud(5)
             cface(nface,6) = noeud(7)
          endif
       else if (lst(3).eq.0.d0.or.lst(2).gt.0.d0) then
          cface(nface,1) = noeud(1)
          cface(nface,2) = noeud(3)
          cface(nface,3) = noeud(2)
          if (.not.iselli(elp)) then
             cface(nface,4) = noeud(5)
             cface(nface,5) = noeud(8)
             cface(nface,6) = noeud(7)
          endif
       else
          ASSERT(.false.)
       endif
    else
       ASSERT(.false.)
    endif
!
end subroutine
