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

subroutine nmeceb(sderro, nombcl, etabcl)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: sderro
    character(len=4) :: nombcl, etabcl
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! ECRITURE DE L'ETAT DE LA BOUCLE
!
! ----------------------------------------------------------------------
!
!
! IN  SDERRO : SD GESTION DES ERREURS
! IN  NOMBCL : NOM DE LA BOUCLE
!               'RESI' - BOUCLE SUR LES RESIDUS D'EQUILIBRE
!               'NEWT' - BOUCLE DE NEWTON
!               'FIXE' - BOUCLE DE POINT FIXE
!               'INST' - BOUCLE SUR LES PAS DE TEMPS
!               'CALC' - CALCUL
! IN  ETABCL : ETAT DE LA BOUCLE
!               'CONT' - ON CONTINUE LA BOUCLE
!               'CTCD' - ON CONTINUE LA BOUCLE APRES LA PREDICTION
!               'CONV' - ON STOPPE LA BOUCLE : CONVERGEE
!               'EVEN' - EVENEMENT PENDANT LA BOUCLE
!               'ERRE' - ON STOPPE LA BOUCLE : ERREUR TRAITEE
!               'STOP' - ON STOPPE LA BOUCLE : ERREUR NON TRAITEE
!
!
!
!
    character(len=24) :: errcvg
    integer :: jeconv
    integer :: iconve
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    iconve = 0
!
! --- ACCES SD
!
    errcvg = sderro(1:19)//'.CONV'
    call jeveuo(errcvg, 'E', jeconv)
!
! --- SELON ETAT
!
    if (etabcl .eq. 'CONT') then
        iconve = 0
    else if (etabcl.eq.'CONV') then
        iconve = 1
    else if (etabcl.eq.'EVEN') then
        iconve = 2
    else if (etabcl.eq.'ERRE') then
        iconve = 3
    else if (etabcl.eq.'STOP') then
        iconve = 4
    else if (etabcl.eq.'CTCD') then
        iconve = 5
    else
        ASSERT(.false.)
    endif
!
! --- ENREGISTREMENT DE LA CONVERGENCE
!
    if (nombcl .eq. 'RESI') then
        zi(jeconv-1+1) = iconve
    else if (nombcl.eq.'NEWT') then
        zi(jeconv-1+2) = iconve
    else if (nombcl.eq.'FIXE') then
        zi(jeconv-1+3) = iconve
    else if (nombcl.eq.'INST') then
        zi(jeconv-1+4) = iconve
    else if (nombcl.eq.'CALC') then
        zi(jeconv-1+5) = iconve
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
