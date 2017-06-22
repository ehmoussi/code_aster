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

subroutine lect82(iunv, node, nbnode, inum)
! aslint: disable=W1306
    implicit none
!     ================================================================
!A PRESUPER
!
!     =============================================================
!     !                                                           !
!     !  FONCTION: LECTURE DES NOEUDS DES TRACELINES IDEAS .      !
!     !            !!!!!   (DATASET 82 !!!!!                      !
!     !       (CF. DOCUMENT INTERFACE SUPERTAB-ASTER )            !
!     =============================================================
!     !                                                           !
!     !  ROUTINE APPELANTE: SLEELT                                !
!     !                                                           !
!     =============================================================
!     !                                                           !
!     !                 ***************                           !
!     !                 *  ARGUMENTS  *                           !
!     !                 ***************                           !
!     !                                                           !
!     !  ******************************************************** !
!     !  *   NOM     * TYPE  * MODE *ALTERE *     ROLE          * !
!     !  ******************************************************** !
!     !  *           *       *      *       *                   * !
!     !  * NBNODE    *INTEGER*ENTREE* NON   * NBRE DE NOEUDS DE * !
!     !  *           *       *      *       *  CETTE MAILLE     * !
!     !  *           *       *      *       *                   * !
!     !  * NODE      *INTEGER*SORTIE* NON   * TABLEAU DES NOEUDS* !
!     !  *           *       *      *       *(PARFOIS PERMUTES) * !
!     !  *           *       *      *       * DE LA MAILLE      * !
!     !  *           *       *      *       *                   * !
!     !  * INUM      *INTEGER*SORTIE* NON   * NOMBRE MAX DE     * !
!     !  *           *       *      *       * NOEUDS LUS        * !
!     !  *           *       *      *       *                   * !
!     !  ******************************************************** !
!     !                                                           !
!     !   VARIABLES LOCALES:  NODLU(2)--> TABLEAU DE TRAVAIL      !
!     !   ------------------                                      !
!     =============================================================
!
!
!  --> DECLARATION DES ARGUMENTS
!     ============================================================
!
    integer :: node(*), nbnode, inum, idro, iunv
!  --> DECLARATION DES VARIABLES LOCALES
    integer :: nodlu(nbnode)
!  --> DECLARATION DES INDICES DE BOUCLES
    integer :: i, j
!
!     ---------- FIN DECLARATIONS -----------
!
    read (iunv,'(8I10)') (nodlu(j),j=1,nbnode)
    idro=1
    inum=1
    do 669 i = 1, nbnode
        if ((nodlu(i).ne.0) .and. (i.lt.nbnode)) then
            node(idro)=nodlu(i)
            node(idro+1)=nodlu(i+1)
            idro=idro+2
            inum = inum + 1
! cas ou on commence par un 0
        else if ((nodlu(i).eq.0).and.(i.eq.1)) then
            idro=idro
            inum = inum
        else if ((nodlu(i).eq.0).and.(i.lt.nbnode)) then
            idro=idro-2
            inum = inum - 1
        else if ((nodlu(i).eq.0).and.(i.ge.nbnode)) then
            idro=idro-2
            inum = inum - 1
            goto 669
        endif
669  end do
end subroutine
