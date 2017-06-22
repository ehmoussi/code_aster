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

subroutine modi_alea(ma,alea)

    implicit none
    character(len=*) :: ma
    real(kind=8) :: alea
!
!     but : perturber aleatoirement les coordonnees des noeuds
!           d'un maillage pour lui faire perdre ses symetries.
!           cela permet par exemple d'eviter des modes multiples.
!
!     in :
!            ma     : maillage
!            alea   : coefficient parametrant la perturbation
!     out:
!            ma     : les coordonnees du maillage sont modifiees
! ----------------------------------------------------------------------
! La perturbation aleatoire des noeuds consiste a ajouter a chaque coordonnee
! la quantite   alea*random([0,1])*dim1
! ou dim1 est la "dimension" du maillage dans la direction concernee.
! Par exemple, pour la coordonnee Y, dim1= Y_max - Y_min
! ----------------------------------------------------------------------
!
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/assert.h"
#include "asterfort/ggubs.h"
    integer :: n1, jcoor,nno,ino
    character(len=8) :: ma8
    character(len=24) :: coorjv
    real(kind=8) :: xmin,xmax,ymin,ymax,zmin,zmax,xdim(3),x,y,z
    real(kind=8) :: rand1(1),dseed ,r1
! ----------------------------------------------------------------------
!
    call jemarq()
    ma8=ma
    coorjv=ma8//'.COORDO    .VALE'
    call jeveuo(coorjv, 'E', jcoor)
    call jelira(coorjv, 'LONMAX', n1)
    nno=n1/3



!   1. calcul de xmin, ..., zmax et xdim :
!   --------------------------------------
    xmin=zr(jcoor-1+1)
    ymin=zr(jcoor-1+2)
    zmin=zr(jcoor-1+3)
    xmax=zr(jcoor-1+1)
    ymax=zr(jcoor-1+2)
    zmax=zr(jcoor-1+3)
    do ino =2,nno
        x=zr(jcoor-1+3*(ino-1)+1)
        y=zr(jcoor-1+3*(ino-1)+2)
        z=zr(jcoor-1+3*(ino-1)+3)
        xmin=min(xmin,x)
        ymin=min(ymin,y)
        zmin=min(zmin,z)
        xmax=max(xmax,x)
        ymax=max(ymax,y)
        zmax=max(zmax,z)
    enddo
    xdim(1)=alea*(xmax-xmin)
    xdim(2)=alea*(ymax-ymin)
    xdim(3)=alea*(zmax-zmin)


!   2. modification des corrdonnees :
!   --------------------------------------
    dseed = 24331.d0

    do ino =1,nno
        x=zr(jcoor-1+3*(ino-1)+1)
        y=zr(jcoor-1+3*(ino-1)+2)
        z=zr(jcoor-1+3*(ino-1)+3)

        call ggubs(dseed, 1, rand1(1))
        r1=rand1(1)
        ! on passe de [0,1] a [-1,+1] :
        r1=2.d0*(r1-0.5)
        x=x+r1*xdim(1)

        call ggubs(dseed, 1, rand1(1))
        r1=rand1(1)
        r1=2.d0*(r1-0.5)
        y=y+r1*xdim(2)

        call ggubs(dseed, 1, rand1(1))
        r1=rand1(1)
        r1=2.d0*(r1-0.5)
        z=z+r1*xdim(3)

        zr(jcoor-1+3*(ino-1)+1)=x
        zr(jcoor-1+3*(ino-1)+2)=y
        zr(jcoor-1+3*(ino-1)+3)=z
    enddo


    call jedema()
!
end subroutine
