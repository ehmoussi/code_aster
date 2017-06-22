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

subroutine pre_traitement(noma, fiss, ndim, nbeta, ngamma)
!
! aslint: disable=
    implicit none
!
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/celces.h"
#include "asterfort/cescns.h"
#include "asterfort/cnscno.h"
#include "asterfort/dismoi.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterfort/utmess.h"
    integer :: ndim
    character(len=8) :: noma,  fiss
    character(len=19) :: nbeta, ngamma
!
!
!
!
!   ENTREE
!        NOMA    : NOM DU CONCEPT MAILLAGE
!        NBETA   : VECTEUR DES ANGLES DE BRANCHEMENT POUR CHAQUE POINT
!                  DU FOND DE LA FISSURE (NOM DU CONCEPT)
!        NGAMMA  : VECTEUR DES ANGLES DE DEVERSEMENT POUR CHAQUE POINT
!                  DU FOND DE LA FISSURE
!        NDIM    : DIMENSION DU PROBLEME
!        FISS    : STRUCTURE DE DONNEE FISSURE NON PROPAGEE
!
!    SORTIE
!        FISS    : STRUCTURE DE DONNEE FISSURE NON PROPAGEE AVEC BASES LOCALES TOURNEES
!        NBETA   : TABLEAU D'ANGLES DE BRANCHEMENT MIS A ZERO
!
      integer :: i
      integer :: jbeta, jgamma, nbptff, jbasef, jfonf
      real(kind=8) :: n(3), t(3), n1(3), b2(3), t2(3), n2(3), bast(3), tast(3)
      real(kind=8) :: n2d(2), t2d(2), n2d1(2), t2d1(2)
      real(kind=8) :: cbeta, sbeta, cgamma, sgamma, mn2, mt2
!
!
!-----------------------------------------------------------------------
!     DEBUT
!-----------------------------------------------------------------------
!
    call jemarq()
!     RECUPERATION DU FOND DE FISSURE
    call jeveuo(fiss//'.FONDFISS', 'L', jfonf)
    call dismoi('NB_POINT_FOND', fiss, 'FISS_XFEM', repi=nbptff)
!
!     RETRIEVE THE LOCAL REFERENCE SYSTEM FOR EACH NODE ON THE FRONT
    call jeveuo(fiss//'.BASEFOND', 'E', jbasef)    
!
!     RETRIEVE THE DIMENSION OF THE PROBLEM (2D AND 3D ARE SUPPORTED)
    call dismoi('DIM_GEOM', noma, 'MAILLAGE', repi=ndim)
!    
!     RETRIEVE THE CRACK'S SPEED AND PROPAGATION ANGLE FOR EACH NODE ON
!     THE FRONT
    call jeveuo(nbeta, 'E', jbeta)
    call jeveuo(ngamma, 'E', jgamma) 
!    
!----------------------------------------------------------------------
!
!   
!  CAS 2D
    if (ndim.eq.2) then
      if (nbptff.gt.2) then
          call utmess('F', 'XFEM_11')
      endif        
!       ***************************************************************
!        RECALCULATE THE LOCAL REFERENCE SYSTEM IN THE ACTUAL CRACK
!        FRONT POINT IN ORDER TO BE SURE THAT THE THREE AXES ARE
!        ORTHOGONAL EACH OTHER
!        ***************************************************************  
      do i=1,nbptff  
!       NORMAL AXIS
          n2d(1) = zr(jbasef-1+2*ndim*(i-1)+1)
          n2d(2) = zr(jbasef-1+2*ndim*(i-1)+2)
!       TANGENTIAL AXIS
          t2d(1) = zr(jbasef-1+2*ndim*(i-1)+3)
          t2d(2) = zr(jbasef-1+2*ndim*(i-1)+4)
!         CALCULATE SINUS AND COSINUS OF THE ROTATION ANGLES BETA AND GAMMA
          cbeta = cos(zr(jbeta-1+i))
          sbeta = sin(zr(jbeta-1+i))
          
!         CALCULATE THE TILT (BETA) ROTATION OF THE LOCAL BASE
          n2d1(1) = cbeta*n2d(1)-sbeta*t2d(1)
          n2d1(2) = cbeta*n2d(2)-sbeta*t2d(2)
          
          t2d1(1) = cbeta*t2d(1)+sbeta*n2d(1)
          t2d1(2) = cbeta*t2d(2)+sbeta*n2d(2)  
          
!         SET TO UNIT VECTOR
          mt2 = sqrt(t2d1(1)**2 + t2d1(2)**2)
          t2d1(1)= t2d1(1)/mt2                          
          t2d1(2)= t2d1(2)/mt2
          
          mn2=sqrt(n2d1(1)**2 + n2d1(2)**2)
          n2d1(1) =n2d1(1)/mn2
          n2d1(2) =n2d1(2)/mn2
!         STROE THE NEW BASIS          
          zr(jbasef-1+2*ndim*(i-1)+1)=n2d1(1)
          zr(jbasef-1+2*ndim*(i-1)+2)=n2d1(2)
          zr(jbasef-1+2*ndim*(i-1)+3)=t2d1(1)
          zr(jbasef-1+2*ndim*(i-1)+4)=t2d1(2)             
          zr(jbeta-1+i)=0.d0
      enddo
!   CAS 3D      
    else
      do i = 1, nbptff
!        ***************************************************************
!        RECALCULATE THE LOCAL REFERENCE SYSTEM IN THE ACTUAL CRACK
!        FRONT POINT IN ORDER TO BE SURE THAT THE THREE AXES ARE
!        ORTHOGONAL EACH OTHER
!        ***************************************************************  
!       NORMAL AXIS
          n(1) = zr(jbasef-1+2*ndim*(i-1)+1)
          n(2) = zr(jbasef-1+2*ndim*(i-1)+2)
          n(3) = zr(jbasef-1+2*ndim*(i-1)+3)
!       TANGENTIAL AXIS
          t(1) = zr(jbasef-1+2*ndim*(i-1)+4)
          t(2) = zr(jbasef-1+2*ndim*(i-1)+5)
          t(3) = zr(jbasef-1+2*ndim*(i-1)+6)
!
!        CALCULATE THE BINORMAL AXIS AS THE VECTORIAL PRODUCT BETWEEN
!        THE TANGENTIAL AND NORMAL AXES. THIS AXIS IS TANGENT TO THE
!        CRACK FRONT.
        bast(1) = t(2)*n(3)-t(3)*n(2)
        bast(2) = t(3)*n(1)-t(1)*n(3)
        bast(3) = t(1)*n(2)-t(2)*n(1)
!
!        RECALCULATE THE TANGENTIAL AXIS AS THE VECTORIAL PRODUCT
!        BETWEEN THE BINORMAL AND THE NORMAL AXES.
        tast(1) = n(2)*bast(3)-n(3)*bast(2)
        tast(2) = n(3)*bast(1)-n(1)*bast(3)
        tast(3) = n(1)*bast(2)-n(2)*bast(1)
!        ***************************************************************
!        ROTATION OF THE LOCAL BASE
!        ***************************************************************
!
!         CALCULATE SINUS AND COSINUS OF THE ROTATION ANGLES BETA AND GAMMA
        cbeta = cos(zr(jbeta-1+i))
        sbeta = sin(zr(jbeta-1+i))
        cgamma = cos(zr(jgamma-1+i))
        sgamma = sin(zr(jgamma-1+i))        
!
!         CALCULATE THE TILT (BETA) ROTATION OF THE LOCAL BASE
        n1(1) = cbeta*n(1)-sbeta*tast(1)
        n1(2) = cbeta*n(2)-sbeta*tast(2)
        n1(3) = cbeta*n(3)-sbeta*tast(3)       
!
        t2(1) = cbeta*tast(1)+sbeta*n(1)
        t2(2) = cbeta*tast(2)+sbeta*n(2)
        t2(3) = cbeta*tast(3)+sbeta*n(3)
!
!         CALCULATE THE TWIST (GAMMA) ROTATION OF THE LOCAL BASE
        n2(1) = cgamma*n1(1)-sgamma*bast(1)
        n2(2) = cgamma*n1(2)-sgamma*bast(2)
        n2(3) = cgamma*n1(3)-sgamma*bast(3)
!
        b2(1) = cgamma*bast(1)+sgamma*n1(1)
        b2(2) = cgamma*bast(2)+sgamma*n1(2)
        b2(3) = cgamma*bast(3)+sgamma*n1(3)
!
!        CALCULATE THE MODULE OF THE NEW TANGENTIAL AXIS
        mt2 = (t2(1)**2.d0+t2(2)**2.d0+t2(3)**2.d0)**0.5d0 
!        CALCULATE THE UNIT VECTOR FOR THE NEW TENGENTIAL AXIS
        t2(1) = t2(1)/mt2
        t2(2) = t2(2)/mt2
        t2(3) = t2(3)/mt2   
!
!        CALCULATE THE MODULE OF THE NEW NORMAL AXIS
        mn2 = (n2(1)**2.d0+n2(2)**2.d0+n2(3)**2.d0)**0.5d0     
!        CALCULATE THE UNIT VECTOR FOR THE NEW TENGENTIAL AXIS
        n2(1) = n2(1)/mn2
        n2(2) = n2(2)/mn2 
        n2(3) = n2(3)/mn2 
!
!        STORE THE NEW LOCAL BASE
!        NORMAL AXIS
          zr(jbasef-1+2*ndim*(i-1)+1)=n2(1)
          zr(jbasef-1+2*ndim*(i-1)+2)=n2(2)
          zr(jbasef-1+2*ndim*(i-1)+3)=n2(3)
!        TANGENTIAL AXIS
          zr(jbasef-1+2*ndim*(i-1)+4)=t2(1)
          zr(jbasef-1+2*ndim*(i-1)+5)=t2(2)
          zr(jbasef-1+2*ndim*(i-1)+6)=t2(3)  

          zr(jbeta-1+i)=0.d0
      end do
   endif
!
!-----------------------------------------------------------------------
!     FIN
!-----------------------------------------------------------------------
    call jedema()
end subroutine
