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

subroutine reflth(ang, li, lr)
!.......................................................................
    implicit none
! .                                                                    .
! .  - FONCTION REALISEE : CALCULE LE PASSAGE DES TERMES DE CONDUCTIVITE
! .                        DU REPERE DE REFERENCE AU REPERE DE L'ELEMENT
! .  - ARGUMENTS :                                                     .
! .                                                                    .
! .      ENTREE :                                                      .
! .                   ANG --> COSINUS ET SINUS DE LA MATRICE DE PASSAGE.
! .                   LI  --> DILATATION ELEMENTAIRE REPERE DE REFERENCE
! .      SORTIE :                                                      .
! .                   LR  <-- DILATATION ELEMENTAIRE REPERE DE L'ELEMENT
! .                                                                    .
!.......................................................................
    real(kind=8) :: ang(2), li(3), lr(3)
    real(kind=8) :: f, c, s, c2, s2
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    f=(ang(1)**2+ang(2)**2)**0.5d0
    c=ang(1)/f
    s=ang(2)/f
    c2=c**2
    s2=s**2
    lr(1)=c2*li(1)+s2*li(2)-2.d0*c*s*li(3)
    lr(2)=s2*li(1)+c2*li(2)+2.d0*c*s*li(3)
    lr(3)=c*s*li(1)-c*s*li(2)+(c2-s2)*li(3)
end subroutine
