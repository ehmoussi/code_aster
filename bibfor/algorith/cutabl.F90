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

subroutine cutabl(indic, nbliac, ajliai, spliai, resocu,&
                  typope, posit, liaiso)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: indic
    integer :: nbliac
    integer :: ajliai
    integer :: spliai
    integer :: posit
    integer :: liaiso
    character(len=1) :: typope
    character(len=24) :: resocu
!
! ----------------------------------------------------------------------
! ROUTINE APPELEE PAR : ALGOCU
! ----------------------------------------------------------------------
!
! MISE A JOUR DES VECTEURS DE LIAISONS
! LE NOMBRE DE LIAISONS EST MIS A JOUR DANS LA ROUTINE
!
! OUT INDIC  :+1 ON A RAJOUTE UNE LIAISON
!             -1 ON A ENLEVE UNE LIAISON
! I/O NBLIAC : NOMBRE DE LIAISONS ACTIVES
! I/O AJLIAI : INDICE DANS LA LISTE DES LIAISONS ACTIVES DE LA DERNIERE
!              LIAISON CORRECTE DU CALCUL
!              DE LA MATRICE DE CONTACT ACM1AT
! I/O SPLIAI : INDICE DANS LA LISTE DES LIAISONS ACTIVES DE LA DERNIERE
!              LIAISON AYANT ETE CALCULEE POUR LE VECTEUR CM1A
! IN  RESOCU : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  TYPOPE : TYPE D'OPERATION DANS LE VECTEUR DES LIAISONS
!                'A' : AJOUTER UNE LIAISON
!                'S' : SUPPRIMER UNE LIAISON
! IN  POSIT  : POSITION POUR AJOUTER UNE LIAISON DANS LE
!              VECTEUR DES LIAISONS ACTIVES
! IN  LIAISO : INDICE DE LA LIAISON A AJOUTER OU SUPPRIMER
!
!
!
!
!
    integer :: ii
    character(len=1) :: typeaj, typesp
    character(len=19) :: liac
    integer :: jliac
!
! ======================================================================
!
    call jemarq()
!
    liac = resocu(1:14)//'.LIAC'
    call jeveuo(liac, 'E', jliac)
!
! --- INITIALISATION DES VARIABLES TYPE DE CONTACT
!
    typeaj = 'A'
    typesp = 'S'
!
    if (typope .eq. typeaj) then
!
! --- ON AJOUTE UNE LIAISON
!
        indic = 1
        zi(jliac-1+posit) = liaiso
        nbliac = nbliac + 1
    else if (typope.eq.typesp) then
!
! --- ON SUPPRIME UNE LIAISON
!
        indic = -1
        do 30 ii = posit, nbliac - 1
            zi(jliac-1+ii) = zi(jliac-1+ii+1)
30      continue
        nbliac = nbliac - 1
        ajliai = ajliai - 1
    endif
!
! --- MISE A JOUR DE L'INDICATEUR POUR LA FACTORISATION DE LA MATRICE
! --- DE CONTACT
!
    spliai = min(spliai,posit-1)
    spliai = min(spliai,nbliac)
    if (ajliai .lt. 0) then
        ajliai = 0
    endif
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
