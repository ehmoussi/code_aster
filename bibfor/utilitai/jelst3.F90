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

subroutine jelst3(base, dest, nmax, ntotal)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelstc.h"
#include "asterfort/jemarq.h"
    character(len=1) :: base
    character(len=24) :: dest(*)
    integer :: nmax, ntotal
! BUT : FABRIQUER UNE LISTE DE NOMS CONTENANT LE NOM DE TOUS LES OBJETS
!       TROUVES SUR UNE BASE ET DONT LE NOM CONTIENT UNE CERTAINE CHAINE
! ----------------------------------------------------------------------
! BASE   IN  K1 : NOM DE LA BASE : 'G'/'V'/'L'/' '  A SCRUTER
! SOUCH  IN  K* : CHAINE A CHERCHER DANS LE NOM
! IPOS   IN  I  : POSITION DU DEBUT DE LA CHAINE
!                 SI IPOS=0 : ON IGNORE SOUCH, ON PREND TOUS LES OBJETS
! BASE2  IN  K1 : NOM DE LA BASE POUR LA CREATION DE PTNOM
! PTNOM  IN/JXOUT K24 : NOM DU POINTEUR DE NOM A CREER.
! ----------------------------------------------------------------------
    integer :: nbval
!
    call jemarq()
!
!
!     1. RECUPERATION DE LA LISTE DES OBJETS :
!     --------------------------------------------------------------
    call jelstc(base, ' ', 0, nmax, dest,&
                nbval)
    if (nbval .lt. 0) then
        ntotal = -nbval
    else
        ntotal = nbval
    endif
    call jedema()
!
end subroutine
