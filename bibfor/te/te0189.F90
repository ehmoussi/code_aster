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

subroutine te0189(option, nomte)
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES NIVEAUX DE PRESSION ACOUSTIQUE
    implicit none
!                          OPTION : 'PRAC_ELNO'
!    - ARGUMENTS:
!        ENTREES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
    character(len=16) :: option, nomte
    integer :: idino, ino, nno, nnos, ndim, jgano, npg1
    integer :: ipdeb, ipres, ipoids, ivf, idfde
!
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    ASSERT(option.eq.'PRAC_ELNO')
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg1,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PPRESSC', 'L', ipres)
    call jevech('PPRAC_R', 'E', ipdeb)
!
    do 101 ino = 1, nno
        idino = ipdeb +3*(ino - 1)
        zr(idino-1+1) = dble(zc(ipres +ino-1))
        zr(idino-1+2) = dimag(zc(ipres +ino-1))
        zr(idino-1+3) = 20.d0*log10(abs(zc(ipres +ino-1))/2.d-5)
101  end do
!
end subroutine
