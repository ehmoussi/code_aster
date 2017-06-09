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

subroutine titre2(nomcon, nomcha, nomobj, motfac, iocc,&
                  formr, nomsym, iordr)
    implicit none
#include "asterfort/titrea.h"
    character(len=*) :: nomcon, nomcha, nomobj, motfac, formr
    character(len=*), optional, intent(in) :: nomsym
    integer, optional, intent(in) :: iordr
    integer :: iocc
!     CREATION D'UN SOUS-TITRE
!     ------------------------------------------------------------------
! IN  NOMCON : K8  : NOM DU RESULTAT
! IN  NOMCHA : K19 : NOM DU CHAMP A TRAITER DANS LE CAS D'UN RESULTAT
! IN  NOMOBJ : K24 : NOM DE L'OBJET DE STOCKAGE
! IN  MOTFAC : K16 : NOM DU MOT CLE FACTEUR SOUS LEQUEL EST LE S-TITRE
! IN  IOCC   : IS  : OCCURRENCE CONCERNEE SI L'ON A UN MOT CLE FACTEUR
! IN  FORMR  : K*  : FORMAT DES REELS DANS LE TITRE
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call titrea('S', nomcon, nomcha, nomobj, 'D',&
                motfac, iocc, 'V', formr, nomsym,&
                iordr)
end subroutine
