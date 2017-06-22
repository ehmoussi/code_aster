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

subroutine xexiar(vnbadj, vladj, nadjmx, vnuadj, inoa, nunoa, inob, nunob, numar)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer, intent(in) :: vnbadj(:)
    integer, intent(in) :: nadjmx
    integer, intent(in) :: vladj(:)
    integer, intent(in) :: vnuadj(:)
    integer, intent(in) :: inoa, inob
    integer, intent(in) :: nunoa, nunob
    integer, intent(out) :: numar
! person_in_charge: patrick.massin at edf.fr
!
!    But : chercher si une arete (a, b) a ete stockee dans le tableau de liste d'ajacence,
!          et renvoyer son numero le cas echeant
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
!              inoa   : indice du premier noeud a dans vnbadj
!              nunoa  : numero absolu du noeud a
!              inob   : indice du noeud b dans vnbadj
!              nunob  : numero absolu du noeud b
!
!    Sortie :
!              numar  : deux valeurs possibles :
!                          - numero de l'arete (a, b), si elle est stockee dans le tableau
!                            de listes d'adjacence
!                          - 0, sinon
!     ------------------------------------------------------------------
!
    integer :: iadj, iadja, iadjb

    call jemarq()

    ! recherche de b dans la liste des adjacents de a
    iadja=0
    do iadj=1, vnbadj(inoa)
       if (vladj(nadjmx*(inoa - 1) + iadj) .eq. nunob) then
          ! ici, on a trouve l'arete cherchee
          iadja=iadj
          exit
       endif
    end do
!
    ! recherche de a dans la liste des adjacents de b
    iadjb=0
    do iadj=1, vnbadj(inob)
       if (vladj(nadjmx*(inob - 1) + iadj) .eq. nunoa) then
          ! ici, on a trouve l'arete cherchee
          iadjb=iadj
          exit
       endif
    end do
!
    ! assertion : deux cas possibles
    !   * a est dans la liste de b et b dans la liste de a
    !   * a n'est pas dans la liste de b et b n'est pas dans
    !     la liste de a
    ASSERT((iadja .ne. 0 .and. iadjb .ne. 0) .or. (iadja .eq. 0 .and. iadjb .eq. 0))
!
    ! initialisation de numar : cas ou l'arete n'est pas stockee
    numar=0

    ! l'arete est deja stockee ssi a est pas dans la liste
    ! d'adjacents de b et b est dans la liste d'edjacents de a
    if (iadja .ne. 0 .and. iadjb .ne. 0) then
!      cas ou  l'arete est deja stockee :
!      recuperation du numero de l'arete
       numar=vnuadj(nadjmx*(inoa - 1) + iadja)
    endif

    call jedema()

end subroutine
