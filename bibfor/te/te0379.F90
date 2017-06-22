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

subroutine te0379(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE: EXTENSION DU CHAM_ELEM ERREUR AUX NOEUDS
!                         OPTIONS : 'ERME_ELNO'  ET 'ERTH_ELNO'
!             (POUR PERMETTRE D'UTILISER POST_RELEVE_T)
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE
! ......................................................................
!
!
!
!
    integer :: ndim, nno, nnos, npg, ipoids, ivf, idfde, jgano, nbcmp
    integer :: i, j, itab(3), ierr, ierrn, iret
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call tecach('OOO', 'PERREUR', 'L', iret, nval=3,&
                itab=itab)
    call jevech('PERRENO', 'E', ierrn)
    ierr=itab(1)
    nbcmp=itab(2)
!
    do 10 i = 1, nno
        do 20 j = 1, nbcmp
            zr(ierrn+nbcmp*(i-1)+j-1) = zr(ierr-1+j)
20      continue
10  end do
!
end subroutine
