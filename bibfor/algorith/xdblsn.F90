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

subroutine xdblsn(ninter, npts, ndim, ar,&
                  pinref, pinter, ainter, cnset, nnose, it)
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/xxmmvd.h"
    integer :: ninter, npts, ndim, ar(12, 3), cnset(*)
    integer :: nnose, it
    real(kind=8) :: pinref(*), pinter(*), ainter(*)
!            BUT :  RAMENER LES CONFIGURATIONS DE DECOUPE 3D DEGENEREES
!                   (RASANTES) A DES CONFIGURATIONS DE DECOUPE CLASSIQUES
!
!     ENTREE
!       PINTER   : COORDONNES DES POINTS D INTERSECTION
!       NINTER   : NOMBRE DE POINTS D INTERSECTION
!       AINTER   : INFOS ARETE ASSOCIÉE AU POINTS D'INTERSECTION
!       AR       : CONNECTIVITE DU TETRA
!       NPTS     : NB DE PTS D'INTERSECTION COINCIDANT AVEC UN NOEUD SOMMET
!       PINTER   : COORDONNES DES POINTS D INTERSECTION
!       PINREF   : COORDONNES DES POINTS D INTERSECTION DANS L'ESPACE DE REFERENCE
!       AINTER   : INFOS ARETE ASSOCIÉE AU POINTS D'INTERSECTION
!       CNSET    : CONNECTIVITE DES SOUS TETRA
!       NNOSE    : NOMBRE DE NOEUDS DES SOUS TETRAS
!       IT       : NUMERO DU SOUS TETRA
!
!     ----------------------------------------------------------------
!
    integer :: i, j, k, l, p1, p2
    integer :: a1, a2, a3, a4, elim, elim2
    integer :: zxain
!
! --------------------------------------------------------------------
!
    call jemarq()
!
    zxain = xxmmvd('ZXAIN')
!
    ASSERT((ninter.le.6) .and.(npts.le.2))
!
!   PREMIER CAS: NINTER=5 et NPTS=2
    if (ninter.eq.5 .and. npts.eq.2) then
!      RECHERCHE DES NUMEROS DES NOEUDS SOMMETS DANS LE TETRA
       do i = 1, 4
          if (cnset(nnose*(it-1)+i).eq.nint(ainter(zxain*(1-1)+2))) then
             p1 = i
          elseif (cnset(nnose*(it-1)+i).eq.nint(ainter(zxain*(2-1)+2))) then
             p2 = i
          endif
       end do
       ASSERT(p1*p2.gt.0)
       elim = 0
       elim2 =0
       do i = 3, 5
          a1 = nint(ainter(zxain*(i-1)+1))
          if (ar(a1,1).eq.p1 .and. ar(a1,2).eq.p2) then
             elim = i
          elseif (ar(a1,1).eq.p2 .and. ar(a1,2).eq.p1) then
             elim = i
          elseif (ar(a1,1).eq.p1) then
             elim2 = 1
          elseif (ar(a1,1).eq.p2) then
             elim2 = 2
          elseif (ar(a1,2).eq.p1) then
             elim2 = 1
          elseif (ar(a1,2).eq.p2) then
             elim2 = 2
          endif
       end do
!      ON ENLEVE UN NOEUD SOMMET
       ninter = ninter-1
       npts = npts-1
       do i = elim2, 4
          do j = 1, ndim
             pinter(ndim*(i-1)+j)=pinter(ndim*(i-1+1)+j)
             pinref(ndim*(i-1)+j)=pinref(ndim*(i-1+1)+j)
          end do
          do j = 1, zxain
             ainter(zxain*(i-1)+j)=ainter(zxain*(i-1+1)+j)
          end do
       end do
!      ON ENLEVE LE NOEUD MILIEU
       do i = 2, 4
          a1 = nint(ainter(zxain*(i-1)+1))
          if (ar(a1,1).eq.p1 .and. ar(a1,2).eq.p2) then
             elim = i
          elseif (ar(a1,2).eq.p1 .and. ar(a1,1).eq.p2) then
             elim = i
          endif
       end do
       ASSERT(elim.gt.0)
       ninter = ninter-1
       do i = elim, 3
          do j = 1, ndim
             pinter(ndim*(i-1)+j)=pinter(ndim*(i-1+1)+j)
             pinref(ndim*(i-1)+j)=pinref(ndim*(i-1+1)+j)
          end do
          do j = 1, zxain
             ainter(zxain*(i-1)+j)=ainter(zxain*(i-1+1)+j)
          end do
       end do
!   DEUXIEME CAS: NINTER=6 et NPTS=2
    elseif (ninter.eq.6 .and. npts.eq.2) then
!      ON ENLEVE LES DEUX NOEUDS SOMMETS
       ninter = ninter-2
       npts = npts-2
       do i = 1, 4
          do j = 1, ndim
             pinter(ndim*(i-1)+j)=pinter(ndim*(i-1+2)+j)
             pinref(ndim*(i-1)+j)=pinref(ndim*(i-1+2)+j)
          end do
          do j = 1, zxain
             ainter(zxain*(i-1)+j)=ainter(zxain*(i-1+2)+j)
          end do
       end do
!      RECHERCHE D'UN NOEUD A
       a1 = nint(ainter(zxain*(1-1)+1))
       a2 = nint(ainter(zxain*(2-1)+1))
       a3 = nint(ainter(zxain*(3-1)+1))
       a4 = nint(ainter(zxain*(4-1)+1))
       elim = 0
       do i = 1, 2
          do j = 1, 2
             do k = 1, 2
                do l = 1, 2
                   if (ar(a1,i).eq.ar(a2,j) .and. ar(a1,i).eq.ar(a3,k)) then
                      elim = 4
                      goto 10
                   elseif (ar(a1,i).eq.ar(a2,j) .and. ar(a1,i).eq.ar(a4,l)) then
                      elim = 3
                      goto 10
                   elseif (ar(a1,i).eq.ar(a3,k) .and. ar(a1,i).eq.ar(a4,l)) then
                      elim = 2
                      goto 10
                   elseif (ar(a2,j).eq.ar(a3,k) .and. ar(a2,j).eq.ar(a4,l)) then
                      elim = 1
                      goto 10
                   endif
                end do
             end do
          end do
       end do
10     continue
       if (elim.gt.0) then
          ninter = ninter-1
          do i = elim, 3
             do j = 1, ndim
                pinter(ndim*(i-1)+j)=pinter(ndim*(i-1+1)+j)
                pinref(ndim*(i-1)+j)=pinref(ndim*(i-1+1)+j)
             end do
             do j = 1, zxain
                ainter(zxain*(i-1)+j)=ainter(zxain*(i-1+1)+j)
             end do
          end do
       endif
!   TROISIEME CAS: NINTER=5 et NPTS=1
    elseif (ninter.eq.5 .and. npts.eq.1) then
!      ON ENLEVE LE NOEUD SOMMET
       ninter = ninter-1
       npts = npts-1
       do i = 1, 4
          do j = 1, ndim
             pinter(ndim*(i-1)+j)=pinter(ndim*(i-1+1)+j)
             pinref(ndim*(i-1)+j)=pinref(ndim*(i-1+1)+j)
          end do
          do j = 1, zxain
             ainter(zxain*(i-1)+j)=ainter(zxain*(i-1+1)+j)
          end do
       end do
!      RECHERCHE D'UN NOEUD A
       a1 = nint(ainter(zxain*(1-1)+1))
       a2 = nint(ainter(zxain*(2-1)+1))
       a3 = nint(ainter(zxain*(3-1)+1))
       a4 = nint(ainter(zxain*(4-1)+1))
       elim = 0
       do i = 1, 2
          do j = 1, 2
             do k = 1, 2
                do l = 1, 2
                   if (ar(a1,i).eq.ar(a2,j) .and. ar(a1,i).eq.ar(a3,k)) then
                      elim = 4
                      goto 20
                   elseif (ar(a1,i).eq.ar(a2,j) .and. ar(a1,i).eq.ar(a4,l)) then
                      elim = 3
                      goto 20
                   elseif (ar(a1,i).eq.ar(a3,k) .and. ar(a1,i).eq.ar(a4,l)) then
                      elim = 2
                      goto 20
                   elseif (ar(a2,j).eq.ar(a3,k) .and. ar(a2,j).eq.ar(a4,l)) then
                      elim = 1
                      goto 20
                   endif
                end do
             end do
          end do
       end do
20     continue
       if (elim.gt.0) then
          ninter = ninter-1
          do i = elim, 3
             do j = 1, ndim
                pinter(ndim*(i-1)+j)=pinter(ndim*(i-1+1)+j)
                pinref(ndim*(i-1)+j)=pinref(ndim*(i-1+1)+j)
             end do
             do j = 1, zxain
                ainter(zxain*(i-1)+j)=ainter(zxain*(i-1+1)+j)
             end do
          end do
       endif
!   QUATRIEME CAS: NINTER=4 et NPTS=1
    elseif (ninter.eq.4 .and. npts.eq.1) then
!      RECHERCHE D'UN NOEUD A
       a1 = nint(ainter(zxain*(2-1)+1))
       a2 = nint(ainter(zxain*(3-1)+1))
       a3 = nint(ainter(zxain*(4-1)+1))
       elim = 0
       do i = 1, 2
          do j = 1, 2
             do k = 1, 2
                if (ar(a1,i).eq.ar(a2,j) .and. ar(a1,i).eq.ar(a3,k)) then
                   elim = 1
                   goto 30
                endif
             end do
          end do
       end do
30     continue
       if (elim.gt.0) then
!      ON ENLEVE LE NOEUD SOMMET
          ninter = ninter-1
          npts = npts-1
          do i = 1, 3
             do j = 1, ndim
                pinter(ndim*(i-1)+j)=pinter(ndim*(i-1+1)+j)
                pinref(ndim*(i-1)+j)=pinref(ndim*(i-1+1)+j)
             end do
             do j = 1, zxain
                ainter(zxain*(i-1)+j)=ainter(zxain*(i-1+1)+j)
             end do
          end do
       endif
    endif
!
    ASSERT((ninter.le.4) .and.(npts.le.2))
!
    call jedema()
end subroutine
