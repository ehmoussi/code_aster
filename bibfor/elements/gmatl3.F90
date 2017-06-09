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

subroutine gmatl3(nnoff, milieu, connex, &
                  abscur, vect)

implicit none

#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/gmate3.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"

    integer           :: nnoff
    character(len=24) :: abscur
    character(len=24) :: vect
    aster_logical     :: milieu, connex
!
!       CALCUL DE LA MATRICE DU SYSTEME LINEAIRE [A] {GS} = {GTHI}
!       POUR LA METHODE THETA-LAGRANGE ET G-LAGRANGE
!       MATRICE LUMPEE    
!
! ENTREE
!
!   NNOFF    --> NOMBRE DE NOEUDS DU FOND DE FISSURE
!   ABSCUR   --> ABSCISSES CURVILIGNES S
!   MILIEU   --> .TRUE.  : ELEMENT QUADRATIQUE
!                .FALSE. : ELEMENT LINEAIRE
!   CONNEX   --> .TRUE.  : FOND DE FISSURE FERME
!                .FALSE. : FOND DE FISSURE OUVERT
!
! SORTIE
!
!   VECT     --> MATRICE DU SYTEME A RESOUDRE
! ......................................................................

    integer          :: nseg, iseg, ivect
    integer          :: i, j, nno, conn(3)
    real(kind=8)     :: mele(3, 3), mlump(3)
    character(len=8) :: elrefe

! ......................................................................

    call jemarq()

!   NOMBRE DE SEGMENT DU FOND DE FISSURE
    if (milieu) then
        nseg = (nnoff-1)/2
        elrefe = 'SE3'
    else
        nseg = nnoff-1    
        elrefe = 'SE2'
    endif       

    conn(1:3) = 0

!   CREA OBJET TEMP POUR LA VAL DE GLEGEN A ABSC CURV S
    call wkvect(vect, 'V V R8', nnoff, ivect)

!   BOUCLE SUR LES SEGMENTS
    do iseg = 1, nseg      

        if (milieu) then
            conn(1) = 2*iseg-1
            conn(2) = 2*iseg+1
            conn(3) = 2*iseg
        else
            conn(1) = iseg
            conn(2) = iseg+1
        endif
!
!       CALCUL DE LA MATRICE ELEMENTAIRE POUR L'ELEMENT COURANT
        call gmate3(abscur, elrefe, conn, nno, mele)
!
!       LUMP DE LA MATRICE DE MASSE ELEMENTAIRE     
        mlump = 0.d0
        do i=1, nno
            mlump(i) = 0.d0
            do j=1, nno
               mlump(i) = mlump(i) + mele(i, j)
            end do
        end do

!       AJOUT DE LA CONTRIBUTION DE DE LA MATRICE DE MASSE ELEMENTAIRE
!       A LA MATRICE DE MASSE ASSEMBLEE
        do i=1, nno
            zr(ivect + conn(i) - 1) = zr(ivect + conn(i) - 1) + mlump(i)
        end do

    end do

!------------------------FOND DE FISSURE FERME--------------------------!
!   * on ajoute la contibution du noeud 1 au noeud nnoff                !
!   * on ajoute la contibution du noeud nnoff au noeud 1                !
!-----------------------------------------------------------------------!
    if (connex) then
        zr(ivect + nnoff - 1) = zr(ivect + nnoff - 1) + zr(ivect + 1 - 1)
        zr(ivect + 1     - 1) = zr(ivect + nnoff - 1)
    endif

    call jedema()

end subroutine
