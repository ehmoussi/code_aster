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

subroutine inigms(nomail, nbnoma, nuconn)
!.======================================================================
!
!
!      INIGMS --   INITIALISATION DES TYPES DE MAILLES
!                  POUR LE PASSAGE GMSH VERS ASTER
!
!   ARGUMENT        E/S  TYPE         ROLE
!    NOMAIL(*)      OUT   K8       NOM DES TYPES DE MAILLES
!    NBNOMA         OUT   I        NOMBRE DE NOEUDS DES MAILLES ASTER
!    NUCONN(15,32)  OUT   I        CORRESPONDANCE DES NDS GMSH / ASTER
!                                   NUCONN(TYPMAI,ND_ASTER) = ND_GMSH
!
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
    implicit none
#include "jeveux.h"
!
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
    integer :: nuconn(19, 32), nbnoma(19)
    character(len=8) :: nomail(*)
!
!
!
    integer :: m, jnbno, i, j
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
!
    nomail(1) = 'SEG2'
    nomail(2) = 'TRIA3'
    nomail(3) = 'QUAD4'
    nomail(4) = 'TETRA4'
    nomail(5) = 'HEXA8'
    nomail(6) = 'PENTA6'
    nomail(7) = 'PYRAM5'
    nomail(8) = 'SEG3'
    nomail(9) = 'TRIA6'
    nomail(10) = 'QUAD8'
    nomail(11) = 'TETRA10'
    nomail(12) = 'HEXA27'
    nomail(13) = 'PENTA18'
    nomail(14) = 'PYRAM13'
    nomail(15) = 'POI1'
    nomail(16) = 'QUAD8'
    nomail(17) = 'HEXA20'
    nomail(18) = 'PENTA15'
    nomail(19) = 'PYRAM13'
!
    do 5 m = 1, 19
        call jeveuo(jexnom('&CATA.TM.NBNO', nomail(m)), 'L', jnbno)
        nbnoma(m) = zi(jnbno)
 5  end do
!
!
! CORRESPONDANCE DE LA NUMEROTATION DES NOEUDS ENTRE GMSH ET ASTER
! TABLEAU NUCONN(TYPE,ND_ASTER) = ND_GMSH
!   TYPE     : NUMERO DU TYPE DE MAILLE (CF. TABLEAU NOMAIL)
!   ND_ASTER : NUMERO DU NOEUD DE LA MAILLE ASTER DE REFERENCE
!   ND_GMSH  : NUMERO DU NOEUD DE LA MAILLE GMSH  DE REFERENCE
!
!    PAR DEFAUT LES NUMEROTATIONS COINCIDENT
    do 10 i = 1, 19
        do 20 j = 1, 32
            nuconn(i,j) = j
20      continue
10  end do
!
!   ON DECLARE MAINTENANT LES EXCEPTIONS
!
!    TETRA 10
    nuconn(11, 9) = 10
    nuconn(11,10) = 9
!
!    HEXA 27
    nuconn(12,10) = 12
    nuconn(12,11) = 14
    nuconn(12,12) = 10
    nuconn(12,13) = 11
    nuconn(12,14) = 13
    nuconn(12,15) = 15
    nuconn(12,16) = 16
    nuconn(12,17) = 17
    nuconn(12,18) = 19
    nuconn(12,19) = 20
    nuconn(12,20) = 18
    nuconn(12,23) = 24
    nuconn(12,24) = 25
    nuconn(12,25) = 23
!
!    PENTA 18
    nuconn(13, 7) = 7
    nuconn(13, 8) = 10
    nuconn(13, 9) = 8
    nuconn(13,10) = 9
    nuconn(13,11) = 11
    nuconn(13,12) = 12
    nuconn(13,13) = 13
    nuconn(13,14) = 15
    nuconn(13,15) = 14
    nuconn(13,17) = 18
    nuconn(13,18) = 17
!
!    PYRAM 13
    nuconn(14, 6) = 6
    nuconn(14, 7) = 9
    nuconn(14, 8) = 11
    nuconn(14, 9) = 7
    nuconn(14,10) = 8
    nuconn(14,11) = 10
    nuconn(14,12) = 12
    nuconn(14,13) = 13
!
!    HEXA 20
    nuconn(17,10) = 12
    nuconn(17,11) = 14
    nuconn(17,12) = 10
    nuconn(17,13) = 11
    nuconn(17,14) = 13
    nuconn(17,15) = 15
    nuconn(17,16) = 16
    nuconn(17,17) = 17
    nuconn(17,18) = 19
    nuconn(17,19) = 20
    nuconn(17,20) = 18
!
!    PENTA 15
    nuconn(18, 7) = 7
    nuconn(18, 8) = 10
    nuconn(18, 9) = 8
    nuconn(18,10) = 9
    nuconn(18,11) = 11
    nuconn(18,12) = 12
    nuconn(18,13) = 13
    nuconn(18,14) = 15
    nuconn(18,15) = 14
!
!    PYRAM 13
    nuconn(19, 6) = 6
    nuconn(19, 7) = 9
    nuconn(19, 8) = 11
    nuconn(19, 9) = 7
    nuconn(19,10) = 8
    nuconn(19,11) = 10
    nuconn(19,12) = 12
    nuconn(19,13) = 13
!
!
!
!.============================ FIN DE LA ROUTINE ======================
end subroutine
