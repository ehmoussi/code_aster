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

subroutine nmbudi(modele, numedd, lischa, veclag, vebudi,&
                  cnbudi, matass)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assvec.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmdebg.h"
#include "asterfort/vebume.h"
    character(len=19) :: lischa, matass
    character(len=24) :: modele, numedd
    character(len=19) :: veclag
    character(len=19) :: vebudi, cnbudi
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! CALCUL DES CONDITIONS DE DIRICHLET B.U
!
! ----------------------------------------------------------------------
!
!
! IN  MODELE : NOM DU MODELE
! IN  NUMEDD : NOM DE LA NUMEROTATION
! IN  LISCHA : LISTE DES CHARGES
! IN  VECLAG : VECTEUR D'INCONNUES PORTANT LES LAGRANGES
! OUT VEBUDI : VECT_ELEM DES CONDITIONS DE DIRICHLET B.U
! OUT CNBUDI : VECT_ASSE DES CONDITIONS DE DIRICHLET B.U
! IN  MATASS : SD MATRICE ASSEMBLEE
!
!
!
!
    integer :: ifm, niv
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... ASSEMBLAGE DES REACTIONS '//&
        'D''APPUI'
    endif
!
! --- CALCUL <CNBUDI>
!
    call vebume(modele, matass, veclag, lischa, vebudi)
!
! --- ASSEMBLAGE <CNBUDI>
!
    call assvec('V', cnbudi, 1, vebudi, [1.d0],&
                numedd, ' ', 'ZERO', 1)
!
    if (niv .ge. 2) then
        call nmdebg('VECT', cnbudi, 6)
    endif
!
    call jedema()
end subroutine
