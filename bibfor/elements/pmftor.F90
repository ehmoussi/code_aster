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

subroutine pmftor(ety, etz, sk)
    implicit none
    real(kind=8) :: ety, etz, sk(78)
!    -------------------------------------------------------------------
!     ENRICHISSEMENT DE LA MATRICE DE RIGIDITE PAR LES TERMES DE
!     COUPLAGE DE LA TORSION-FLEXION
!     ETY = EXCENTRICITE DU CENTRE DE TORSION SELON Y
!     ETZ = EXCENTRICITE DU CENTRE DE TORSION SELON Z
!     SK = MATRICE DE RIGIDITE
!    -------------------------------------------------------------------
    integer :: ip(12)
    real(kind=8) :: etz2,ety2
    data ip/0,1,3,6,10,15,21,28,36,45,55,66/
!
    ety2 = ety*ety
    etz2 = etz*etz
!
!   rectification pour la torsion
    sk(ip(4)+4)  =  sk(ip(4)+4) + etz2*sk(ip(2)+2) + ety2*sk(ip(3)+3)
    sk(ip(10)+4) = -sk(ip(4)+4)
    sk(ip(10)+10)=  sk(ip(4)+4)
!
!   terme induit par l'excentricite
    sk(ip(4)+2)  = -etz*sk(ip(2)+2) + ety*sk(ip(3)+2)
    sk(ip(10)+2) = -sk(ip(4)+2)
    sk(ip(4)+3)  = -etz*sk(ip(3)+2) + ety*sk(ip(3)+3)
    sk(ip(10)+3) = -sk(ip(4)+3)
    sk(ip(5)+4)  = -etz*sk(ip(5)+2) + ety*sk(ip(5)+3)
    sk(ip(6)+4)  = -etz*sk(ip(6)+2) + ety*sk(ip(6)+3)
    sk(ip(8)+4)  =  sk(ip(10)+2)
    sk(ip(9)+4)  =  sk(ip(10)+3)
    sk(ip(11)+4) =  sk(ip(5)+4)
    sk(ip(12)+4) =  sk(ip(6)+4)
    sk(ip(10)+5) = -sk(ip(5)+4)
    sk(ip(10)+6) = -sk(ip(6)+4)
    sk(ip(10)+8) =  sk(ip(4)+2)
    sk(ip(10)+9) =  sk(ip(4)+3)
    sk(ip(11)+10)=  sk(ip(10)+5)
    sk(ip(12)+10)=  sk(ip(10)+6)
!
end subroutine
