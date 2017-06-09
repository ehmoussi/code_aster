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

subroutine hplass(nmnbn, nmplas, nmdpla, nmddpl, bend,&
                  hplas)
!
    implicit none
!
!
!     CALCUL LA MATRICE HESSIENNE DU CRITERE DE PLASTICITE
!
! IN  NMNBN : MOMENT DE RAPPEL
! IN  NMPLAS : MOMENTS LIMITES DE PLASTICITE
! IN  NMDPLA : DERIVEES DES MOMENTS LIMITES DE PLASTICITE
! IN  NMDDPL : DERIVEES SECONDES DES MOMENTS LIMITES DE PLASTICITE
! IN  BEND : SIGNE DE LA FLEXION (1 POSITIVE, 2 NEGATIVE)
!
! OUT HPLAS : MATRICE HESSIENNE DU CRITERE DE PLASTICITE
!
#include "asterfort/r8inir.h"
    integer :: bend
!
    real(kind=8) :: hplas(6, *), nmnbn(6), nmplas(2, 3)
    real(kind=8) :: nmdpla(2, 2), nmddpl(2, 2)
!
    call r8inir(6*6, 0.d0, hplas, 1)
!
    hplas(1,1) = nmddpl(bend,1)*(nmnbn(5)-nmplas(bend,2))
    hplas(2,2) = nmddpl(bend,2)*(nmnbn(4)-nmplas(bend,1))
    hplas(2,1) = -nmdpla(bend,1)*nmdpla(bend,2)
    hplas(1,2) = hplas(2,1)
    hplas(5,1) = nmdpla(bend,1)
    hplas(1,5) = nmdpla(bend,1)
    hplas(4,2) = nmdpla(bend,2)
    hplas(2,4) = nmdpla(bend,2)
    hplas(4,5) = -1.d0
    hplas(5,4) = -1.d0
    hplas(6,6) = 2.d0
!
end subroutine
