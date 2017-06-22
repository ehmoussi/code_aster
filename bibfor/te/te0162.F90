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

subroutine te0162(option, nomte)
    implicit none
#include "jeveux.h"
!
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL FORCE DE PESANTEUR POUR CABLE
!                          OPTION BIDON : 'CHAR_MECA_TEMP_R'
!                                 =====
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    character(len=8) :: elrefe
    integer :: nno, kp, npg, i, ivectu
!
!
!-----------------------------------------------------------------------
    integer :: idfdk, ipoids, ivf, jgano, ndim, nnos
!-----------------------------------------------------------------------
    call elref1(elrefe)
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfdk,jgano=jgano)
!
    call jevech('PVECTUR', 'E', ivectu)
!
    do 20 kp = 1, npg
        do 10 i = 1, nno
            zr(ivectu+2*i-2) = 0.d0
            zr(ivectu+2*i-1) = 0.d0
10      continue
20  end do
!
end subroutine
