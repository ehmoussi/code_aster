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

subroutine cgnop0(nbnoe, coor, x0, vecnor, prec,&
                  nbno, lisnoe)
    implicit   none
!.=====================================================================
!
!.========================= DEBUT DES DECLARATIONS ====================
!
! -----  ARGUMENTS
    integer :: nbnoe, nbno, lisnoe(*)
    real(kind=8) :: coor(*), x0(*), vecnor(*), prec
!
! --------- VARIABLES LOCALES ---------------------------
    integer :: ino
    real(kind=8) :: x(3), xx0(3), d
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
! --- PARCOURS DES NOEUDS DU MAILLAGE :
!     --------------------------------
    nbno = 0
    do 10 ino = 1, nbnoe
!
! ---     COORDONNEES DU NOEUD :
!         --------------------
        x(1) = coor(3*(ino-1)+1)
        x(2) = coor(3*(ino-1)+2)
        x(3) = coor(3*(ino-1)+3)
!
        xx0(1) = x(1) - x0(1)
        xx0(2) = x(2) - x0(2)
        xx0(3) = x(3) - x0(3)
!
! ---     CALCUL DE LA DISTANCE DU NOEUD COURANT AU PLAN OU A
! ---     LA DROITE :
!         ---------
        d = xx0(1)*vecnor(1) + xx0(2)*vecnor(2) + xx0(3)*vecnor(3)
!
! ---     SI LE NOEUD COURANT EST SITUE DANS LE PLAN OU LA DROITE,
! ---     ON L'AFFECTE A LA LISTE DE NOEUDS QUI SERA AFFECTEE
! ---     AU GROUP_NO :
!         ----------
        if (abs(d) .le. prec) then
            nbno = nbno + 1
            lisnoe(nbno) = ino
        endif
!
10  end do
!.============================ FIN DE LA ROUTINE ======================
end subroutine
