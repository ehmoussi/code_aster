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

subroutine nmdcen(sddisc, numins, nbini, nbins)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/juveca.h"
    character(len=19) :: sddisc
    integer :: nbins, numins, nbini
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - DECOUPE)
!
! EXTENSION DE LA LISTE DES NIVEAUX DE DECOUPAGE
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION
! IN  NUMINS : NUMERO D'INSTANT
! IN  NBINI  : NOMBRE DE PAS DE TEMPS INITIAL
! IN  NBINS  : NOMBRE DE PAS DE TEMPS A INSERER
!
! ----------------------------------------------------------------------
!
    integer :: ipas, nbnew
    character(len=24) :: tpsdin
    integer :: jnivtp
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD
!
    tpsdin = sddisc(1:19)//'.DINI'
!
! --- NOUVEAU NOMBRE D'INSTANTS
!
    nbnew = nbini + nbins
!
! --- ALLONGEMENT DE LA LISTE DES NIVEAUX
!
    call juveca(tpsdin, nbnew)
    call jeveuo(tpsdin, 'E', jnivtp)
!
! --- RECOPIE DE LA PARTIE HAUTE DE LA LISTE
!
    do 10 ipas = nbnew, numins+nbins, -1
        zi(jnivtp-1+ipas) = zi(jnivtp-1+ipas-nbins)
10  end do
!
! --- INCREMENTATION DU NIVEAU SUR LA PARTIE DECOUPEE
!
    do 20 ipas = numins, numins+nbins-1
        zi(jnivtp-1+ipas) = zi(jnivtp-1+ipas)+1
20  end do
!
    call jedema()
end subroutine
