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

subroutine xfem_count_no(neq, deeq, k8cmp, nbnomax, ino_xfem, is_xfem, nbnoxfem)
!
!-----------------------------------------------------------------------
! BUT : 
! * MARQUAGE DES NOEUDS XFEM : IS_XFEM(NBNOMAX)
! * BASCULEMENT VERS UN STOCKAGE LOCAL DES NOEUDS XFEM : INO_XFEM(NBNOMAX)

!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!
! SORTIES :
!     - IS_XFEM  :: RETOURNE .TRUE. SI ON A TROUVE UN NOEUD XFEM 
!     - INO_XFEM :: RETOURNE LA NUMEROTATION LOCALE DES NOEUDS XFEM
!         SI INO_XFEM(I)>0 : LE NOEUD A ETE MARQUE => NUMERO DE NOEUD LOCAL
!         SI INO_XFEM(I)=0 : LE NOEUD N A PAS ETE MARQUE
!     - NBNOXFEM :: NOMBRE DE NOEUDS MARQUES  
!-----------------------------------------------------------------------
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/xfem_cmps.h"
!-----------------------------------------------------------------------
!
    character(len=8) :: k8cmp(*)
    integer :: deeq(*), neq, nbnomax, nbnoxfem
    integer :: ino_xfem(nbnomax)
    aster_logical :: is_xfem(nbnomax)
!
!-----------------------------------------------------------------------
!
    character(len=8) :: nocmp
    integer :: ieq, nuno, nucmp
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
    nbnoxfem=0
    do 10 ieq = 1, neq
       nuno=deeq(2*(ieq-1)+1)
       nucmp=deeq(2*(ieq-1)+2)
       nocmp=k8cmp(nucmp)
       if(nuno .lt. 1) goto 10
       if(is_xfem(nuno)) goto 10
       if (xfem_cmps(nocmp)) then
          nbnoxfem=nbnoxfem+1
          ino_xfem(nuno)=nbnoxfem
          is_xfem(nuno)=.true.
       endif        
10  enddo
    ASSERT(nbnoxfem .gt. 0)
!
    call jedema()
!
end subroutine
