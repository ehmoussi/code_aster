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

subroutine concom(macor, nblir, macoc, nblic, nbnoco,&
                  nococ)
!
!  ROUTINE CONCOM
!    RECHERCHE DES NOEUDS COMMUNS
!  DECLARATIONS
!    INC    : INDICE SUR LES NOEUD          POUR UNE MAILLE FISSURE
!    INR    : INDICE SUR LES NOEUD          POUR UNE MAILLE REFERENCE
!    MACOC  : TABLEAU DES NOMS DES NOEUDS   POUR UNE MAILLE FISSURE
!    MACOR  : TABLEAU DES NOMS DES NOEUDS   POUR UNE MAILLE REFERENCE
!    NBLIC  : NOMBRE DE NOEUD TESTES        POUR UNE MAILLE FISSURE
!    NBLIR  : NOMBRE DE NOEUD TESTES        POUR UNE MAILLE REFERENCE
!    NBNOCO : NOMBRE DE NOEUD COMMUNS
!    NOCOC  : TABLEAU DE RANG DES NOEUDS    POUR UNE MAILLE FISSURE
!
!  MOT_CLEF : ORIE_FISSURE
!
    implicit none
!
!     ------------------------------------------------------------------
!
    integer :: nbnoco, nblir, inr, nblic, inc, nococ(*)
!
    character(len=8) :: macor(nblir+2), macoc(nblic+2)
!
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    nbnoco = 0
    do 20 inc = 1, nblic
        do 10 inr = 1, nblir
            if (macor(inr+2) .eq. macoc(inc+2)) then
                nbnoco = nbnoco + 1
                nococ(nbnoco) = inc
            endif
10      continue
20  end do
!
end subroutine
