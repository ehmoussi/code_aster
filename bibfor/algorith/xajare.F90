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

subroutine xajare(vnbadj, vladj, nadjmx, vnuadj, inoa, nunoa, inob, nunob, nbedge)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer, intent(inout) :: vnbadj(:)
    integer, intent(in) :: nadjmx
    integer, intent(inout) :: vladj(:)
    integer, intent(inout) :: vnuadj(:)
    integer, intent(in) :: inoa, inob
    integer, intent(in) :: nunoa, nunob
    integer, intent(inout) :: nbedge
! person_in_charge: patrick.massin at edf.fr
!
!    But : stocker l'arete 'a, b) dans le tableau de liste d'ajacence,
!          et renvoyer son numero
!
!    Entrees :
!              vnbadj : nombre de noeuds adjacents a chaque noeud
!              nadjmx : nombre maximum de noeuds adjacents a un noeud
!              vladj  : liste des noeuds adjacents a chaque noeud
!                       la liste de noeuds adjacents au noeud d'indice ino
!                       est de longueur vnbadj(ino) et elle stockee dans :
!                         vladj(nadjmx*(ino - 1) + 1:nadjmx*(ino - 1) + vnbadj(ino))
!                       N.B.: vladj(:) stocke des numeros de noeuds absolus
!              vnuadj : stockage des numeros d'aretes stockes dans les listes d'adjacence
!              nbedge : nombre d'arete stockees dans le tableau de listes d'adjacence
!              inoa   : indice du premier noeud a dans vnbadj
!              nunoa  : numero absolu du noeud a
!              inob   : indice du noeud b dans vnbadj
!              nunob  : numero absolu du noeud b
!
!    Sortie :
!              nbedge : le nombre d'arete stockee est incrementee
!     ------------------------------------------------------------------
!
    call jemarq()

    ! stockage de b dans la liste des adjacents de a
    vnbadj(inoa) = vnbadj(inoa) + 1
!
    ! verification du nombre d'adjacents stockes
    ! dans la liste des adjacents de a
    ASSERT(vnbadj(inoa) .le. nadjmx)
!
    vladj(nadjmx*(inoa - 1) + vnbadj(inoa)) = nunob
!
    ! stockage de a dans la liste des adjacents de b
    vnbadj(inob) = vnbadj(inob) + 1
!
    ! verification du nombre d'adjacents stockes
    ! dans la liste des adjacents de b
    ASSERT(vnbadj(inob) .le. nadjmx)
!
    vladj(nadjmx*(inob - 1) + vnbadj(inob)) = nunoa
!
    ! incrementation du nombre d'aretes stockees
    nbedge = nbedge + 1

    ! numerotation de l'arete
    vnuadj(nadjmx*(inoa - 1) + vnbadj(inoa)) = nbedge
    vnuadj(nadjmx*(inob - 1) + vnbadj(inob)) = nbedge

    call jedema()

end subroutine
