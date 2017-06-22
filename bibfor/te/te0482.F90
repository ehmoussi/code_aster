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

subroutine te0482(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/nmholi.h"
#include "asterfort/lteatt.h"
    character(len=16) :: option, nomte
! ......................................................................
!
!    - FONCTION REALISEE:  CALCUL DE LA CHARGE LIMITE POUR
!                          DES ELEMENTS INCOMPRESSIBLES PLAN OU AXI
!                          OPTION : 'CHAR_LIMITE'
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!
! VECTEURS DIMENSIONNES POUR  NNO = 8
!
!
    aster_logical :: axi
    integer :: ndim, nno, npg, ipoids, ivf, idfde
    integer :: igeom, imate, idepl, itemps, iechli, nnos, jgano
! ......................................................................
!
!
    axi = lteatt('AXIS','OUI')
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PDEPLAR', 'L', idepl)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PECHLI', 'E', iechli)
!
!
! - CALCUL DE LA CONTRIBUTION ELEMENTAIRE A LA CHARGE LIMITE
!
    call nmholi(ndim, axi, nno, npg, ipoids,&
                ivf, idfde, zi(imate), zr(itemps), zr(igeom),&
                zr(idepl), zr(iechli))
!
end subroutine
