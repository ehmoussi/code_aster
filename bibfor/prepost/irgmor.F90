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

subroutine irgmor(tord, vers)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
!
    integer :: ntyele, neletr
    parameter (ntyele = 28)
    parameter (neletr =  8)
!
    integer :: tord(neletr)
    integer :: vers
!     IN  : VERS
!     OUT : TORD
!
!     NTYELE : NOMBRE DE TYPES DE MAILLES TRAITEES
!              (MAX DE TYPE_MAILLE__.CATA)
!
!     NELETR : NOMBRE DE TYPES DE MAILLES TRANSMISES A GMSH
!
!     RETOURNE LE TABLEAU DANS L'ORDRE DANS LEQUEL ON DOIT IMPRIMER
!     LES ELEMENTS (OU PLUTOT LES VALEURS QU'ILS PORTENT)
!      TORD(1)=NUMERO DE LA MAILLE POI1...
!
!     DOC GMSH (FILE FORMATS VERSION 1.2)
!        point
!        line
!        triangle
!        quadrangle
!        tetrahedron
!        hexahedron
!        prism
!        pyramid     ET POUR CHAQUE scalar, vector, puis tensor
!
!     ------------------------------------------------------------------
    integer :: i, ind
!
! --- DATA QUI DEFINIT L'ORDRE
!     (IDENTIQUE EN VERSION 1.0 ET 1.2 PUISQUE ON AURA ZERO ELEMENT SUR
!      LES TYPES QUE LA VERSION 1.0 NE CONNAIT PAS)
    character(len=8) :: formgm(neletr)
    data formgm/'POI1',  'SEG2',   'TRIA3', 'QUAD4', 'TETRA4',&
     &            'HEXA8', 'PENTA6', 'PYRAM5'/
!     ------------------------------------------------------------------
! --- VERIF
    if (vers .ne. 1 .and. vers .ne. 2) goto 999
!
! --- REMPLISSAGE QUI POURRAIT VARIER SELON LA VERSION
    do i = 1, neletr
        call jenonu(jexnom('&CATA.TM.NOMTM', formgm(i)), ind)
        if (ind .gt. ntyele) goto 999
        tord(i)=ind
    end do
    goto 9000
!
!     VERIFICATION EMMELAGE DE PINCEAUX DU PROGRAMMEUR...
999 continue
    ASSERT(.false.)
!     ------------------------------------------------------------------
!
9000 continue
end subroutine
