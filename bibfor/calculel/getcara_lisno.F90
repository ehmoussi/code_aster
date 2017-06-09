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

subroutine getcara_lisno(noma,nno,lisno,dist_mini,dim,linocara)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/provec.h"
#include "asterfort/utmess.h"
#include "blas/ddot.h"
!
!
    character(len=8), intent(in) :: noma
    integer, intent(in) :: nno
    integer, intent(in) :: lisno(nno)
    real(kind=8), intent(in) :: dist_mini
    integer, intent(out) :: dim
    integer, intent(out) :: linocara(*)
!
! --------------------------------------------------------------------------------------------------
!
! But : determiner les caracteristiques geometriques d'une liste de noeuds
!
! --------------------------------------------------------------------------------------------------
!
! In  noma          : nom du maillage
! In  nno           : nombre de noeuds de lisno
! In  lisno         : liste des numeros des noeuds
! In  dist_mini     : distance en dessous de laquelle 2 points sont supposes coincidents
! Out dim           : dimension geometrique du nuage de noeuds :
!                      / 0 : tous les noeuds sont geometriquement confondus
!                      / 1 : tous les noeuds sont sur une meme ligne
!                      / 2 : tous les noeuds sont sur un meme plan
!                      / 3 : Le volume de l'enveloppe convexe de lisno est > 0
! Out linocara      : liste de noeuds "caracteristiques" de lisno
!     si dim=0 : len(linocara)=1 ; linocara(1) est un noeud quelconque
!     si dim=1 : len(linocara)=2 ; linocara(1:2) : 2 noeuds non confondus
!     si dim=2 : len(linocara)=3 ; linocara(1:3) : 3 noeuds non alignes
!     si dim=3 : len(linocara)=4 ; linocara(1:4) : 4 noeuds non coplanaires
!
! --------------------------------------------------------------------------------------------------
!
    integer :: k,nuno
    real(kind=8)  :: d2,d21,d2_1,d3_12,d4_123
    real(kind=8)  :: x1(3), x2(3), x3(3), x4(3), xm(3)
    real(kind=8)  :: y2(3), y3(3), xx(3), ym(3),valr(2),ratio

    real(kind=8), pointer :: coor(:) => null()

!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()

    call jeveuo(noma//'.COORDO    .VALE', 'L', vr=coor)



!   1 : linocara(1) : on choisit le 1er
!   ---------------------------------------
    dim=0
    nuno=lisno(1)
    linocara(1)=nuno
    x1(1:3)=coor(3*(nuno-1)+1:3*(nuno-1)+3)


!   2 : linocara(2) : le noeud le plus eloigne de x1
!   ---------------------------------------------------
    d21=0.d0
    linocara(2)=0
    do k=2,nno
       nuno=lisno(k)
       xm(1:3)=coor(3*(nuno-1)+1:3*(nuno-1)+3)
       xm(1:3)=xm(1:3)-x1(1:3)
       d2=ddot(3,xm,1,xm,1)
       if (sqrt(d2).gt.dist_mini) then
          if (d2.gt.d21) then
             linocara(2)=nuno
             d21=d2
          endif
       endif
    enddo
    if (linocara(2).eq.0)  goto 999

    dim=dim+1
    nuno=linocara(2)
    x2(1:3)=coor(3*(nuno-1)+1:3*(nuno-1)+3)
!   y2 : vecteur norme x1 -> x2
    y2(1:3)=x2(1:3)-x1(1:3)
    d2=ddot(3,y2,1,y2,1)
    d2_1=sqrt(d2)
    y2(1:3)=y2(1:3)/d2_1


!   3 : linocara(3) : le noeud le plus eloigne de la droite x1 x2
!   ----------------------------------------------------------------
    d21=0.d0
    linocara(3)=0
    do k=2,nno
       nuno=lisno(k)
       xm(1:3)=coor(3*(nuno-1)+1:3*(nuno-1)+3)
       ym(1:3)=xm(1:3)-x1(1:3)
       call provec(y2, ym, xx)
       d2=ddot(3,xx,1,xx,1)
       if (sqrt(d2).gt.dist_mini) then
          if (d2.gt.d21) then
             linocara(3)=nuno
             d21=d2
          endif
       endif
    enddo
    if (linocara(3).eq.0)  goto 999

    dim=dim+1
    nuno=linocara(3)
    d3_12=sqrt(d21)
    x3(1:3)=coor(3*(nuno-1)+1:3*(nuno-1)+3)
!   y3 : vecteur norme orthogonal au plan x1, x2, x3
    call provec(y2, x3(1:3)-x1(1:3), y3)
    d2=ddot(3,y3,1,y3,1)
    y3(1:3)=y3(1:3)/sqrt(d2)
    
    if (d3_12.lt.1.d-2*d2_1) then
    endif
!   -- si d3_12 est petit / d2_1, on alarme :
    ratio=d3_12/d2_1
    if (ratio.lt.1.d-2) then
        valr(1)=ratio
        valr(2)=d3_12
        call utmess('A','CALCULEL5_56',nr=2,valr=valr)
    endif



!   4 : linocara(4) : le noeud le plus eloigne du plan x1 x2 x3
!   ----------------------------------------------------------------
    d21=0.d0
    linocara(4)=0
    do k=2,nno
       nuno=lisno(k)
       xm(1:3)=coor(3*(nuno-1)+1:3*(nuno-1)+3)
       ym(1:3)=xm(1:3)-x1(1:3)
       d2=abs(ddot(3,y3,1,ym,1))
       if (sqrt(d2).gt.dist_mini) then
          if (d2.gt.d21) then
             linocara(4)=nuno
             d21=d2
          endif
       endif
    enddo
    if (linocara(4).eq.0)  goto 999

    dim=dim+1
    nuno=linocara(4)
    x4(1:3)=coor(3*(nuno-1)+1:3*(nuno-1)+3)
    d4_123=sqrt(d21)
    
!   -- si d4_123 est petit / d2_1, on alarme :
    ratio=d4_123/d2_1
    if (ratio.lt.1.d-2) then
        valr(1)=ratio
        valr(2)=d4_123
        call utmess('A','CALCULEL5_55',nr=2,valr=valr)
    endif


999 continue
!
    call jedema()
end subroutine
