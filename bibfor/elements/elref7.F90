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

subroutine elref7(elrefv, tymvol, ndegre, nbf, elref1,&
                  elref2)
!
! person_in_charge: gerald.nicolas at edf.fr
!
    implicit none
#include "asterfort/utmess.h"
!
    character(len=8) :: elrefv
    integer :: tymvol, ndegre
    integer :: nbf
    character(len=8) :: elref1, elref2
!
!
!     BUT:
!         DETERMINATION DES CARACTERISTIQUES DES FACES DES VOLUMES
!
!     ARGUMENTS:
!     ----------
!      ENTREE :
!-------------
! IN   ELREFV : DENOMINATION DE LA MAILLE VOLUMIQUE
!               'QU4', 'QU8', 'QU9'
!               'TR3', 'TR6', 'TR7'
!               'HE8', 'H20', 'H27'
!               'PE6', 'P15', 'P18'
!               'TE4', 'T10'
!               'PY5', 'P13'
!
!      SORTIE :
!-------------
! OUT  TYMVOL : TYPE DE LA MAILLE VOLUMIQUE SELON LE CODE SUIVANT
!              -2 : QUADRANGLE
!              -1 : TRIANGLE
!               1 : HEXAEDRE
!               2 : PENTAEDRE
!               3 : TETRAEDRE
!               4 : PYRAMIDE
! OUT  NDEGRE : DEGRE DE L'ELEMENT
! OUT  NBF    : NOMBRE DE FACES DE LA MAILLE VOLUMIQUE
! OUT  ELREF1 : DENOMINATION DE LA MAILLE FACE DE ELREFV - FAMILLE 1
! OUT  ELREF2 : DENOMINATION DE LA MAILLE FACE DE ELREFV - FAMILLE 2
! ......................................................................
!
    character(len=6) :: valk(2)
!
    elref1 = '        '
    elref2 = '        '
!               12345678
!
!====
! 1. LA DESCRIPTION DES FACES DES VOLUMES 2D
!====
! 1.1. ==> QUADRANGLES
!
    if (elrefv(1:3) .eq. 'QU4') then
        tymvol = -2
        ndegre = 1
        nbf = 4
        elref1 = 'SE2'
!
    else if (elrefv(1:3).eq.'QU8') then
        tymvol = -2
        ndegre = 2
        nbf = 4
        elref1 = 'SE3'
!
    else if (elrefv(1:3).eq.'QU9') then
        tymvol = -2
        ndegre = 2
        nbf = 4
        elref1 = 'SE3'
!
! 1.2. ==> TRIANGLES
!
    else if (elrefv(1:3).eq.'TR3') then
        tymvol = -1
        ndegre = 1
        nbf = 3
        elref1 = 'SE2'
!
    else if (elrefv(1:3).eq.'TR6') then
        tymvol = -1
        ndegre = 2
        nbf = 3
        elref1 = 'SE3'
!
    else if (elrefv(1:3).eq.'TR7') then
        tymvol = -1
        ndegre = 2
        nbf = 3
        elref1 = 'SE3'
!
!====
! 2. LA DESCRIPTION DES FACES DES VOLUMES 3D
!====
! 2.1. ==> HEXAEDRES
!
    else if (elrefv(1:3).eq.'HE8') then
        tymvol = 1
        ndegre = 1
        nbf = 6
        elref1 = 'QU4'
!
    else if (elrefv(1:3).eq.'H20') then
        tymvol = 1
        ndegre = 2
        nbf = 6
        elref1 = 'QU8'
!
    else if (elrefv(1:3).eq.'H27') then
        tymvol = 1
        ndegre = 2
        nbf = 6
        elref1 = 'QU9'
!
! 2.2. ==> PENTAEDRES
!
    else if (elrefv(1:3).eq.'PE6') then
        tymvol = 2
        ndegre = 1
        nbf = 5
        elref1 = 'TR3'
        elref2 = 'QU4'
!
    else if (elrefv(1:3).eq.'P15') then
        tymvol = 2
        ndegre = 2
        nbf = 5
        elref1 = 'TR6'
        elref2 = 'QU8'
!
    else if (elrefv(1:3).eq.'P18') then
        tymvol = 2
        ndegre = 2
        nbf = 5
        elref1 = 'TR6'
        elref2 = 'QU9'
!
! 2.3. ==> TETRAEDRES
!
    else if (elrefv(1:3).eq.'TE4') then
        tymvol = 3
        ndegre = 1
        nbf = 4
        elref1 = 'TR3'
!
    else if (elrefv(1:3).eq.'T10') then
        tymvol = 3
        ndegre = 2
        nbf = 4
        elref1 = 'TR6'
!
! 2.4. ==> PYRAMIDES
!
    else if (elrefv(1:3).eq.'PY5') then
        tymvol = 4
        ndegre = 1
        nbf = 5
        elref1 = 'TR3'
        elref2 = 'QU4'
!
    else if (elrefv(1:3).eq.'P13') then
        tymvol = 4
        ndegre = 2
        nbf = 5
        elref1 = 'TR6'
        elref2 = 'QU8'
!
!====
! 3. INCONNU
!====
!
    else
!
        valk(1) = elrefv(1:3)
        call utmess('F', 'INDICATEUR_10', sk=valk(1))
!
    endif
!
!GN          WRITE(6,*) 'TYMVOL :',TYMVOL, ', NBF :', NBF
!GN          WRITE(6,*) 'ELREF1 : ',ELREF1
!GN          WRITE(6,*) 'ELREF2 : ',ELREF2
!
end subroutine
